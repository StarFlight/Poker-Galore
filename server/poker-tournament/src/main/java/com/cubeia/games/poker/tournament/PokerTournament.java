/**
 * Copyright (C) 2010 Cubeia Ltd <info@cubeia.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.cubeia.games.poker.tournament;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import org.apache.log4j.Logger;
import org.apache.log4j.MDC;

import com.cubeia.firebase.api.action.UnseatPlayersMttAction.Reason;
import com.cubeia.firebase.api.action.mtt.MttDataAction;
import com.cubeia.firebase.api.action.mtt.MttObjectAction;
import com.cubeia.firebase.api.action.mtt.MttRoundReportAction;
import com.cubeia.firebase.api.action.mtt.MttTablesCreatedAction;
import com.cubeia.firebase.api.lobby.LobbyAttributeAccessor;
import com.cubeia.firebase.api.mtt.MttInstance;
import com.cubeia.firebase.api.mtt.lobby.DefaultMttAttributes;
import com.cubeia.firebase.api.mtt.model.MttPlayer;
import com.cubeia.firebase.api.mtt.seating.SeatingContainer;
import com.cubeia.firebase.api.mtt.support.MTTStateSupport;
import com.cubeia.firebase.api.mtt.support.MTTSupport;
import com.cubeia.firebase.api.mtt.support.registry.PlayerInterceptor;
import com.cubeia.firebase.api.mtt.support.registry.PlayerListener;
import com.cubeia.firebase.api.mtt.support.tables.Move;
import com.cubeia.firebase.api.mtt.support.tables.TableBalancer;
import com.cubeia.games.poker.io.protocol.TournamentOut;
import com.cubeia.games.poker.tournament.state.PokerTournamentState;
import com.cubeia.games.poker.tournament.state.PokerTournamentStatus;
import com.cubeia.games.poker.tournament.util.ProtocolFactory;

public class PokerTournament extends MTTSupport {

    // Use %X{pokerid} in the layout pattern to include this information.
	private static final String MDC_TAG = "pokerid";
	
	private static transient Logger log = Logger.getLogger(PokerTournament.class);

	private static final Long STARTING_CHIPS = Long.valueOf(100000);
	
	private transient PokerTournamentUtil util = new PokerTournamentUtil();
	
	@Override
	public PlayerInterceptor getPlayerInterceptor(MTTStateSupport state) {
		return new PokerTournamentInterceptor(this);
	}

	@Override
	public PlayerListener getPlayerListener(MTTStateSupport state) {
		return new PokerTournamentListener(this);
	}

	@Override
	public void process(MttRoundReportAction action, MttInstance instance) {
		try {
			MDC.put(MDC_TAG, "Tournament["+instance.getId()+"]");
		    if (log.isDebugEnabled()) {
		        log.debug("Process round report from table[" + action.getTableId() + "] Report: "+action);
		    }
	
			MTTStateSupport state = util.getStateSupport(instance);
			PokerTournamentRoundReport report = (PokerTournamentRoundReport) action.getAttachment();
	
			updateBalances(report, (PokerTournamentState) state.getState());
			Set<Integer> playersOut = getPlayersOut(report);
			log.info("Players out of tournament["+instance.getId()+"] : "+playersOut);
			handlePlayersOut(state, action.getTableId(), playersOut);
			sendTournamentOutToPlayers(playersOut, instance);
			boolean tableClosed = balanceTables(state, action.getTableId());
	
			if (isTournamentFinished(state)) {
				handleFinishedTournament(instance);
			} else {		
				if (!tableClosed) {
					startNextRoundIfPossible(action.getTableId(), state);
				}
			}
	
			if (log.isDebugEnabled()) {
			    log.debug("Remaining players: " + state.getRemainingPlayerCount() + " Remaining tables: " + state.getTables());
			}
			updateLobby(instance);
		} finally {
	    	MDC.remove(MDC_TAG);
	    }
	}


    private void handleFinishedTournament(MttInstance instance) {
	    log.info("Tournament ["+instance.getId()+":"+instance.getState().getName()+"] was finished.");
		util.setTournamentStatus(instance, PokerTournamentStatus.FINISHED);
		
		// Find winner
		MTTStateSupport state = (MTTStateSupport)instance.getState();
		Integer table = state.getTables().iterator().next();
		Collection<Integer> winners = state.getPlayersAtTable(table);
		sendTournamentOutToPlayers(winners, instance);
		
	}

	private boolean isTournamentFinished(MTTStateSupport state) {
		return state.getRemainingPlayerCount() == 1;
	}

	private void startNextRoundIfPossible(int tableId, MTTStateSupport state) {
		if (state.getPlayersAtTable(tableId).size() > 1) {
			sendRoundStartActionToTable(state, tableId);
		}
	}

	/**
	 * Tries to balance the tables by moving one or more players from this table to other 
	 * tables.
	 * 
	 * @param state
	 * @param tableId
	 * @return <code>true</code> if the table was closed
	 */
	private boolean balanceTables(MTTStateSupport state, int tableId) {
		TableBalancer balancer = new TableBalancer();
		List<Move> moves = balancer.calculateBalancing(createTableToPlayerMap(state), state.getSeats(), tableId);
		return applyBalancing(moves, state, tableId);
	}

	/**
	 * Applies balancing by moving players to the destination table.
	 * 
	 * @param moves
	 * @param state
	 * @param sourceTableId the table we are moving player from
	 * @return true if table is closed
	 */
	private boolean applyBalancing(List<Move> moves, MTTStateSupport state, int sourceTableId) {
		PokerTournamentState pokerState = util.getPokerState(state);
		Set<Integer> tablesToStart = new HashSet<Integer>();
		
		for (Move move : moves) {
			int tableId = move.getDestinationTableId();
			int playerId = move.getPlayerId();

			movePlayer(state, playerId, tableId, -1, Reason.BALANCING, pokerState.getPlayerBalance(playerId));
			// Move the player, we don't care which seat he gets put at, so set
			// it to -1.
			Collection<Integer> playersAtDestinationTable = state.getPlayersAtTable(tableId);
			if (playersAtDestinationTable.size() == 2) {
				// There was only one player at the table before we moved this
				// player there, start a new round.
			    tablesToStart.add(tableId);
			}
		}
		
		for (int tableId : tablesToStart) {
		    if (log.isDebugEnabled()) {
		        log.debug("Sending explicit start to table["+tableId+"] due to low number of players.");
		    }
            sendRoundStartActionToTable(state, tableId);
        }
		
		return closeTableIfEmpty(sourceTableId, state);
	}

	private boolean closeTableIfEmpty(int tableId, MTTStateSupport state) {
		if (state.getPlayersAtTable(tableId).isEmpty()) {
			closeTable(state, tableId);
			return true;
		}
		
		return false;
	}

	/**
	 * Creates a map mapping tableId to a collection of playerIds of the players
	 * sitting at the table.
	 * 
	 * @param state
	 *            the state
	 * @return the map
	 */
	private Map<Integer, Collection<Integer>> createTableToPlayerMap(MTTStateSupport state) {
		Map<Integer, Collection<Integer>> map = new HashMap<Integer, Collection<Integer>>();

		// Go through the tables.
		for (Integer tableId : state.getTables()) {
			List<Integer> players = new ArrayList<Integer>();
			// Add all players at this table.
			players.addAll(state.getPlayersAtTable(tableId));
			
			if (players.size() > 0) {
				// Put it in the map.
				map.put(tableId, players);
			}
		}

		return map;
	}

	// private Random rng = new Random();

	private Set<Integer> getPlayersOut(PokerTournamentRoundReport report) {
		Set<Integer> playersOut = new HashSet<Integer>();

		for (Entry<Integer, Long> balance : report.getBalances()) {
			if (balance.getValue() <= 0) {
				playersOut.add(balance.getKey());
			}
		}
		
		// FIXME: Remove this when balances are updated.
//		if (playersOut.isEmpty()) {
//			for (Entry<Integer, Long> balance : report.getBalances()) {
//				int value = rng.nextInt(100);
//				if (value < 60) {
//					playersOut.add(balance.getKey());
//					if (playersOut.size() >= report.getBalances().size()-1) {
//					    break;
//					}
//				}
//			}
//		}
		
		log.debug("These players have 0 balance and are out: "+playersOut);
		return playersOut;
	}

	private void updateBalances(PokerTournamentRoundReport report, PokerTournamentState state) {
		for (Entry<Integer, Long> balance : report.getBalances()) {
			state.setBalance(balance.getKey(), balance.getValue());
		}
	}

	private void handlePlayersOut(MTTStateSupport state, int tableId, Set<Integer> playersOut) {
		unseatPlayers(state, tableId, playersOut, Reason.OUT);
	}

	@Override
	public void process(MttTablesCreatedAction action, MttInstance instance) {
		try {
			MDC.put(MDC_TAG, "Tournament["+instance.getId()+"]");
			MTTStateSupport state = (MTTStateSupport) instance.getState();
			PokerTournamentState pokerState = (PokerTournamentState) state.getState();
			if (pokerState.allTablesHaveBeenCreated(state.getTables().size())) {
				seatPlayers(state, createInitialSeating(state.getPlayerRegistry().getPlayers(), state.getTables(), pokerState));
				scheduleTournamentStart(instance);
			}
		} finally {
	    	MDC.remove(MDC_TAG);
	    }
	}

	private void scheduleTournamentStart(MttInstance instance) {
		MttObjectAction action = new MttObjectAction(instance.getId(), TournamentTrigger.START);
		instance.getScheduler().scheduleAction(action, 10000);
	}

	private Collection<SeatingContainer> createInitialSeating(Collection<MttPlayer> players, Set<Integer> tableIds, PokerTournamentState state) {
		List<SeatingContainer> initialSeating = new ArrayList<SeatingContainer>();
		Integer[] tableIdArray = new Integer[tableIds.size()];
		tableIds.toArray(tableIdArray);

		int i = 0;
		for (MttPlayer player : players) {
			state.setBalance(player.getPlayerId(), getStartingChips());
			initialSeating.add(createSeating(player.getPlayerId(), tableIdArray[i++ % tableIdArray.length]));
		}

		return initialSeating;
	}

	private SeatingContainer createSeating(int playerId, int tableId) {
		return new SeatingContainer(playerId, tableId, getStartingChips());
	}

	@Override
	public void process(MttObjectAction action, MttInstance instance) {
		try {
			MDC.put(MDC_TAG, "Tournament["+instance.getId()+"]");
			MTTStateSupport state = (MTTStateSupport) instance.getState();
			Object command = action.getAttachment();
			if (command instanceof TournamentTrigger) {
				TournamentTrigger trigger = (TournamentTrigger) command;
				switch (trigger) {
				case START:
					log.debug("START TOURNAMENT!");
					sendRoundStartActionToTables(state, state.getTables());
					break;
				}
			}
		} finally {
	    	MDC.remove(MDC_TAG);
	    }

	}

	@Override
	public void tournamentCreated(MttInstance mttInstance) {
		// TODO Auto-generated method stub

	}

	public void tournamentDestroyed(MttInstance mttInstance) {
		// TODO Auto-generated method stub

	}

	private Long getStartingChips() {
		return STARTING_CHIPS;
	}

	private void updateLobby(MttInstance mttInstance) {
		LobbyAttributeAccessor lobby = mttInstance.getLobbyAccessor();
		lobby.setIntAttribute(DefaultMttAttributes.ACTIVE_PLAYERS.name(), mttInstance.getState().getRemainingPlayerCount());
	}
	
	private void sendTournamentOutToPlayers(Collection<Integer> playersOut, MttInstance instance) {
	    for (int pid : playersOut) {
	        TournamentOut packet = new TournamentOut();
	        packet.position = instance.getState().getRemainingPlayerCount();
	        MttDataAction action = ProtocolFactory.createMttAction(packet, pid, instance.getId());
	        getMttNotifier().notifyPlayer(pid, action);
	        // instance.getMttNotifier().notifyPlayer(pid, action);
	    }
    }
}
