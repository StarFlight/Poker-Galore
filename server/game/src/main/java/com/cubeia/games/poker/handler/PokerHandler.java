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

package com.cubeia.games.poker.handler;

import org.apache.log4j.Logger;

import com.cubeia.firebase.api.game.table.Table;
import com.cubeia.games.poker.FirebaseState;
import com.cubeia.games.poker.adapter.ActionTransformer;
import com.cubeia.games.poker.io.protocol.PerformAction;
import com.cubeia.games.poker.io.protocol.PlayerSitinRequest;
import com.cubeia.games.poker.io.protocol.PlayerSitoutRequest;
import com.cubeia.games.poker.io.protocol.PlayerPokerStatus;

import com.cubeia.games.poker.logic.TimeoutCache;
import com.cubeia.poker.PokerState;
import com.cubeia.poker.action.PokerAction;
import com.google.inject.Inject;

public class PokerHandler extends DefaultPokerHandler {

    private static transient Logger log = Logger.getLogger(PokerHandler.class);
    
	int playerId;
	
	@Inject
    Table table;
	
	@Inject
	PokerState state;
	
	public void setPlayerId(int playerId) {
		this.playerId = playerId;
	}
	
	public void visit(PerformAction packet) {
	    if (verifySequence(packet)) {
	    	TimeoutCache.getInstance().removeTimeout(table.getId(), playerId, table.getScheduler());
	        PokerAction action = new PokerAction(playerId, ActionTransformer.transform(packet.action.type));
	        action.setBetAmount(packet.betAmount);
	        state.act(action);
	    } 
	}

	
	// player status has changed eg. avatar
	public void visit(PlayerPokerStatus packet) {
		log.debug("Inside visit PlayerPokerStatus for # " + packet.player );
		state.notifyAvatarChange(packet.player);
		
	}
	
	// player wants to sit out next hand
	public void visit(PlayerSitoutRequest packet) {
		state.playerIsSittingOut(playerId);
	}

	// player wants to sit in again
	public void visit(PlayerSitinRequest packet) {
		state.playerIsSittingIn(playerId);
	}

    private boolean verifySequence(PerformAction packet) {
        FirebaseState fbState = (FirebaseState)state.getAdapterState();
        int current = fbState.getCurrentRequestSequence();
        if (current >= 0 && current == packet.seq) {
            return true;
            
        } else {
            log.debug("Ignoring action. current-seq["+current+"] packet-seq["+packet.seq+"] - packet["+packet+"]");
            return false;
        }
        
    }
    
    public boolean verifySequence(Trigger command) {
        FirebaseState fbState = (FirebaseState)state.getAdapterState();
        int current = fbState.getCurrentRequestSequence();
        if (current == command.getSeq()) {
            return true;
            
        } else {
            log.warn("Ignoring scheduled command, current-seq["+current+"] command-seq["+command.getSeq()+"] - command["+command+"] state["+state+"]");
            return false;
        }
    }


	
	
}
