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

package com.cubeia.poker.result;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import com.cubeia.poker.model.PlayerHands;
import com.cubeia.poker.player.PokerPlayer;
import com.google.inject.internal.ToStringBuilder;

/**
 * The result of a hand. This class maps the player to the resulting win/lose amount of the hand.
 */
public class HandResult implements Serializable {

	private static final long serialVersionUID = -7802386310901901021L;

	private Map<PokerPlayer, Result> results = new HashMap<PokerPlayer, Result>();
	
	private PlayerHands playerHands;
	
	public PlayerHands getPlayerHands() {
		return playerHands;
	}

	public void setPlayerHands(PlayerHands playerHands) {
		this.playerHands = playerHands;
	}
	
	public Map<PokerPlayer, Result> getResults() {
		return results;
	}

	public void setResults(Map<PokerPlayer, Result> results) {
		this.results = results;
	}
	
	public String toString() {
		return "HandResult results["+results+"] playerHands["+playerHands+"]";
	}
}
