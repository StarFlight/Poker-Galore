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

package com.cubeia.poker.table.handler
{
	import com.cubeia.firebase.events.GamePacketEvent;
	import com.cubeia.firebase.events.PacketEvent;
	import com.cubeia.firebase.io.ProtocolObject;
	import com.cubeia.firebase.io.protocol.JoinRequestPacket;
	import com.cubeia.firebase.io.protocol.LeaveRequestPacket;
	import com.cubeia.firebase.io.protocol.NotifyJoinPacket;
	import com.cubeia.firebase.io.protocol.SeatInfoPacket;
	import com.cubeia.firebase.model.PlayerInfo;
	import com.cubeia.model.PokerPlayerInfo;
	import com.cubeia.multitable.events.GamePacketDataEvent;
	import com.cubeia.poker.event.PlayerUpdatedEvent;
	import com.cubeia.poker.event.PokerEventDispatcher;
	import com.cubeia.poker.event.StyleChangedEvent;
	import com.cubeia.poker.event.TableEvent;
	import com.cubeia.poker.table.model.Player;
	import com.cubeia.poker.table.model.Table;
	import com.cubeia.poker.ui.StyledApplication;
	import com.cubeia.util.players.PlayerRegistry;
	import com.cubeia.firebase.model.PlayerInfo;
	import mx.controls.Alert;

	/**
	 * Handles incoming packets and events
	 * 
	 */
	public class TableHandler
	{
		
		private var table:Table;
		
		private var gamePacketHandler:GamePacketHandler;
		
		public function TableHandler(table:Table, avatarUrl:String, pi:PlayerInfo) {
			this.table = table;
			
			gamePacketHandler = new GamePacketHandler(table,pi);
			
			// Setup listeners
			PokerEventDispatcher.instance.addEventListener(PlayerUpdatedEvent.PLAYER_UPDATE_EVENT, onPlayerUpdate);
			PokerEventDispatcher.instance.addEventListener(PacketEvent.PACKET_RECEIVED, onFirebasePacket);
			PokerEventDispatcher.instance.addEventListener(TableEvent.JOIN_TABLE_REQUEST, onJoinTableRequest);
			PokerEventDispatcher.instance.addEventListener(TableEvent.LEAVE_TABLE_REQUEST, onLeaveTableRequest);
			PokerEventDispatcher.instance.addEventListener(GamePacketDataEvent.GAME_PACKET_DATA_EVENT, onGamePacket);
			
		}
		
		
		/* --------------------------------------------------
			NOTIFICATIONS
			Handlers for events that notifications, i.e. 
			events that will update the model or other
			information.
		
		   -------------------------------------------------- */
		   
		   
		private function onPlayerUpdate(event:PlayerUpdatedEvent):void {
			// If the player is seated at the table, then update player
			var info:PokerPlayerInfo = event.player;
			
			var player:Player = table.getPlayer(info.id);
			if (player != null) {
				player.imageUrl = info.imageUrl;
				player.screenname = info.name;
			} 
				
		}
		
		private function onGamePacket(event:GamePacketDataEvent):void {
			gamePacketHandler.onGamePacket(event);
		}
		
		
		private function onFirebasePacket(event:PacketEvent):void {
			gamePacketHandler.onFirebasePacket(event);
		}
		
		
		/* --------------------------------------------------
			TABLE COMMANDS
			Handlers for events that should be sent to
			the server as a request.
		
		   -------------------------------------------------- */
		 
		private function onJoinTableRequest(event:TableEvent):void {
			var packet:JoinRequestPacket = new JoinRequestPacket();
			packet.seat = event.seatIndex;
			packet.tableid = event.tableid;
			PokerTable.messageBusClient.send(packet); 
		}
		
		private function onLeaveTableRequest(event:TableEvent):void {
			var packet:LeaveRequestPacket= new LeaveRequestPacket();
			packet.tableid = event.tableid;
			PokerTable.messageBusClient.send(packet); 
		}		

	}
}