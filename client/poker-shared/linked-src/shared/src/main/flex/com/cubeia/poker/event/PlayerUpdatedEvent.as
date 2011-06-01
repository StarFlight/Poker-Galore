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

package com.cubeia.poker.event
{
	import com.cubeia.model.PokerPlayerInfo;
	
	import flash.events.Event;

	public class PlayerUpdatedEvent extends PokerEvent
	{
		public static const PLAYER_UPDATE_EVENT:String = "player_updated_event";
		
		public var player:PokerPlayerInfo;
		
		/**
		 * 
		 * Dispatch: Should this even propagate over the local connection? Defaults to true
		 */
		public function PlayerUpdatedEvent(_player:PokerPlayerInfo)
		{
			player = _player
			super(PLAYER_UPDATE_EVENT);
		}
		
	}
}