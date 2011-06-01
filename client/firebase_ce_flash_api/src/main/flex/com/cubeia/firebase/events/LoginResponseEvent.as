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
	import com.cubeia.firebase.io.protocol.LoginResponsePacket;
	import com.cubeia.firebase.model.PlayerInfo;
	
	import flash.events.Event;

	public class LoginResponseEvent extends Event
	{
		/**
		* LoginEvent.LOGIN defines the 
		* <code>type</code> property of the event object 
		* for a <code>_fb_login</code> event.
		*
		* @eventType _fb_login
		*/
		public static const LOGIN:String 	= "_fb_login";
		
	
		public function LoginResponseEvent(loginResponsePacket:LoginResponsePacket)
		{
			super(LOGIN);
			playerInfo = new PlayerInfo();
			playerInfo.setPlayerInfo(loginResponsePacket);
		}
		
		public function getPlayerInfo():PlayerInfo
		{
			return playerInfo;
		}
		
		private var playerInfo:PlayerInfo;
	}
}