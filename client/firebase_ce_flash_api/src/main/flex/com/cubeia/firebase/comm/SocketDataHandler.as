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
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.utils.ByteArray;
	
	public interface SocketDataHandler
	{
		function handleData(classId:int, data:ByteArray):void;
		function handleConnect(event:Event):void;
		function handleError(event:Event):void;
		function handleDisconnect(event:Event):void;		
		function handleIOError(event:IOErrorEvent):void;
		function handleSecurityEvent(event:SecurityErrorEvent):void ;
		function handleStatusEvent(event:StatusEvent):void;

	}
}