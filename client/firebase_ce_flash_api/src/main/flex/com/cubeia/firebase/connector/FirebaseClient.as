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

﻿package com.cubeia.firebase.connector
{
	import com.cubeia.firebase.comm.FirebaseSocket;
	import com.cubeia.firebase.comm.SocketDataHandler;
	import com.cubeia.firebase.crypto.CryptoFunctions;
	import com.cubeia.firebase.crypto.CryptoProvider;
	import com.cubeia.firebase.crypto.KeyExchange;
	import com.cubeia.firebase.events.ConnectEvent;
	import com.cubeia.firebase.events.DisconnectEvent;
	import com.cubeia.firebase.events.GamePacketEvent;
	import com.cubeia.firebase.events.LobbyEvent;
	import com.cubeia.firebase.events.LoginResponseEvent;
	import com.cubeia.firebase.events.PacketEvent;
	import com.cubeia.firebase.events.TournamentEvent;
	import com.cubeia.firebase.io.ProtocolObject;
	import com.cubeia.firebase.io.StyxSerializer;
	import com.cubeia.firebase.io.protocol.*;
	import com.cubeia.firebase.model.LobbyDataItem;
	import com.cubeia.firebase.model.PlayerInfo;
	import com.cubeia.firebase.model.TournamentDataItem;
	import com.hurlant.crypto.tls.TLSConfig;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.utils.ByteArray;

	/**
	* Dispatched when a table has been updated in the lobby
	* @eventType com.cubeia.firebase.events.LobbyEvent.TABLE_UPDATED
	*/
	[Event(name="table_updated", type="com.cubeia.firebase.events.LobbyEvent")]					

	/**
	* Dispatched when a table has been added to the lobby
	* @eventType com.cubeia.firebase.events.LobbyEvent.TABLE_ADDED
	*/
	[Event(name="table_added", type="com.cubeia.firebase.events.LobbyEvent")]					

	/**
	* Dispatched when a table has been removed from the lobby
	* @eventType com.cubeia.firebase.events.LobbyEvent.TABLE_REMOVED
	*/
	[Event(name="table_removed", type="com.cubeia.firebase.events.LobbyEvent")]					

	/**
	* Dispatched when a tournament has been updated in the lobby
	* @eventType com.cubeia.firebase.events.LobbyEvent.TOURNAMENT_UPDATED
	*/
	[Event(name="tournament_updated", type="com.cubeia.firebase.events.LobbyEvent")]					

	/**
	* Dispatched when a tournament has been added to the lobby
	* @eventType com.cubeia.firebase.events.LobbyEvent.TOURNAMENT_ADDED
	*/
	[Event(name="tournament_added", type="com.cubeia.firebase.events.LobbyEvent")]					

	/**
	* Dispatched when a tournament has been removed from the lobby
	* @eventType com.cubeia.firebase.events.LobbyEvent.TOURNAMENT_REMOVED
	*/
	[Event(name="tournament_removed", type="com.cubeia.firebase.events.LobbyEvent")]					


	/**
	* Dispatched when a Socket connection has been established.
	* @see flash.net.Socket
	* @eventType com.cubeia.firebase.events.FirebaseEvent.CONNECT
	*/
	[Event(name="connect", type="com.cubeia.firebase.events.ConnectEvent")]					

	/**
	* Dispatched when the socket is closed.
	* @see flash.net.Socket
	* @eventType com.cubeia.firebase.events.DisconnectEvent.DISCONNECT
	*/
	[Event(name="disconnect", type="com.cubeia.firebase.events.DisonnectEvent")]					

	/**
	* Dispatched when a firebase packet arrives.
	* use PacketEvent.getObject() to retrieve packet
    * @example Check classid of the packet that just arrived: 
     <listing version="3.0" >
public function onPacketEvent(packetEvent:PacketEvent):void
{
    var protocolObject:ProtocolObject  = packetEvent.getObject();
    if ( protocolObject.classId() == LoginResponsePacket.CLASSID ) 
    {
        .
        .
    }
}</listing>
	* @see com.cubeia.firebase.io.ProtocolObject
		* @eventType com.cubeia.firebase.events.PacketEvent.PACKET_RECEIVED
	*/
	[Event(name="packet_received", type="com.cubeia.firebase.events.PacketEvent")]					
	

	/**
	* Dispatched when a game specific packet arrives.
	* use GamePacketEvent.getObject() to retrieve packet
	* @see com.cubeia.firebase.io.ProtocolObject
	* @see com.cubeia.firebase.io.protocol.GameTransportPacket
	*  
	* @eventType com.cubeia.firebase.events.GamePacketEvent.PACKET_RECEIVED
	*/
	[Event(name="game_packet_received", type="com.cubeia.firebase.events.GamePacketEvent")]					

	
	/**
	* Dispatched when a player has successfully logged on.
	* use loginEvent.getPlayerInfo() to retrieve object
  * @example Retrieve PlayerInfo payload from event
     <listing version="3.0" >
public function onLoginEvent(loginEvent:LoginEvent):void
{
    var playerInfo:PlayerInfo = loginEvent.getPlayerInfo();
}</listing>
	* @see com.cubeia.firebase.model.PlayerInfo
	* @eventType com.cubeia.firebase.events.LoginEvent.LOGIN
	*/
	[Event(name="login", type="com.cubeia.firebase.events.LoginResponseEvent")]					

	/**
	* Dispatched when an io error has occurred
	* @eventType flash.events.IOErrorEvent.IO_ERROR
	*/
	[Event(name="io_error", type="flash.events.IOErrorEvent")]					

	/**
	* Dispatched when an security error has occurred
	* @eventType flash.events.SecurityErrorEvent
	*/
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]					

	/**
	* Dispatched when an security error has occurred
	* @eventType flash.events.StatusEvent
	*/
	[Event(name="status", type="flash.events.StatusEvent")]


	/**
	 * FirebaseClient 
	*/
	public class FirebaseClient extends EventDispatcher implements SocketDataHandler
	{
		private var protocolObjectFactory:ProtocolObjectFactory = new ProtocolObjectFactory();
		private var styxSerializer:StyxSerializer = new StyxSerializer(protocolObjectFactory);
		private var playerInfo:PlayerInfo = new PlayerInfo();
		
		// encryption flag
		private var _useEncryption:Boolean; 
		
		private var _keyExchange:KeyExchange;
		private var _cryptoProvider:CryptoProvider;

		private var firebaseSocket:FirebaseSocket;

		
				
		/**
		 * Construct a firebase client
		 * <p>
		 * @param useHandshake
		 * @param handshakeSignature
		 * </p>
		 * uniqueness is not enforced
		 */
		public function FirebaseClient(useHandshake:Boolean = false, handshakeSignature:uint = 0, useTLS:Boolean = false, tlsConfig:TLSConfig = null):void
		{
			firebaseSocket = new FirebaseSocket(this, useHandshake, handshakeSignature, useTLS, tlsConfig);
		}
		
		/**
		 * Enable encryption
		 * @param keyExchange 
		 * @param cryptoProvider
		 */
		public function enableCrypto(keyExchange:KeyExchange, cryptoProvider:CryptoProvider):Boolean
		{
			try {
				_keyExchange = keyExchange;
				_cryptoProvider = cryptoProvider;
				_useEncryption = true;
			} catch ( error:Error ) {
				return false;
			}
			return true;
		}
		
		/**
		 * Close client 
		 * 
		 */
		public function close():void
		{
			firebaseSocket.close();
		}

		/**
		 * Send login packet to firebase server
		 * 
		 * @param username 
		 * @param password 
		 * @param operatorid
		 */
		 public function login(username:String, password:String, operatorid:int = 0):void
		 {
			var loginRequestPacket:LoginRequestPacket = new LoginRequestPacket();
			loginRequestPacket.user = username;
			loginRequestPacket.password = password;
			loginRequestPacket.operatorid = operatorid;
			send(loginRequestPacket);
		 }

		/**
		 * Open a connection to the firebase server
		 * 
		 * @param host host name or ip-address of server
		 * @param port TCP port to connect to
		 * @param xdomainPort TCP port of crossdomain policy server
		 */
		public function open(host:String, port:String = "4123", xdomainPort:String = "4122"):void
		{
			firebaseSocket.connect(host, parseInt(port), parseInt(xdomainPort));
		}
		


		/**
		 * Handle successfull connect
		 * 
		 * @param event event from SocketDataHandler
		*/
		public function handleConnect(event:Event):void
		{
			if ( _useEncryption )
			{
				sendKeyExchangeRequest();
			}	
			
			dispatchEvent(new ConnectEvent());
		}


		private function sendKeyExchangeRequest():void
		{
			var encPacket:EncryptedTransportPacket  = new EncryptedTransportPacket();
			encPacket.func = CryptoFunctions.KEY_REQUEST;
			encPacket.payload.writeUTFBytes(_keyExchange.getPublicKey());
			var buffer:ByteArray = styxSerializer.pack(encPacket);
			firebaseSocket.send(buffer);
		}
		
		
		/**
		 * Handle data from SocketDataHandler
		 * 
		 * @param classId class ID of ProtocolObject 
		 * @param data byte array with unpacked protocol data
		 */
		public function handleData(classId:int, data:ByteArray):void
		{
			
			var protocolObject:ProtocolObject = styxSerializer.unpack(data);

			if ( protocolObject.classId() == EncryptedTransportPacket.CLASSID )
			{
				var encryptedTransportPacket:EncryptedTransportPacket = EncryptedTransportPacket(protocolObject);
				
				if ( encryptedTransportPacket.func == CryptoFunctions.SESSION_KEY ) 
				{
					_cryptoProvider.setSessionKey(_keyExchange.decryptSessionKey(encryptedTransportPacket.payload));
					return;
				} 
				
				if ( encryptedTransportPacket.func == CryptoFunctions.ENCRYPTION_MANDATORY ) {
					throw new Error("Game Server: This connection requires encryption"); 
				}
				
				if ( encryptedTransportPacket.func == CryptoFunctions.ENCRYPTED_DATA )
				{
					protocolObject = styxSerializer.unpack(_cryptoProvider.decrypt(encryptedTransportPacket.payload));
				}
			}

			if ( protocolObject.classId() == PingPacket.CLASSID ) {
				// respond to ping packet immediately
				send(protocolObject);
				return;
			}
			
			if ( protocolObject.classId() == LoginResponsePacket.CLASSID ) {
				dispatchLoginEvent(LoginResponsePacket(protocolObject));
				return;
			}
			
			if ( protocolObject.classId() == GameTransportPacket.CLASSID ) {
				dispatchEvent(new GamePacketEvent(GameTransportPacket(protocolObject)));
				return;
			}
			
			// check for lobby messages
			handleLobbyData(protocolObject);
			
			var packetEvent:PacketEvent = new PacketEvent(protocolObject);
			// fire of protocolevent 			
			dispatchEvent(packetEvent);
			
		}
		
		private function dispatchLoginEvent(loginResponsePacket:LoginResponsePacket):void
		{		
			dispatchEvent(new LoginResponseEvent(loginResponsePacket));
		}
	
		/**
		 * Send a packet to the firebase server
		 * 
		 * @param packet ProtocolObject to send
		 */
		public function send(packet:ProtocolObject):void
		{
			var buffer:ByteArray = styxSerializer.pack(packet);
			if ( _useEncryption ) 
			{
				var encryptedTransportPacket:EncryptedTransportPacket = new EncryptedTransportPacket();
				encryptedTransportPacket.func = CryptoFunctions.ENCRYPTED_DATA;
				encryptedTransportPacket.payload = _cryptoProvider.encrypt(buffer);
				var encryptedPacketData:ByteArray = styxSerializer.pack(encryptedTransportPacket);
				firebaseSocket.send(encryptedPacketData);	
			} 
			else
			{
				firebaseSocket.send(buffer);	
			}
		}

				
		/**
		 * Get styx serializer object
		 */
		public function get Serializer():StyxSerializer 
		{
			return styxSerializer;
		}
		
		/**
		 * Get protocol object factory
		 */
		public function get ObjectFactory():ProtocolObjectFactory
		{
			return protocolObjectFactory;
		}
		
		public function handleDisconnect(event:Event):void
		{
			var disconnectEvent:DisconnectEvent = new DisconnectEvent();
			dispatchEvent(disconnectEvent);

		}
		
		public function handleSecurityEvent(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		public function handleStatusEvent(event:StatusEvent):void
		{
			dispatchEvent(event);
		}
		
		public function handleIOError(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		public function handleError(event:Event):void
		{
			dispatchEvent(event);
		}
	
	
		// lobby function
		/**
		 * Send a subscription packet to the game server
		 * 
		 * @param gameId
		 * @param address - FQN of lobby tree
		 * @param tournamentLobby - set to true for tournament lobby
 		 */
		public function lobbySubscribe(gameId:int, address:String, tournamentLobby:Boolean = false):void
		{
			var lobbySubscribePacket:LobbySubscribePacket = new LobbySubscribePacket();
			lobbySubscribePacket.gameid = gameId;
			lobbySubscribePacket.address = address;
			lobbySubscribePacket.type = tournamentLobby ? LobbyTypeEnum.MTT : LobbyTypeEnum.REGULAR;
			send(lobbySubscribePacket);
		}
		
		/**
		 * Send a lobby unsubscribe packet to the game server
		 * 
		 * @param gameId
		 * @param address - FQN of lobby tree
		 * @param tournamentLobby - set to true for tournament lobby
		 */
		public function lobbyUnsubscribe(gameId:int, address:String, tournamentLobby:Boolean = false):void
		{
			var lobbyUnsubscribePacket:LobbyUnsubscribePacket = new LobbyUnsubscribePacket();
			lobbyUnsubscribePacket.gameid = gameId;
			lobbyUnsubscribePacket.address = address;
			lobbyUnsubscribePacket.type = tournamentLobby ? LobbyTypeEnum.MTT : LobbyTypeEnum.REGULAR;
			send(lobbyUnsubscribePacket);
		}

		/**
		 * Send a lobby query to the game server
		 * 
		 * @param gameId
		 * @param address - FQN of lobby tree
		 * @param tournamentLobby - set to true for tournament lobby
		 */
		public function lobbyQuery(gameId:int, address:String, tournamentLobby:Boolean = false):void
		{
			var lobbyQueryPacket:LobbyQueryPacket = new LobbyQueryPacket();
			lobbyQueryPacket.gameid = gameId;
			lobbyQueryPacket.address = address;
			lobbyQueryPacket.type = tournamentLobby ? LobbyTypeEnum.MTT : LobbyTypeEnum.REGULAR;
			send(lobbyQueryPacket);
		}
		
		/**
		 * Send an object subscription packet to the game server
		 * 
		 * @param gameId
		 * @param address  FQN of lobby tree
		 * @param objectid ID of lobby object
		 * @param tournamentLobby set to true for tournament lobby
 		 */
		public function lobbyObjectSubscribe(gameid:int, address:String, objectid:int, tournamentLobby:Boolean = false):void {
			var lobbyObjectSubscribePacket:LobbyObjectSubscribePacket = new LobbyObjectSubscribePacket();
			lobbyObjectSubscribePacket.address = address;
			lobbyObjectSubscribePacket.gameid = gameid;
			lobbyObjectSubscribePacket.objectid = objectid;
			lobbyObjectSubscribePacket.type = tournamentLobby ? LobbyTypeEnum.MTT : LobbyTypeEnum.REGULAR;			
			send(lobbyObjectSubscribePacket);
		}   
		
		/**
		 * Send an object unsubscribe packet to the game server
		 * 
		 * @param gameId
		 * @param address  FQN of lobby tree
		 * @param objectid ID of lobby object
		 * @param tournamentLobby set to true for tournament lobby
 		 */
		public function lobbyObjectUnsubscribe(gameid:int, address:String, objectid:int, tournamentLobby:Boolean = false):void {
			var lobbyObjectUnsubscribePacket:LobbyObjectUnsubscribePacket = new LobbyObjectUnsubscribePacket();
			lobbyObjectUnsubscribePacket.address = address;
			lobbyObjectUnsubscribePacket.gameid = gameid;
			lobbyObjectUnsubscribePacket.objectid = objectid;
			lobbyObjectUnsubscribePacket.type = tournamentLobby ? LobbyTypeEnum.MTT : LobbyTypeEnum.REGULAR;			
			send(lobbyObjectUnsubscribePacket);
		}   
		
		private function handleLobbyData(protocolObject:ProtocolObject):void
		{
			
			switch ( protocolObject.classId() )
			{
				case TableRemovedPacket.CLASSID :
					handleRemoved(TableRemovedPacket(protocolObject));
					break;

				case TableUpdatePacket.CLASSID :
					handleUpdate(TableUpdatePacket(protocolObject));
					break;

				case TableSnapshotPacket.CLASSID :
					handleSnapshot(TableSnapshotPacket(protocolObject));
					break;

				case TournamentRemovedPacket.CLASSID :
					handleTournamentRemoved(TournamentRemovedPacket(protocolObject));
					break;

				case TournamentUpdatePacket.CLASSID :
					handleTournamentUpdate(TournamentUpdatePacket(protocolObject));
					break;

				case TournamentSnapshotPacket.CLASSID :
					handleTournamentSnapshot(TournamentSnapshotPacket(protocolObject));
					break;
					
				case TableSnapshotListPacket.CLASSID :					
					handleTableSnapshotList(TableSnapshotListPacket(protocolObject));
					break;

				case TableUpdateListPacket.CLASSID :					
					handleTableUpdateList(TableUpdateListPacket(protocolObject));
					break;
			
				case TournamentSnapshotListPacket.CLASSID :					
					handleTournamentSnapshotList(TournamentSnapshotListPacket(protocolObject));
					break;

				case TournamentUpdateListPacket.CLASSID :					
					handleTournamentUpdateList(TournamentUpdateListPacket(protocolObject));
					break;					
			}

		}
		
		private function handleTableSnapshotList(tableSnapshotListPacket:TableSnapshotListPacket):void
		{
			for ( var i:int = 0; i < tableSnapshotListPacket.snapshots.length; i ++ ) {
				var tableSnapshotPacket:TableSnapshotPacket = tableSnapshotListPacket.snapshots[i];
				handleSnapshot(tableSnapshotPacket);
			}
		}
		
		private function handleTableUpdateList(tableUpdateListPacket:TableUpdateListPacket):void
		{
			for ( var i:int = 0; i < tableUpdateListPacket.updates.length; i ++ ) {
				var tableUpdatePacket:TableUpdatePacket = tableUpdateListPacket.updates[i];
				handleUpdate(tableUpdatePacket);
			}
		}

		private function handleTournamentSnapshotList(tournamentSnapshotListPacket:TournamentSnapshotListPacket):void
		{
			for ( var i:int = 0; i < tournamentSnapshotListPacket.snapshots.length; i ++ ) {
				var tournamentSnapshotPacket:TournamentSnapshotPacket = tournamentSnapshotListPacket.snapshots[i];
				handleTournamentSnapshot(tournamentSnapshotPacket);
			}
		}
		
		private function handleTournamentUpdateList(tournamentUpdateListPacket:TournamentUpdateListPacket):void
		{
			for ( var i:int = 0; i < tournamentUpdateListPacket.updates.length; i ++ ) {
				var tournamentUpdatePacket:TournamentUpdatePacket = tournamentUpdateListPacket.updates[i];
				handleTournamentUpdate(tournamentUpdatePacket);
			}
		}

		private function dispatchLobbyEvent(eventType:String, tableId:int, lobbyDataItem:LobbyDataItem = null):void
		{
			var lobbyEvent:LobbyEvent = new LobbyEvent(eventType, tableId, lobbyDataItem);
			dispatchEvent(lobbyEvent);			
		}		

		private function dispatchTournamentEvent(eventType:String, mttId:int, tournamentDataItem:TournamentDataItem = null):void
		{
			var tournamentEvent:TournamentEvent = new TournamentEvent(eventType, mttId, tournamentDataItem);
			dispatchEvent(tournamentEvent);			
		}		
		
		private function handleRemoved(tableRemovedPacket:TableRemovedPacket):void
		{
			dispatchLobbyEvent(LobbyEvent.TABLE_REMOVED, tableRemovedPacket.tableid);
		}
		
		private function handleUpdate(tableUpdatePacket:TableUpdatePacket):void
		{
			var lobbyDataItem:LobbyDataItem = new LobbyDataItem();
			lobbyDataItem.makeUpdateEvent(tableUpdatePacket);
			dispatchLobbyEvent(LobbyEvent.TABLE_UPDATED, tableUpdatePacket.tableid, lobbyDataItem);

		}
		
		private function handleSnapshot(tableSnapshotPacket:TableSnapshotPacket):void
		{
			var lobbyDataItem:LobbyDataItem = new LobbyDataItem();
			lobbyDataItem.makeSnapshotEvent(tableSnapshotPacket);
			dispatchLobbyEvent(LobbyEvent.TABLE_ADDED, tableSnapshotPacket.tableid, lobbyDataItem);
		}


		private function handleTournamentRemoved(tournamentRemovedPacket:TournamentRemovedPacket):void
		{
			dispatchTournamentEvent(TournamentEvent.TOURNAMENT_REMOVED, tournamentRemovedPacket.mttid);
		}
		
		private function handleTournamentUpdate(tournamentUpdatePacket:TournamentUpdatePacket):void
		{
			var tournamentDataItem:TournamentDataItem = new TournamentDataItem();
			tournamentDataItem.makeUpdateEvent(tournamentUpdatePacket);
			dispatchTournamentEvent(TournamentEvent.TOURNAMENT_UPDATED, tournamentUpdatePacket.mttid, tournamentDataItem);

		}
		
		private function handleTournamentSnapshot(tournamentSnapshotPacket:TournamentSnapshotPacket):void
		{
			var tournamentDataItem:TournamentDataItem = new TournamentDataItem();
			tournamentDataItem.makeSnapshotEvent(tournamentSnapshotPacket);

			dispatchTournamentEvent(TournamentEvent.TOURNAMENT_ADDED, tournamentSnapshotPacket.mttid, tournamentDataItem);
		}

		
		
	}
}


