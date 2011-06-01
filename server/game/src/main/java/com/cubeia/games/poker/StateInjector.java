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

import com.cubeia.firebase.api.game.table.Table;
import com.cubeia.games.poker.adapter.FirebaseServerAdapter;
import com.cubeia.poker.PokerState;
import com.google.inject.Inject;

/**
 * TODO: The functionality of this class should be modeled 
 * in Guice modules instead.
 *  
 * @author Fredrik
 */
public class StateInjector {

	@Inject
	FirebaseServerAdapter adapter;
	
	/**
	 * Inject the server adapter to the game logic.
	 * @param table
	 */
	public void injectAdapter(Table table) {
		PokerState state = (PokerState)table.getGameState().getState();
		state.setServerAdapter(adapter);
	}
}
