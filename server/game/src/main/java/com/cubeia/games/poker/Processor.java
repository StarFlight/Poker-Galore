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

package com.cubeia.games.poker;

import java.util.List;

import org.apache.log4j.Logger;
import org.apache.log4j.MDC;

import com.cubeia.firebase.api.action.GameAction;
import com.cubeia.firebase.api.action.GameDataAction;
import com.cubeia.firebase.api.action.GameObjectAction;
import com.cubeia.firebase.api.game.GameProcessor;
import com.cubeia.firebase.api.game.TournamentProcessor;
import com.cubeia.firebase.api.game.table.Table;
import com.cubeia.firebase.io.ProtocolObject;
import com.cubeia.firebase.io.StyxSerializer;
import com.cubeia.games.poker.cache.ActionCache;
import com.cubeia.games.poker.handler.PokerHandler;
import com.cubeia.games.poker.handler.Trigger;
import com.cubeia.games.poker.io.protocol.ProtocolObjectFactory;
import com.cubeia.games.poker.jmx.PokerStats;
import com.cubeia.games.poker.logic.TimeoutCache;
import com.cubeia.poker.PokerState;
import com.google.inject.Inject;


/**
 * Handle incoming actions.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class Processor implements GameProcessor, TournamentProcessor {
	
    // Use %X{pokerid} in the layout pattern to include this information.
	private static final String MDC_TAG = "pokerid";

	/** Serializer for poker packets */
	private static StyxSerializer serializer = new StyxSerializer(new ProtocolObjectFactory());

    private static transient Logger log = Logger.getLogger(Processor.class);

    @Inject
    ActionCache actionCache;

    @Inject
    StateInjector stateInjector;
    
    @Inject 
    PokerState state;

    @Inject
	PokerHandler pokerHandler;
    
    /**
	 * Handle a wrapped game packet.
	 * Throw the unpacket to the visitor.
	 *  
	 */
	public void handle(GameDataAction action, Table table) {
		stateInjector.injectAdapter(table);
	    ProtocolObject packet = null;
		try {
			MDC.put(MDC_TAG, "Table["+table.getId()+"]");
			packet = serializer.unpack(action.getData());
			// log.debug("Handle Poker Action (tid:"+table.getId()+") from player("+action.getPlayerId()+"): "+packet);
			pokerHandler.setPlayerId(action.getPlayerId());
			packet.accept(pokerHandler);
			PokerStats.getInstance().setState(table.getId(), state.getStateDescription());			
		} catch (Exception e) {
		    printActionsToErrorLog(e, "Pokerlogic could not handle action: "+action+" Table: "+table.getId()+" Packet: "+packet, table);
			throw new RuntimeException("Could not handle poker game data", e);
			
		} finally {
	    	MDC.remove(MDC_TAG);
	    }
	}
    

	/**
	 * Handle a wrapped object. This is typically a scheduled action
	 * (actually, for the poker so far I know it is *only* scheduled actions).
	 * 
	 * I am using an enum for simple commands, the commands has no input parameters.
	 */
	public void handle(GameObjectAction action, Table table) {
		stateInjector.injectAdapter(table);
	    try {
	    	MDC.put(MDC_TAG, "Table["+table.getId()+"]");
    		if (action.getAttachment() instanceof Trigger) {
    			Trigger command = (Trigger) action.getAttachment();
    			handleCommand(table, command);
    		}    		
	    } catch (RuntimeException e) {
	    	log.error("Failed handling game object action.", e);
	        printActionsToErrorLog(e, "Could not handle command action: "+action+" on table: "+table, table);
	        
	    } finally {
	    	MDC.remove(MDC_TAG);
	    }
	}
	
	/**
	 * Basic switch and response for command types.
	 * 
	 * @param table
	 * @param command
	 */
	private void handleCommand(Table table, Trigger command) {
		switch (command.getType()) {
			case TIMEOUT:
				boolean verified = pokerHandler.verifySequence(command);
				if (verified) {
					state.timeout();
				} else {
					log.warn("Invalid sequence detected");
					printActionsToErrorLog(new RuntimeException(), "Timeout command OOB: "+command+" on table: "+table, table);
				}
				break;
			case PLAYER_TIMEOUT:
				handlePlayerTimeoutCommand(table, command);
			    break;
		}
		
		PokerStats.getInstance().setState(table.getId(), state.getStateDescription());
	}

	/**
	 * Verify sequence number before timeout
	 * 
	 * @param table
	 * @param command
	 * @param logic
	 */
	private void handlePlayerTimeoutCommand(Table table, Trigger command) {
		if (pokerHandler.verifySequence(command)) {
		    TimeoutCache.getInstance().removeTimeout(table.getId(), command.getPid(), table.getScheduler());
		    clearRequestSequence(table);
		    state.timeout();
		} 
	}

	
    public void startRound(Table table) {
    	stateInjector.injectAdapter(table);
        if (actionCache != null) {
            actionCache.clear(table.getId());
        }
        log.debug("Start Round on table: "+table+" ("+table.getPlayerSet().getPlayerCount()+":"+state.getSeatedPlayers().size()+")");
        state.startHand();
    }

    public void stopRound(Table table) {
    	stateInjector.injectAdapter(table);
    }
    
    private void clearRequestSequence(Table table) {
        FirebaseState fbState = (FirebaseState)state.getAdapterState();
        fbState.setCurrentRequestSequence(-1);
    }

    private void printActionsToErrorLog(Exception e, String description, Table table) {
        // Log error with all actions on the table leading to this problem
        List<GameAction> actions = actionCache.getActions(table.getId());
        StringBuffer error = new StringBuffer(description);
        error.append("\nState: "+state);
        for (GameAction history : actions) {
            ProtocolObject packet = null;
            try {
                if (history instanceof GameDataAction) {
                    GameDataAction dataAction = (GameDataAction) history;
                    packet = serializer.unpack(dataAction.getData());
                }
            } catch (Exception e2) {};
            error.append("\n\t"+packet);
        }
        error.append("\nStackTrace: ");
        log.error(error.toString(), e);
    }

}
