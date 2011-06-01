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
	import flash.events.Event;

	public class DisconnectEvent extends Event
	{
		/**
		* DisconnectEvent.DISCONNECT defines the 
		* <code>type</code> property of the event object 
		* for a <code>_fb_disconnect</code> event.
		*
		* @eventType _fb_disconnect
		*/
		
		public static const DISCONNECT:String 		= "_fb_disconnect";
	
		public function DisconnectEvent()
		{
			super(DISCONNECT, false, false);
		}
		
	}
}