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

package com.cubeia.multitable.bus
{
	
	public class TableSubscriptionList
	{
		
		public function TableSubscriptionList()
		{
			_subscriptionMap = new Object();
			
		}
		
		public function subscribeTable(clientId:String, tableId:int):void
		{
			trace("Adding client/table " + clientId + "/" + tableId + " to subscription list.");
			_subscriptionMap[clientId] = tableId;			
		}
		
		public function unSubscribeAnyTable(clientId:String):void
		{
			if ( _subscriptionMap[clientId] != null ) {
				trace("Removing client " + clientId + " from subscription list.");
				delete _subscriptionMap[clientId];
			}
		}
		
		
		public function unSubscribeTable(clientId:String, tableId:int):void
		{
			if ( isTableSubscribed(clientId, tableId) ) {
				trace("Removing client/table " + clientId + " from subscription list.");
				delete _subscriptionMap[clientId];
			} 
						
		}
		
		public function isTableSubscribed(clientId:String, tableId:int):Boolean
		{
			var subscribed:Boolean = _subscriptionMap[clientId] == tableId;
			// trace ("checking subscription client/table " + clientId + "/" + tableId + " = " + subscribed.toString() ); 
			return (subscribed);	
		}
			
		private var _subscriptionMap:Object;
		
	}
}



