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

package com.cubeia.poker.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ca.ualberta.cs.poker.Hand;

/**
 * DTO for sending all hands to the server layer.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class PlayerHands implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private Map<Integer, Hand> hands = new HashMap<Integer, Hand>();

	public PlayerHands() {
		
	}
	
	public void addHand(int playerId, Hand hand) {
		hands.put(playerId, hand);
	}
	
	public PlayerHands(Map<Integer, Hand> hands) {
		this.hands = hands;
	}
	
	public Map<Integer, Hand> getHands() {
		return hands;
	}
	
	
	/**
	 * Returns a new instance of PlayerHands that only includes the given
	 * list of player ids.
	 * 
	 * @param players
	 * @return
	 */
	public PlayerHands filter(List<Integer> players) {
		Map<Integer, Hand> filtered = new HashMap<Integer, Hand>(hands);
		filtered.keySet().retainAll(players);
		return new PlayerHands(filtered);
	}
}
