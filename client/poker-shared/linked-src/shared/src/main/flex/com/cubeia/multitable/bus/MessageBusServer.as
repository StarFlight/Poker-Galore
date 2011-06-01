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
	import com.cubeia.firebase.connector.FirebaseClient;
	import com.cubeia.firebase.events.GamePacketEvent;
	import com.cubeia.firebase.events.LoginResponseEvent;
	import com.cubeia.firebase.events.PacketEvent;
	import com.cubeia.firebase.io.ProtocolObject;
	import com.cubeia.firebase.io.StyxSerializer;
	import com.cubeia.firebase.io.protocol.ProtocolObjectFactory;
	import com.cubeia.firebase.model.PlayerInfo;
	import com.cubeia.multitable.clients.TableRegistry;
	import com.cubeia.multitable.events.SendFailedEvent;
	import com.cubeia.poker.event.PokerEvent;
	import com.cubeia.poker.event.PokerEventDispatcher;
	import com.cubeia.poker.event.PokerEventWrapper;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	public class MessageBusServer
	{
		private var connector:LocalConnection;
		private var tableRegistry:TableRegistry = new TableRegistry();
		private var firebaseClient:FirebaseClient;
		private var busName:String;
		private var sendQueue:SendQueue;
		
		// protocol serialization/deserialization
		private var protocolObjectFactory:ProtocolObjectFactory = new ProtocolObjectFactory();
		private var styxSerializer:StyxSerializer = new StyxSerializer(protocolObjectFactory);

		// saved login information
		private var playerInfo:PlayerInfo;
		
		public function MessageBusServer()
		{
		}

		public function addTable(tableid:int):void
		{
			tableRegistry.addTable(tableid);
		}

		public function removeTable(tableid:int):void
		{
			tableRegistry.removeTable(tableid);
		}
				

		/**
		 * Start the message bus server
		 */		
		public function start(_busName:String, _firebaseClient:FirebaseClient):void
		{
			trace("Start MessageBusServer: "+_busName);
			busName = _busName;
			firebaseClient = _firebaseClient;
			setupConnector();			
			setupSendQueue();
			setupPacketListener();
			PokerEventDispatcher.instance.addEventListener(PokerEventWrapper.POKER_EVENT_WRAPPER, onWrappedEvent);
		}
		
		
		/**
		 * Construct the server and start listening to events
		 */
		
		private function setupPacketListener():void
		{
			firebaseClient.addEventListener(LoginResponseEvent.LOGIN, onLoginResponse);
			firebaseClient.addEventListener(PacketEvent.PACKET_RECEIVED, onPacketReceived);
			firebaseClient.addEventListener(GamePacketEvent.PACKET_RECEIVED, onGamePacketReceived);
		}
		
		private function setupSendQueue():void
		{
			 sendQueue = new SendQueue(connector, busName);
			 sendQueue.addEventListener(SendFailedEvent.SEND_FAILED_EVENT, onSendFailed);
			 sendQueue.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onQueueAsyncErrorEvent); 
			 sendQueue.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onQueueSecurityErrorEvent); 
		}
		
		private function setupConnector():void
		{
			// create connector
			connector = new LocalConnection();
			// set target for callbacks
			connector.client = this;	
			// allow everything for now
			connector.allowInsecureDomain("*");
			connector.allowDomain("*");
			// setup error handling

			//connector.addEventListener(StatusEvent.STATUS, onConnectorStatusEvent);
			//connector.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onConnectorAsyncErrorEvent);
			//connector.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectorSecurityErrorEvent);

			// start listening for local connection events
			try {
				connector.connect(busName);
			} catch (error:ArgumentError) {
				trace("MessageBusServer error: "+error);
				Alert.show("Can't create MessageBusServer -- name already in use: " + busName);
			}

		}


		public function onConnectorAsyncErrorEvent(event:AsyncErrorEvent):void 
		{
			//TODO: add error handling
		}

		public function onConnectorSecurityErrorEvent(event:SecurityErrorEvent):void 
		{
			//TODO: add error handling
		}

		public function onConnectorStatusEvent(event:StatusEvent):void 
		{
			// Ignore all warnings and status events
			if ( event.level == "error" ) { 
				//TODO: add error handling
			}
		}
		
		private function onQueueAsyncErrorEvent(event:AsyncErrorEvent):void 
		{
			//TODO: add error handling
		}

		private function onQueueSecurityErrorEvent(event:SecurityErrorEvent):void 
		{
			//TODO: add error handling
		}


		private function onSendFailed(event:SendFailedEvent):void
		{
			tableRegistry.removeTable(event.tableid);
		}
		
		private function onLoginResponse(event:LoginResponseEvent):void
		{
			playerInfo = event.getPlayerInfo();
		}

		private function onPacketReceived(event:PacketEvent):void
		{
			var protocolObject:ProtocolObject = event.getObject();
			var isTable:Boolean = Object(protocolObject).hasOwnProperty("tableid");
			if ( isTable ) {
				var tableid:int = Object(protocolObject)["tableid"];
				var buffer:ByteArray = styxSerializer.pack(protocolObject);
				sendQueue.put(tableid, "packetReceived", buffer);
			}
		}

		/**
		 * Global event receiver
		 */
		 public function pokerEvent(pokerEvent:PokerEvent):void
		 {
			trace("Poker event received. Will dispatch locally: "+pokerEvent); 
		 	PokerEventDispatcher.dispatch(pokerEvent);
		 }
		 
		private function onGamePacketReceived(event:GamePacketEvent):void
		{
			sendQueue.put(event.tableid, "gamePacketReceived", event.getPacketData());
		}

		private function onWrappedEvent(event:PokerEventWrapper):void
		{
			dispatchToAll(event);

		}
		
		private function dispatchToAll(event:PokerEventWrapper):void
		{
			for each ( var tableid:int in tableRegistry.getTableList() ) {
				if ( event.pokerEvent.tableid == -1 || event.pokerEvent.tableid == tableid ) {
					connector.send(busName+"-"+tableid.toString(), "pokerEvent", event.pokerEvent);
				} 
			}
		}
		
		public function sendPacket(buffer:ByteArray):void
		{
			firebaseClient.send(styxSerializer.unpack(buffer));
		}
	}
}