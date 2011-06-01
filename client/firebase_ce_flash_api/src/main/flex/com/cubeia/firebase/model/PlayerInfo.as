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

package com.cubeia.firebase.model
{
	import flash.utils.ByteArray;
	import com.cubeia.firebase.io.protocol.LoginResponsePacket;
	
	[Bindable]
    [RemoteClass(alias="com.cubeia.firebase.model.PlayerInfo")]
    
	public class PlayerInfo 
	{
		public function setPlayerInfo(loginResponsePacket:LoginResponsePacket):void
		{
		    this.screenname = loginResponsePacket.screenname;
		    this.pid = loginResponsePacket.pid;
		    this.code = loginResponsePacket.code;
		    this.message = loginResponsePacket.message;
		    this.credentials = loginResponsePacket.credentials;
		    this.status = loginResponsePacket.status;
		}
				
		
	    public var screenname:String; 
        public var pid:int;
        public var code:int;
        public var message:String;
        public var credentials:ByteArray = new ByteArray();
        public var status:int;
        
	}
}