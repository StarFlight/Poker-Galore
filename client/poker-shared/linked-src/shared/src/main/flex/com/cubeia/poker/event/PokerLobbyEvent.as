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
	import flash.events.Event;
	import mx.rpc.remoting.RemoteObject;

	[RemoteClass(alias="PokerLobbyEvent")]
	public class PokerLobbyEvent extends PokerEvent
	{
		public static var LOGGED_IN:String = "lobby_logged_in";
		public static var VIEW_CHANGED:String = "lobby_view_changed";
	
		public static var LEAVE_TABLE:String = "leave_table_to_lobby";
		
		public static var RING_GAME:String = "RING_GAME";
		public static var SIT_AND_GO:String = "SIT_AND_GO";
		public static var TOURNAMENT:String = "TOURNAMENT";

		public static var views:Array = [RING_GAME, SIT_AND_GO, TOURNAMENT];
		
		public var newView:String;
		public var oldView:String;
		
		public function PokerLobbyEvent(type:String = "", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type);
		}
		
	}
}