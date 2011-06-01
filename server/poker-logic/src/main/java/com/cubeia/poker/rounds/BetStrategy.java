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

package com.cubeia.poker.rounds;

import java.io.Serializable;

import com.cubeia.poker.player.PokerPlayer;

/**
 * Bet strategy for deciding what the min and max bets are, given the situation.
 * 
 * For fixed limit, we need to know:
 * 1. Min bet (will vary between rounds)
 * 2. Player to act's current bet stack and total stack 
 * 3. The number of bets and raises
 * 4. The max number of bets and raises allowed (usually 4)
 */
public interface BetStrategy extends Serializable {

	public long getMinRaiseToAmount(PokerPlayer player);

	public long getMaxRaiseToAmount(PokerPlayer player);

	public long getMinBetAmount(PokerPlayer player);

	public long getMaxBetAmount(PokerPlayer player);

	public long getCallAmount(PokerPlayer player);


}
