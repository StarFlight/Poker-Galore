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

import com.cubeia.poker.player.PokerPlayer;

public interface BettingRoundContext {

	/**
	 * Gets the min bet in this betting round.
	 * 
	 * @return the min bet
	 */
	public long getMinBet();

	/**
	 * Gets the currently highest bet in this betting round.
	 * 
	 * @return the currently highest bet in this betting round
	 */
	public long getHighestBet();
	
	/**
	 * Gets the size of the last bet or raise.
	 * 
	 * @return the size of the last bet or raise
	 */
	public long getSizeOfLastBetOrRaise();
	
	/**
	 * Checks whether all other plahyers in this round are all in.
	 * 
	 * @return <code>true</code> if so, <code>false</code> otherwise
	 */
	public boolean allOtherPlayersAreAllIn(PokerPlayer thisPlayer);

}
