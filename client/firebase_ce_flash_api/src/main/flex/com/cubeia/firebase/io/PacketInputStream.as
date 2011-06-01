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

package com.cubeia.firebase.io
{
	import flash.utils.ByteArray;
	
	public class PacketInputStream
	{
		private var inBuffer:ByteArray;

	    public function PacketInputStream(inBuffer:ByteArray) 
	    {
	        this.inBuffer = inBuffer;
	    }
	
	    public function loadByte():int 
	    {
	        return inBuffer.readByte();
	    }
	
	    public function loadUnsignedByte():uint 
	    {
	        return inBuffer.readUnsignedByte();
	    }
	
	    public function loadUnsignedShort():uint 
	    {
	        return inBuffer.readUnsignedShort();
	    }
	
	    public function loadShort():int 
	    {
	        return inBuffer.readShort();
	    }
	
	    public function loadInt():int
	    {
	        return inBuffer.readInt();
	    }
	
		public function loadUnsignedInt():uint
	    {
	        return inBuffer.readUnsignedInt();
	    }
	
	    public function loadLong():int
	    {
	    	var msb:int = inBuffer.readInt();
	    	var lsb:int = inBuffer.readInt();
	    	trace("loadLong MSB:" + msb + "LSB:" + lsb);
	      return lsb;
	    }
	    
	    public function loadNumber():Number
	    {
	    	return loadLong();
	    }
	
	    public function loadBoolean():Boolean  
	    {
	        return inBuffer.readBoolean();
	    }
	
	    public function loadString():String
	    {
	        return inBuffer.readUTF();
	    }
	
		public function loadByteArray(length:int):ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			if ( length == 0 ) {
				return buffer;
			}
			inBuffer.readBytes(buffer, 0, length);
			return buffer;
		}
	}
}