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
	import com.cubeia.firebase.io.protocol.GameTransportPacket;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * Event class for game data packets
	 * 
	 * @author	Peter Lundh
	 */
	

	public class GamePacketEvent extends Event
	{
		/**
		* GamePacketEvent.PACKET_RECEIVED defines the 
		* <code>type</code> property of the event object 
		* for a <code>_fb_game_packet</code> event.
		*
		* @eventType _fb_game_packet
		*/
		public static const PACKET_RECEIVED:String 	= "_fb_game_packet";
		
		/**
		 * constructor
		 */
		public function GamePacketEvent(gamePacket:GameTransportPacket = null)
		{
			super(PACKET_RECEIVED);
			
			if ( gamePacket != null ) {
				_packetData = gamePacket.gamedata;
				tableid = gamePacket.tableid;
				pid = gamePacket.pid;
			}
			
		}
		
		/**
		 * Set object
		 * 
		 * @param ProtocolObject
		 */
		public function setObject(packetData:ByteArray):void
		{
			_packetData = packetData;
		}
		
		/**
		 * Retrieve object
		 * 
		 * @return ProtocolObject
		 */
		public function getPacketData():ByteArray
		{
			return _packetData;
		}
		
		
		private var _packetData:ByteArray;
		
		public var tableid:int;
		public var pid:int;

	}
}