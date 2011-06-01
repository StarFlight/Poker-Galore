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

package com.cubeia.games.poker.cache;

import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import com.cubeia.firebase.api.action.GameAction;

/**
 * A simple cache for holding actions that composes the 
 * game state of the current round.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class ActionCache {

	/**
	 * Maps actions to tables.
	 * It is important that this cache is properly cleared since there is
	 * no inherent house-keeping in this implementation.
	 * 
	 * I.e., we rely on YOU to clean up after yourself.
	 * 
	 * This cache is not replicated!
	 */
	protected ConcurrentMap<Integer, List<GameAction>> cache = new ConcurrentHashMap<Integer, List<GameAction>>();

	/**
	 * Add action to a table state cache.
	 * 
	 * @param tableId
	 * @param action
	 */
	public void addAction(int tableId, GameAction action) {
		List<GameAction> list = cache.get(tableId);
		// Since we are guaranteed one event at a time per table
		// We can safely inspect the list and recreate if necessary
		if (list == null) {
			list = new LinkedList<GameAction>();
			cache.put(tableId, list);
		}
		list.add(action);
	}

	/**
	 * Retreive state from a table.
	 * 
	 * @param i
	 * @return
	 */
	public List<GameAction> getActions(int tableId) {
		List<GameAction> list = cache.get(tableId);
		if (list == null) {
			list = new LinkedList<GameAction>();
		}
		return list;
	}

	public void clear(int tableId) {
		cache.remove(tableId);
	}
	
	public String printDetails() {
		String details = "Action Cache: \n";
		for (Integer id : cache.keySet()) {
			details += id+" {\n";
			for (GameAction action : cache.get(id)) {
				details += "\t"+action;
			}
			details += id+"}\n\n";
		}
		return details;
	}
}
