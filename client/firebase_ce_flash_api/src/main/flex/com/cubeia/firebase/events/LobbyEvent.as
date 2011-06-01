/**
 * Copyright (C) 2009 Cubeia Ltd info@cubeia.com
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
 * along with this program.  If not, see http://www.gnu.org/licenses.
 */

package com.cubeia.firebase.events
{
	import com.cubeia.firebase.model.LobbyDataItem;
	
	import flash.events.Event;

	public class LobbyEvent extends Event
	{
		/**
		* LobbyEvent.TABLE_UPDATED defines the 
		* <code>type</code> property of the event object 
		* for a <code>_fb_table_updated</code> event.
		*
		* @eventType _fb_table_updated
		*/
		public static const TABLE_UPDATED:String 	= "_fb_table_updated";

		/**
		* LobbyEvent.TABLE_ADDED defines the 
		* <code>type</code> property of the event object 
		* for a <code>_fb_table_added</code> event.
		*
		* @eventType _fb_table_added
		*/
		public static const TABLE_ADDED:String 		= "_fb_table_added";
		
		/**
		* LobbyEvent.TABLE_REMOVED defines the 
		* <code>type</code> property of the event object 
		* for a <code>_fb_table_removed</code> event.
		*
		* @eventType _fb_table_removed
		*/
		public static const TABLE_REMOVED:String 	= "_fb_table_removed";
	
		public function LobbyEvent(lobbyEventType:String, tableId:int, lobbyDataItem:LobbyDataItem)
		{
			super(lobbyEventType);
			tableid = tableId;
			item = lobbyDataItem;
		}
		
		public function get tableId():int
		{
			return tableid;	
		}
		
		public function get lobbyDataItem():LobbyDataItem
		{
			return item;
		}

		private var tableid:int;
		private var item:LobbyDataItem;
	}
}
