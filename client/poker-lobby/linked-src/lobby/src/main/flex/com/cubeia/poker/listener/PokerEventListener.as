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

package com.cubeia.poker.listener
{
	import com.cubeia.firebase.events.PacketEvent;
	import com.cubeia.firebase.io.protocol.SeatInfoPacket;
	import com.cubeia.firebase.io.protocol.TableQueryResponsePacket;
	import com.cubeia.poker.event.PokerEventDispatcher;
	import com.cubeia.poker.event.TableEvent;
	import com.cubeia.util.players.PlayerRegistry;
	import mx.controls.Alert;
	import com.cubeia.games.poker.io.protocol.PlayerPokerStatus;
	
	import com.cubeia.poker.event.PlayerUpdatedEvent;
	import com.cubeia.model.PokerPlayerInfo;
	
	import com.cubeia.firebase.io.protocol.MttRegisterRequestPacket;
	import com.cubeia.poker.lobby.MTTRegisterEvent;	
	import com.cubeia.poker.lobby.LobbyJoinEvent;
	
	/**
	 * Listener for local and global Poker Events
	 */
	public class PokerEventListener
	{
		public function PokerEventListener()
		{
			PokerLobby.firebaseClient.addEventListener(MTTRegisterEvent.MTT_REGISTER_EVENT, onMTTRegister);
			
		}
		
		
		private function onJoinTable(lobbyJoinEvent:LobbyJoinEvent, auto:Boolean = false, mttId:int = -1):void
		{
/*			if (ExternalInterface.available) 
			{ 
				var autoString:String;
				if ( auto ) {
					autoString = "true";
				} else {
					autoString = "false";
				}
				var iestring:String = "Table_" + lobbyJoinEvent.tableId.toString();
				//trace( "CubeiaPoker.html?tableId="+lobbyJoinEvent.tableId+"&cname=" + connectorName+"&seats="+lobbyJoinEvent.capacity + "&pid=" + pid + "&sid=" + lobbyJoinEvent.seatId + "&autoJoin=" + autoString + "&mttId=" + mttId);
				//ExternalInterface.call("window.open",
				BrowserUtil.openWindow("CubeiaPoker.html?tableId="+lobbyJoinEvent.tableId+"&cname=" + _connectorName+"&seats="+lobbyJoinEvent.capacity + "&pid=" + _pid + "&sid=" + lobbyJoinEvent.seatId + "&autoJoin=" + autoString + "&mttId=" + mttId, "Cubeia Poker Table " + _connectorName + lobbyJoinEvent.tableId, "height=680,width=1056,toolbar=no,scrollbars=no", iestring); 
				
			}
*/		}
		
		public function onMTTRegister(mttRegisterEvent:MTTRegisterEvent):void
		{
			var mttregPacket:MttRegisterRequestPacket = new MttRegisterRequestPacket();
			mttregPacket.mttid = mttRegisterEvent.mttId;
			PokerLobby.firebaseClient.send(mttregPacket);		
		}			
			

		
		public function onFirebasePacket(event:PacketEvent):void {
			if (event.getObject().classId() == TableQueryResponsePacket.CLASSID) {
				handleTableQueryResponse(event);
			}
		}

		// Not used ATM
		private function handleTableQueryResponse(event:PacketEvent):void {
			var packet:TableQueryResponsePacket = event.getObject() as TableQueryResponsePacket;
		}
	}
}