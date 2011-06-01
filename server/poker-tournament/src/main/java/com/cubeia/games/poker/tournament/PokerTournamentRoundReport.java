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

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

/**
 * Represents the result after a poker hand has been played in a tournament.
 *
 */
public class PokerTournamentRoundReport implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private Map<Integer, Long> balanceMap = new HashMap<Integer, Long>();
	
	public PokerTournamentRoundReport() {}
	
	public PokerTournamentRoundReport(Map<Integer, Long> balanceMap) {
        this.balanceMap = balanceMap;
    }

    public void setBalance(int playerId, long balance) {
		balanceMap.put(playerId, balance);
	}

	public Set<Entry<Integer, Long>> getBalances() {
		return balanceMap.entrySet();
	}
	
}
