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

import org.apache.log4j.Logger;

import com.cubeia.firebase.api.game.table.InterceptionResponse;
import com.cubeia.firebase.api.game.table.SeatRequest;
import com.cubeia.firebase.api.game.table.Table;
import com.cubeia.firebase.api.game.table.TableInterceptor;
import com.cubeia.poker.PokerState;
import com.google.inject.Inject;

public class PokerTableInterceptor implements TableInterceptor {

    @SuppressWarnings("unused")
    private static final transient Logger log = Logger.getLogger(PokerTableInterceptor.class);
    
    @Inject
    StateInjector stateInjector;
    
    @Inject
    PokerState state;

    public InterceptionResponse allowJoin(Table table, SeatRequest request) {
    	stateInjector.injectAdapter(table);
		return new InterceptionResponse(true, -1);
	}

	
	/**
	 * We will flag the player as disconnected only since we need to hold the
	 * player at the table until the end of next hand.
	 */
	public InterceptionResponse allowLeave(Table table, int playerId) {
		stateInjector.injectAdapter(table); // TODO: Fix this with Guice logic module
		if (state.getGameState().getClass() == PokerState.NOT_STARTED.getClass()) {
			// No hand running, let him go...
			return new InterceptionResponse(true, -1);
		} else {
			// Hand running, set to disconnected only
		    state.playerIsSittingOut(playerId);
			return new InterceptionResponse(false, -1);
		}
	}

	public InterceptionResponse allowReservation(Table table, SeatRequest request) {
		stateInjector.injectAdapter(table);
		return new InterceptionResponse(true, -1);
	}
}
