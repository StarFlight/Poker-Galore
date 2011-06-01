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
	import com.cubeia.firebase.events.GamePacketEvent;
	import com.cubeia.firebase.events.PacketEvent;
	import com.cubeia.firebase.io.ProtocolObject;
	import com.cubeia.firebase.io.StyxSerializer;
	import com.cubeia.firebase.io.protocol.GameTransportPacket;
	import com.cubeia.firebase.io.protocol.ProtocolObjectFactory;
	import com.cubeia.multitable.events.GamePacketDataEvent;
	import com.cubeia.poker.event.PokerEvent;
	import com.cubeia.poker.event.PokerEventDispatcher;
	import com.cubeia.poker.event.PokerEventWrapper;
	
	import flash.net.LocalConnection;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	public class MessageBusClient
	{
		private var connector:LocalConnection;
		private var tableid:int;
		private var busName:String;

		// Packet serialization/deserialization		
		private var protocolObjectFactory:ProtocolObjectFactory = new ProtocolObjectFactory();
		private var styxSerializer:StyxSerializer = new StyxSerializer(protocolObjectFactory);

		
		public function MessageBusClient()
		{
		}
		
		public function start(_busName:String, _tableid:int):void
		{
			busName = _busName;
			tableid = _tableid;
			setupConnector();	
			PokerEventDispatcher.instance.addEventListener(PokerEventWrapper.POKER_EVENT_WRAPPER, onWrappedEvent);
		}
		
		public function stop():void
		{
			connector.close();
		}
		
		private function setupConnector():void
		{
			trace("Setting up MessageBusClient for Receiver: "+tableid);
			connector = new LocalConnection();
			connector.client = this;
			connector.allowInsecureDomain("*");
			connector.allowDomain("*");
			try {
				connector.connect(busName+"-"+tableid.toString());
			} catch (error:ArgumentError) {
				Alert.show("table is already open");
			}
			connector.send(busName, "addTable", tableid);		
		}
		
		private function onWrappedEvent(event:PokerEventWrapper):void
		{
			trace("global event received. Will send over bus to server: "+event.pokerEvent); 
			connector.send(busName, "pokerEvent", event.pokerEvent);
		}
		
		/**
		 * Global event receiver
		 */
		 public function pokerEvent(pokerEvent:PokerEvent):void
		 {
		 	PokerEventDispatcher.dispatch(pokerEvent);
		 }
		 
		 /** 
		 * Packet received from MessageBusServer
		 */
		 public function packetReceived(args:Array):void
		 {
			var protocolObject:ProtocolObject = styxSerializer.unpack(args[0]);
			PokerEventDispatcher.instance.dispatchEvent(new PacketEvent(protocolObject));
		 }
		 
		 public function gamePacketReceived(args:Array):void {
			 PokerEventDispatcher.instance.dispatchEvent(new GamePacketDataEvent(args[0]));
		 }
		
		 
		 public function send(protocolObject:ProtocolObject):void
		 {
		 	var buffer:ByteArray = styxSerializer.pack(protocolObject);
		 	connector.send(busName, "sendPacket" , buffer);
		 } 

		 public function sendGamePacket(playerid:int, tableid:int, packet:ByteArray):void
		 {
			 packet.position = 0;
			 var gameTransportPacket:GameTransportPacket = new GameTransportPacket();
			 gameTransportPacket.pid = playerid;
			 gameTransportPacket.tableid = tableid;
			 gameTransportPacket.gamedata = packet;
			 var buffer:ByteArray = styxSerializer.pack(gameTransportPacket);
			 connector.send(busName, "sendPacket" , buffer);
		 }
	}
}