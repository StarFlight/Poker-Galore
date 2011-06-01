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
	
	import mx.rpc.remoting.RemoteObject;
	
	[RemoteClass(alias="PlayerInfoEvent")]
	public class PlayerInfoEvent extends PokerEvent
	{
		public static const PLAYER_INFO_REQUEST:String = "PLAYER_INFO_REQUEST";
		public static const PLAYER_INFO_RESPONSE:String = "PLAYER_INFO_RESPONSE";
		
		public var player:PokerPlayerInfo;
		
		public function PlayerInfoEvent(type:String = "", tableId:int = -1)
		{
			super(type, tableId);
		}
		
		public override function toString():String
		{
			var result:String = "PlayerInfoEvent :";
			result += " type["+type+"]" ;
			result += " tableId["+tableid+"]" ;
			result += " player["+player+"]" ;
			return result;
		}
	}
}