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

package com.cubeia.poker.player;

/**
 * Represents a tournament poker player.
 * 
 * The difference between a ring game player and a tournament player is that
 * a tournament player can never sit out and can never deny posting blinds.
 * 
 * @author viktor
 *
 */
public class TournamentPokerPlayer extends DefaultPokerPlayer {

	private static final long serialVersionUID = 1L;

	public TournamentPokerPlayer(int id) {
		super(id);
	}


}
