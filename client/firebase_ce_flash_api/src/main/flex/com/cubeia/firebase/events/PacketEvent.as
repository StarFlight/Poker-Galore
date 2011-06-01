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
	import com.cubeia.firebase.io.ProtocolObject;
	
	import flash.events.Event;
	
	/**
	 * Event class for protocol events
	 * 
	 * @author	Peter Lundh
	 */
	

	public class PacketEvent extends Event
	{
		/**
		* PacketEvent.PACKET_RECEIVED defines the 
		* <code>type</code> property of the event object 
		* for a <code>_fb_packet</code> event.
		*
		* @eventType _fb_packet
		*/
		public static const PACKET_RECEIVED:String 	= "_fb_packet";
		
		/**
		 * constructor
		 */
		public function PacketEvent(receivedPacket:ProtocolObject = null)
		{
			super(PACKET_RECEIVED);
			if ( receivedPacket != null ) {
				_object = receivedPacket;
			}
			
		}
		
		/**
		 * Set object
		 * 
		 * @param ProtocolObject
		 */
		public function setObject(object:ProtocolObject):void
		{
			_object = object;
		}
		
		/**
		 * Retrieve object
		 * 
		 * @return ProtocolObject
		 */
		public function getObject():ProtocolObject
		{
			return _object;
		}
		
		
		private var _object:ProtocolObject;

	}
}