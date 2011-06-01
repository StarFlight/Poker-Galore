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

package com.cubeia.games.poker.adapter;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Currency;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.log4j.Logger;

import ca.ualberta.cs.poker.Card;

import com.cubeia.backoffice.accounting.api.Money;
import com.cubeia.firebase.api.action.GameAction;
import com.cubeia.firebase.api.action.GameDataAction;
import com.cubeia.firebase.api.action.GameObjectAction;
import com.cubeia.firebase.api.action.mtt.MttRoundReportAction;
import com.cubeia.firebase.api.common.AttributeValue;
import com.cubeia.firebase.api.game.context.GameContext;
import com.cubeia.firebase.api.game.lobby.LobbyTableAttributeAccessor;
import com.cubeia.firebase.api.game.player.GenericPlayer;
import com.cubeia.firebase.api.game.player.PlayerStatus;
import com.cubeia.firebase.api.game.table.Table;
import com.cubeia.firebase.api.game.table.TableType;
import com.cubeia.firebase.api.service.ServiceRegistry;
import com.cubeia.firebase.api.util.UnmodifiableSet;
import com.cubeia.games.poker.FirebaseState;
import com.cubeia.games.poker.PokerGame;
import com.cubeia.games.poker.cache.ActionCache;
import com.cubeia.games.poker.handler.Trigger;
import com.cubeia.games.poker.handler.TriggerType;
import com.cubeia.games.poker.io.protocol.DealHiddenCards;
import com.cubeia.games.poker.io.protocol.DealPrivateCards;
import com.cubeia.games.poker.io.protocol.DealPublicCards;
import com.cubeia.games.poker.io.protocol.DealerButton;
import com.cubeia.games.poker.io.protocol.Enums;
import com.cubeia.games.poker.io.protocol.ExposePrivateCards;
import com.cubeia.games.poker.io.protocol.HandEnd;
import com.cubeia.games.poker.io.protocol.PerformAction;
import com.cubeia.games.poker.io.protocol.PlayerPokerStatus;
import com.cubeia.games.poker.io.protocol.Pot;
import com.cubeia.games.poker.io.protocol.RequestAction;
import com.cubeia.games.poker.jmx.PokerStats;
import com.cubeia.games.poker.logic.TimeoutCache;
import com.cubeia.games.poker.model.PokerPlayerImpl;
import com.cubeia.games.poker.persistence.history.HandHistoryDAO;
import com.cubeia.games.poker.persistence.history.model.EventType;
import com.cubeia.games.poker.persistence.history.model.PlayedHand;
import com.cubeia.games.poker.persistence.history.model.PlayedHandEvent;
import com.cubeia.games.poker.tournament.PokerTournamentRoundReport;
import com.cubeia.games.poker.util.ProtocolFactory;
import com.cubeia.games.poker.util.WalletAmountConverter;
import com.cubeia.network.wallet.firebase.api.WalletServiceContract;
import com.cubeia.network.wallet.firebase.domain.ResultEntry;
import com.cubeia.network.wallet.firebase.domain.RoundResultResponse;
import com.cubeia.poker.PokerState;
import com.cubeia.poker.action.ActionRequest;
import com.cubeia.poker.action.PokerAction;
import com.cubeia.poker.adapter.HandEndStatus;
import com.cubeia.poker.adapter.ServerAdapter;
import com.cubeia.poker.model.PlayerHands;
import com.cubeia.poker.player.PokerPlayer;
import com.cubeia.poker.player.PokerPlayerStatus;
import com.cubeia.poker.result.HandResult;
import com.cubeia.poker.result.Result;
import com.cubeia.poker.timing.Periods;
import com.cubeia.poker.tournament.RoundReport;
import com.board.games.service.PokerBoardServiceContract;
import com.google.inject.Inject;

/**
 * Firebase implementation of the poker logic's server adapter.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class FirebaseServerAdapter implements ServerAdapter {

	private transient static Logger log = Logger.getLogger(FirebaseServerAdapter.class);

    private WalletAmountConverter amountConverter = new WalletAmountConverter();
    
	@Inject
	ActionCache cache;
	
	@Inject
	GameContext gameContext;

	@Inject
	Table table;
	
	@Inject 
	PokerState state;
	
    int handCount;

//    @Inject
//    private PokerCEPService pokerCepService;
	
	
	/*------------------------------------------------
	 
		ADAPTER METHODS
		
		These methods are the adapter interface
		implementations

	 ------------------------------------------------*/
	
	public void notifyNewHand() {
	    PlayedHand playedHand = new PlayedHand();
	    playedHand.setTableId(table.getId());
	    playedHand.setEvents(new HashSet<PlayedHandEvent>());
	    getFirebaseState().setPlayerHand(playedHand);
        
        log.debug("Starting new hand. FBPlayers: "+table.getPlayerSet().getPlayerCount()+", PokerPlayers: "+state.getSeatedPlayers().size());
        
 	   log.debug("Reset player winner flag");
		for (PokerPlayer p : state.getSeatedPlayers()) {
			p.setHandWinnerFl(0);
			// to check: may not need it, not sure?
			notifyPlayerStatusChanged(p.getId(), PokerPlayerStatus.NORMAL, p.getImageUrl(), 0);
		}
        
    }

	
	public void notifyDealerButton(int seat) {
		DealerButton packet = new DealerButton();
		packet.seat = (byte)seat;
		GameDataAction action = ProtocolFactory.createGameAction(packet, 0, table.getId());
		sendPublicPacket(action, -1);
		
		addEventToHandHistory(seat, EventType.DEALER_BUTTON, null);
	}
	
	public void requestAction(ActionRequest request) {
		RequestAction packet = ActionTransformer.transform(request);
		GameDataAction action = ProtocolFactory.createGameAction(packet, request.getPlayerId(), table.getId());
		sendPublicPacket(action, -1);
		setRequestSequence(packet.seq, packet.player);
		
		// Schedule timeout inc latency grace period
		long latency = state.getTimingProfile().getTime(Periods.LATENCY_GRACE_PERIOD);
		schedulePlayerTimeout(request.getTimeToAct()+latency, request.getPlayerId(), packet.seq);
	}


    public void scheduleTimeout(long millis) {
		GameObjectAction action = new GameObjectAction(table.getId());
		TriggerType type = TriggerType.TIMEOUT;
        Trigger timeout = new Trigger(type); 
        timeout.setSeq(-1);
		action.setAttachment(timeout);
		table.getScheduler().scheduleAction(action, millis);
		setRequestSequence(-1, 0);
	}
	
	public void notifyActionPerformed(PokerAction pokerAction) {
		PokerPlayer pokerPlayer = state.getPokerPlayer(pokerAction.getPlayerId());
		PerformAction packet = ActionTransformer.transform(pokerAction, pokerPlayer);
		GameDataAction action = ProtocolFactory.createGameAction(packet, pokerAction.getPlayerId(), table.getId());
		sendPublicPacket(action, -1);
		addEventToHandHistory(pokerAction);
	}


    public void notifyCommunityCards(List<Card> cards) {
		DealPublicCards packet = ActionTransformer.createPublicCardsPacket(cards);
		GameDataAction action = ProtocolFactory.createGameAction(packet, 0, table.getId());
		sendPublicPacket(action, -1);
	}

	
	public void notifyPrivateCards(int playerId, List<Card> cards) {
		// Send the private cards to the owner
		DealPrivateCards packet = ActionTransformer.createPrivateCardsPacket(cards);
		GameDataAction action = ProtocolFactory.createGameAction(packet, playerId, table.getId());
		table.getNotifier().notifyPlayer(playerId, action);
		
		// Send card count (i.e. not the card-values) to the other players
		DealHiddenCards notification = ActionTransformer.createHiddenCardsPacket(playerId, cards.size());
		GameDataAction ntfyAction = ProtocolFactory.createGameAction(notification, playerId, table.getId());
		sendPublicPacket(ntfyAction, playerId);
	}
	
	
	public void exposePrivateCards(int playerId, List<Card> cards) {
		ExposePrivateCards packet = ActionTransformer.createExposeCardsPacket(playerId, cards);
		GameDataAction action = ProtocolFactory.createGameAction(packet, playerId, table.getId());
		sendPublicPacket(action, playerId);
	}

	public void notifyPlayerBalanceReset(PokerPlayer player) {
		WalletServiceContract walletService = getServices().getServiceInstance(WalletServiceContract.class);
		long sessionId = ((PokerPlayerImpl) player).getSessionId();
		Money amount = new Money(Currency.getInstance(PokerGame.CURRENCY_CODE),amountConverter.convertToWalletAmount(player.getBalance()));
		walletService.withdraw(amount, -1, sessionId, createPlayerBalanceResetDescription(player.getId()));
		notifyPlayerBalance(player);
	}
	
	// called from PokerState (game) notifyHandFinished
	public void notifyHandEnd(HandResult handResult, HandEndStatus handEndStatus) {
		if (handEndStatus.equals(HandEndStatus.NORMAL) && handResult != null) {
			try {
				
				PokerBoardServiceContract pokerBoardServiceContract = PokerGame.getPokerBoardServiceContract();
				log.debug("Update all players balance");
				// Handle wins and losses. Talk to wallet.
				Collection<ResultEntry> resultEntries = new ArrayList<ResultEntry>();
				Map<PokerPlayer, Result> results = handResult.getResults();
				for (PokerPlayer p : results.keySet()) {
					GameDataAction action = ActionTransformer.createPlayerBalanceAction((int)p.getBalance(), p.getId(), table.getId());
					
					// TODO : Database persistence
					log.debug("Inside notifyHandEnd --> performing saving player balance "  + (int)p.getBalance() + " for player #" + p.getId());
					
		    	   if (pokerBoardServiceContract!=null) {
		    		   log.debug("Inside notifyHandEnd: Persist all player current balance");
		    		   //FIXME: should it be long ?
		    		   pokerBoardServiceContract.resetUserBalance(p.getId(), (int)p.getBalance());
		    	   } else {
		    		   log.error("forumServiceContract is null");
		    	   }
		    	    // Notify who is winning the hand
		    	   log.debug("Notify all player who wins the hand");
					notifyPlayerStatusChanged(p.getId(), PokerPlayerStatus.NORMAL, p.getImageUrl(), p.getHandWinnerFl());
					
					table.getNotifier().notifyAllPlayers(action);
					
					long sessionId = ((PokerPlayerImpl) p).getSessionId();
					Result result = results.get(p);
					// FIXME: Hardcoded currency code
					ResultEntry entry = new ResultEntry(sessionId, amountConverter.convertToWalletAmount(result.getNetResult()), PokerGame.CURRENCY_CODE);
					resultEntries.add(entry);
					
					// TODO: Move the event reporting to a separate method
	//				if (pokerCepService != null) {
	//	                pokerCepService.reportHandResult(table.getId(), p, result.getNetResult());
	//	            }
				}
				log.debug("Calling wallerservice");
				WalletServiceContract walletService = getServices().getServiceInstance(WalletServiceContract.class);
				
				// TODO: Change to use doTransaction(...) instead of deprecated method roundResult(...)
				RoundResultResponse roundResult = walletService.roundResult(
				     -1l, (long) PokerGame.POKER_GAME_ID, (long) table.getId(), resultEntries, 
				     createRoundReportDescription(handEndStatus));
				validateWalletBalances(roundResult);
				//FIXME
				// TODO: The following logic should be moved to poker-logic
				// I.e. ranking hands etc do not belong in the game-layer
				PlayerHands hands = handResult.getPlayerHands();
				HandEnd packet = ActionTransformer.createHandEndPacket(hands);
				GameDataAction action = ProtocolFactory.createGameAction(packet, 0, table.getId());
				sendPublicPacket(action, -1);
				
				PokerStats.getInstance().reportHandEnd();
				
				// Remove all idling players
				cleanupPlayers();
				//TODO
				log.debug("Write hand history");
				writeHandHistory(hands, handEndStatus);
				updateLobby();
				
	//			if (pokerCepService != null) {
	//                pokerCepService.reportHandEnd(table.getId(), EventMontaryType.REAL_MONEY);
	//            } 
				
			} catch (Throwable e) {
				log.error("FAIL when reporting hand results", e);
			}
			
		} else {
			log.info("The hand was cancelled on table: " + table.getId() + " - " + table.getMetaData().getName());
			// TODO: The hand was cancelled... do something!
			cleanupPlayers();
		}
		
        clearActionCache();
	}

    private void clearActionCache() {
        if (cache != null) {
        	cache.clear(table.getId());
        }
    }

	/**
	 * Creates a simple textual description of the hand to be used in the round report.
	 * @param handEndStatus status of the hand
	 * @return the description
	 */
    private String createRoundReportDescription(HandEndStatus handEndStatus) {
        return "Pokerhand, table[" + table.getId() + "]";
    }
	
    private String createPlayerBalanceResetDescription(int playerId) {
    	return "Resetting balance for pid["+playerId+"]";
    }
    
	public void notifyPlayerBalance(PokerPlayer p) {
		if (p == null) return;
		
	    GameDataAction action = ActionTransformer.createPlayerBalanceAction((int)p.getBalance(), p.getId(), table.getId());
	    sendPublicPacket(action, 0);
	}
	
	
    private void validateWalletBalances(RoundResultResponse roundResult) {
		// TODO Auto-generated method stub
		
	}

	/**
	 * Sends a poker tournament round report to the tournament as set in the table meta-data.
	 * 
	 * @param report, poker-logic protocol object, not null.
	 */
	public void reportTournamentRound(RoundReport report) {
	    PokerStats.getInstance().reportHandEnd();
	    
	    // Map the report to a server specific round report
        PokerTournamentRoundReport pokerReport = new PokerTournamentRoundReport(report.getBalanceMap());
        MttRoundReportAction action = new MttRoundReportAction(table.getMetaData().getMttId(), table.getId());
        action.setAttachment(pokerReport);
        table.getTournamentNotifier().sendToTournament(action);
        clearActionCache();
    }
	
	
	public void updatePots(Iterable<com.cubeia.poker.pot.Pot> pots) {
		for (com.cubeia.poker.pot.Pot pot : pots ) {
			Pot packet = ActionTransformer.createPotUpdatePacket(pot.getId(), pot.getPotSize());
			GameDataAction action = ProtocolFactory.createGameAction(packet, 0, table.getId());
			sendPublicPacket(action, -1);
		}
    }
	@Override
	public void notifyPlayerStatusChanged(int playerId, PokerPlayerStatus status, String imageUrl, int winnerFl) {
		log.debug("Inside notifyPlayerStatusChanged " + playerId + "  with image as " + imageUrl + " isHandWinner " + (winnerFl==1?"YES":"NO"));
		PlayerPokerStatus packet = new PlayerPokerStatus();
		packet.player = playerId;
		packet.imageUrl = imageUrl;
		switch (status) {
			case ALLIN:
				packet.status = Enums.PlayerTableStatus.ALLIN;
				break;
			case NORMAL:
				packet.status = Enums.PlayerTableStatus.NORMAL;
				break;
			case SITOUT:
				packet.status = Enums.PlayerTableStatus.SITOUT;
				break;
		}
		packet.winnerFl = winnerFl;
		GameDataAction action = ProtocolFactory.createGameAction(packet, playerId, table.getId());
        sendPublicPacket(action, -1);
	}
	
	/*------------------------------------------------
	 
		PRIVATE METHODS
		
	 ------------------------------------------------*/
	
	/**
	 * Schedule a player timeout trigger command.
	 * @param seq 
	 */
	public void schedulePlayerTimeout(long millis, int pid, int seq) {
        GameObjectAction action = new GameObjectAction(table.getId());
        TriggerType type = TriggerType.PLAYER_TIMEOUT;
        Trigger timeout = new Trigger(type, pid);
        timeout.setSeq(seq);
        action.setAttachment(timeout);
        UUID actionId = table.getScheduler().scheduleAction(action, millis);
        TimeoutCache.getInstance().addTimeout(table.getId(), pid, actionId);
    }
	
	/**
	 * Remove all players in state LEAVING or DISCONNECTED
	 */
	public void cleanupPlayers() {
	    if (table.getMetaData().getType().equals(TableType.NORMAL)) {
            UnmodifiableSet<GenericPlayer> players = table.getPlayerSet().getPlayers();
            for (GenericPlayer p : players) {
                if (p.getStatus() == PlayerStatus.DISCONNECTED || p.getStatus() == PlayerStatus.LEAVING) {

                	log.debug("Cleanup - unseat player["+p.getPlayerId()+"] from table["+table.getId()+"]");
                	table.getPlayerSet().unseatPlayer(p.getPlayerId());
                	table.getListener().playerLeft(table, p.getPlayerId());
//                    sendPlayerLeftTable(table, p);
//                    table.getPlayerSet().removePlayer(p.getPlayerId());
                }
            }
	    }
    }

	
//	private void sendPlayerLeftTable(Table table, GenericPlayer p) {
//	    LeaveAction leaveAction = new LeaveAction(p.getPlayerId(), table.getId());
//        sendPublicPacket(leaveAction, p.getPlayerId());
//        table.getListener().playerLeft(table, p.getPlayerId());
//        
//        // Unregister from client registry
//        PublicClientRegistryService clientRegistry = services.getServiceInstance(PublicClientRegistryService.class);
//        clientRegistry.registerPlayerToTable(table.getId(), p.getPlayerId(), -1, table.getMetaData().getMttId(), true);
//        
//    }
	
	
	
    /**
	 * This action will be cached and used for sending current state to 
	 * joining players.
	 * 
	 * If skipPlayerId is -1 then no player will be skipped.
	 * 
	 * @param action
	 * @param skipPlayerId
	 */
	private void sendPublicPacket(GameAction action, int skipPlayerId) {
		if (skipPlayerId < 0) {
			if (table != null)
				table.getNotifier().notifyAllPlayers(action);
			else 
				log.debug("sendPublicPacket: Table is null: ignoring notifyAllPlayers request");
		} else {
			if (table != null)
				table.getNotifier().notifyAllPlayersExceptOne(action, skipPlayerId);
			else 
				log.debug("sendPublicPacket: Table is null: ignoring notifyAllPlayersExceptOne request");
		}
		// Add to state cache
		if (cache != null) {
			if (table != null)
				cache.addAction(table.getId(), action);
			else 
				log.debug("sendPublicPacket: Table is null: ignoring cache request");
		}
	}


	private FirebaseState getFirebaseState() {
		return (FirebaseState)state.getAdapterState();
	}
	
    private void setRequestSequence(int seq, int player) {
    	getFirebaseState().setCurrentRequestSequence(seq);
    }
    
    
    /**
     * FIXME: No real implementation below!
     * 
     * @param hands
     * @param handEndStatus
     */
    private void writeHandHistory(PlayerHands hands, HandEndStatus handEndStatus) {
        if (getServices() != null) {
        	try {
	            HandHistoryDAO dao = new HandHistoryDAO(getServices());
	            dao.persist(getFirebaseState().getPlayerHand());
        	} catch (Exception e) {
        		log.error("Failed to persist hand history", e);
        	}
        } else {
            log.warn("Services is null when trying to persist");
        }
    }


    private ServiceRegistry getServices() {
		return gameContext.getServices();
	}




	private void updateLobby() {
        FirebaseState fbState = (FirebaseState)state.getAdapterState();
        handCount = fbState.getHandCount();
        handCount++;
        LobbyTableAttributeAccessor lobbyTable = table.getAttributeAccessor();
        lobbyTable.setAttribute("handcount", new AttributeValue(handCount));
        fbState.setHandCount(handCount);
    }

    /**
     * FIXME: PlayerHand has been removed. We need a new approach to hand history
     * 
     * @param pid
     * @param type
     * @param bet
     */
    private void addEventToHandHistory(int pid, EventType type, Long bet) {
//    	try {
//	        PlayedHandEvent event = new PlayedHandEvent();
//	        event.setPlayerId(pid);
//	        event.setType(type);
//	        event.setBet(bet);
//	        fbState.getPlayerHand().getEvents().add(event);
//    	} catch (Exception e) {
//    		log.error("Failed to add event to hand history pid["+pid+"], type["+type+"], bet["+bet+"], fbstate.playerhand["+fbState.getPlayerHand()+"]", e);
//    	}
    }
    
    /**
     * FIXME: PlayerHand has been removed. We need a new approach to hand history
     * 
     */
    private void addEventToHandHistory(PokerAction action) {
//    	try {
//	        PlayedHandEvent event = new PlayedHandEvent();
//	        event.setPlayerId(action.getPlayerId());
//	        event.setType(EventTypeTransformer.transform(action.getActionType()));
//	        event.setBet(action.getBetAmount());
//	        fbState.getPlayerHand().getEvents().add(event);
//    	} catch (Exception e) {
//    		log.error("Failed to add event to hand history action["+action+"], fbstate.playerhand["+fbState.getPlayerHand()+"]", e);
//    	}
    }
    
}
