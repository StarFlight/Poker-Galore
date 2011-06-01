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

package com.cubeia.firebase.comm
{
	import com.hurlant.crypto.tls.TLSConfig;
	import com.hurlant.crypto.tls.TLSEngine;
	import com.hurlant.crypto.tls.TLSSocket;
	
	import flash.errors.EOFError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class FirebaseSocket
	{
		// data buffer		
		private var socketBuffer:ByteArray = new ByteArray();
		
		// byte counters for read loop
		private var bytesLeft:int = 0;
		private var bytesTotal:int = 0;
		
		// class id of buffered data
		private var classId:int = 0;
		
		// Data handler
		private var dataHandler:SocketDataHandler;

		// Socket
		private var socket:Socket = null;
		
		// SSL Socket (TLS)
		private var tlsSocket:TLSSocket = null;
		
		private var tlsConfig:TLSConfig = null;
		// Port to connect to
		private var port:uint;

		// Hostname or ip-address
		private var host:String;
		
		private var handshakeSignature:uint;
		
		private var useHandshake:Boolean;
		
		private var useTLS:Boolean;
		
		/**
		 * Constructor
		 * 
		 * @param dataHandler - SocketDataHandler interface implementation 
		 * @param useHandshake - send a handshake signature in every packet
		 * @param handshakeSignature - signature to use as handshake
		 */
		public function FirebaseSocket(dataHandler:SocketDataHandler, useHandshake:Boolean = false, handshakeSignature:uint = 0, useTLS:Boolean = false, tlsConfig:TLSConfig = null):void 
		{
			this.dataHandler = dataHandler;
			this.handshakeSignature = handshakeSignature;
			this.useHandshake = useHandshake;
			this.useTLS = useTLS;
			this.tlsConfig = tlsConfig;
			createSocket();
		}
		
		/**
		 * Return true if socket is connected
		 * 
		 * @return connected
		 */
		public function get connected():Boolean
		{
			if ( !useTLS ) {
				return socket.connected;
			} else {
				return tlsSocket.connected;
			}
		}
		
		/**
		 * Connect to the Firebase server
		 * 
		 * @param host - host name or ip address of the Firebase server
		 * @param port - tcp port to connect to
		 * @param crossDomainPolicyServerPort - port of cross domain xmlsocket request
		 *
		 */ 
		public function connect(host:String, port:uint = 4123, crossDomainPolicyServerPort:uint = 4122):void
		{
			if ( !useTLS ) {
				// create a new socket if we don't have one already
				if ( socket == null )
				{
					socket = new Socket();
				}
				
				// make sure we're not already connected
				if ( !socket.connected ) 
				{
					Security.allowDomain("*");
					var crossdomainURL:String = "xmlsocket://" + host + ":" + crossDomainPolicyServerPort;
					Security.loadPolicyFile(crossdomainURL);
					createSocket();
					socket.connect(host, port);
					this.port = port;
					this.host = host;
				} 

			} else {
				// create a new socket if we don't have one already
				if ( tlsSocket == null ) {
					tlsSocket = new TLSSocket();
				}
				
				var tlsConnected:Boolean = false;
				try {
					tlsConnected = tlsSocket.connected; 
				} catch ( error:Error ) {
					
				}
				
				// make sure we're not already connected
				if ( !tlsConnected ) 
				{
					Security.allowDomain("*");
					crossdomainURL = "xmlsocket://" + host + ":4122";// + crossDomainPolicyServerPort;
					Security.loadPolicyFile(crossdomainURL);
					createSocket();
					/*var config:TLSConfig = new TLSConfig( TLSEngine.CLIENT );
					config.ignoreCommonNameMismatch = true;
					config.promptUserForAcceptCert = true;
					config.trustAllCertificates = true;*/
					tlsSocket = new TLSSocket();
					tlsSocket.setTLSConfig(tlsConfig);
					tlsSocket.addEventListener(Event.CONNECT, connectHandler);
					tlsSocket.addEventListener(Event.CLOSE, closeHandler);
					tlsSocket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					tlsSocket.addEventListener(ProgressEvent.SOCKET_DATA, readHandler);
					tlsSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorEvent);
					tlsSocket.connect(host, port);
					this.port = port;
					this.host = host;
				} 

			}
		}

		/**
		 * Send an array of bytes to the game server
		 * 
		 * @param buffer - bytes to send
		 */ 
		public function send(buffer:ByteArray):void
		{
			if ( !useTLS ) {
				if ( socket.connected ) {
					buffer.position = 0;
					socket.writeBytes(buffer);
					socket.flush();
				} 
			} else {
				if ( tlsSocket.connected) {
					buffer.position = 0;
					tlsSocket.writeBytes(buffer);
					tlsSocket.flush();
				} 			
			}
		}

		/**
		 * Close connection
		 */
		public function close():void
		{
			deleteSocket();
		}
		
		// create a socket object and setup event listeners	
		private function createSocket():void
		{
			if ( !useTLS ) {
				socket = new Socket();
				socket.addEventListener(Event.CONNECT, connectHandler);
				socket.addEventListener(Event.CLOSE, closeHandler);
				socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				socket.addEventListener(ProgressEvent.SOCKET_DATA, readHandler);
				socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorEvent);
			}
		}					
		// delete socket and disable event listeners
		private function deleteSocket():void
		{
			if ( !useTLS ) {
				socket.removeEventListener(Event.CONNECT, connectHandler);
				socket.removeEventListener(Event.CLOSE, closeHandler);
				socket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				socket.removeEventListener(ProgressEvent.SOCKET_DATA, readHandler);
				socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorEvent);
				socket.close();
				socket = null;
			} else {
				tlsSocket.removeEventListener(Event.CONNECT, connectHandler);
				tlsSocket.removeEventListener(Event.CLOSE, closeHandler);
				tlsSocket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				tlsSocket.removeEventListener(ProgressEvent.SOCKET_DATA, readHandler);
				tlsSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorEvent);
				tlsSocket.close();
				tlsSocket = null;
				
			}
		}

		
		//
		private function closeHandler(event:Event):void
		{
			deleteSocket();
			dataHandler.handleDisconnect(event);		
		}
		
		// called when data is available for read
		private function readHandler(event:ProgressEvent):void
		{
			while ( true )
			{
				if ( bytesTotal == 0 )
				{
					socketBuffer = new ByteArray();
					socketBuffer.endian = Endian.BIG_ENDIAN;
					
					// we need at least three bytes to read the length indicator + classid
					var bytesAvailable:int;
					if ( !useTLS ) {
						bytesAvailable = socket.bytesAvailable; 
					} else {
						bytesAvailable = tlsSocket.bytesAvailable;
					}

					if ( bytesAvailable >= 5 )
					{
						// read packet length
						if ( !useTLS) {
							bytesTotal = socket.readInt();
						} else {
							bytesTotal = tlsSocket.readInt();
						}
						bytesLeft = bytesTotal - 4;
						// put to buffer
						socketBuffer.writeInt(bytesTotal);
						
						// read classid
						if ( !useTLS) {
							classId = socket.readByte();
						} else {
							classId = tlsSocket.readByte();
						}
						bytesLeft --;
						socketBuffer.writeByte(classId);
					}
				}
	
						
				try {
					var available:int;
					if ( !useTLS) {
						available = socket.bytesAvailable < bytesLeft ? socket.bytesAvailable : bytesLeft;
					} else {
						available = tlsSocket.bytesAvailable < bytesLeft ? tlsSocket.bytesAvailable : bytesLeft;
					}
					if ( !useTLS) {
						socket.readBytes(socketBuffer, bytesTotal-bytesLeft, available);
					} else {
						tlsSocket.readBytes(socketBuffer, bytesTotal-bytesLeft, available);
					}
					bytesLeft -= available;
					if ( bytesLeft == 0 ) 
					{
						socketBuffer.position = 0;
						bytesTotal = 0;
						dataHandler.handleData(classId, socketBuffer);
					} 
				} catch (e:EOFError) {
						
				}
				// do we have enough data to start reading a new packet?
				if ( !useTLS ) {
					bytesAvailable = socket.bytesAvailable; 
				} else {
					bytesAvailable = tlsSocket.bytesAvailable;
				}
				
				if ( bytesAvailable < 5 )
				{
					break;
				}
			}			
		}
		
		private function connectHandler(event:Event):void
		{
			// make sure we have big endian style when reading ints and shorts
			if ( !useTLS ) {
				socket.endian = Endian.BIG_ENDIAN;
			} else {
				tlsSocket.endian = Endian.BIG_ENDIAN;
			}
			
			// Send signature handshake if required
			if ( useHandshake ) 
			{
				if ( !useTLS ) {
					socket.writeUnsignedInt(handshakeSignature);
					socket.flush();
				} else {
					tlsSocket.writeUnsignedInt(handshakeSignature);
					tlsSocket.flush();
				}
			}
			
			dataHandler.handleConnect(event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			deleteSocket();
			dataHandler.handleIOError(event);		
		}
	
		private function onSecurityErrorEvent(event:SecurityErrorEvent):void 
		{
			dataHandler.handleSecurityEvent(event);
		}

		
		private function onStatusEvent(event:StatusEvent):void 
		{
			dataHandler.handleStatusEvent(event);
		}
	
	}
}