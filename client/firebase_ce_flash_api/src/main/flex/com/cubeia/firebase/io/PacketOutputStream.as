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

﻿package com.cubeia.firebase.io
{
	import flash.utils.ByteArray;
	
	public class PacketOutputStream
	{
	    private var outputBuffer:ByteArray;

	    public function PacketOutputStream(buffer:ByteArray) 
	    {
	        this.outputBuffer = buffer;
	    }
	
	    public function saveByte(val:int):void 
	    {
	        outputBuffer.writeByte(val);
	    }
	
	    public function saveUnsignedByte(val:uint):void
	    {
	        outputBuffer.writeByte(val);
	    }
	
	    public function saveUnsignedShort(val:uint):void
	    {
	        outputBuffer.writeShort(val);
	    }
	
	    public function saveShort(val:int):void
	    {
	        outputBuffer.writeShort(val);
	    }
	
	    public function saveInt(val:int):void
	    {
	        outputBuffer.writeInt(val);
	    }
	
	    public function saveLong(val:Number):void
	    {
	        outputBuffer.writeInt(0);
	        outputBuffer.writeInt(val);
	    }
	
		public function saveNumber(val:Number):void
	    {
	        //outputBuffer.writeLong(val);
	    }
	
	    public function saveBoolean(val:Boolean):void
	    {
	        outputBuffer.writeBoolean(val);
	    }
	
	    public function saveString(val:String):void
	    {
	        outputBuffer.writeUTF(val);
	    }
	
		public function saveArray(gamedata:ByteArray):void
		{
			outputBuffer.writeBytes(gamedata, 0, gamedata.length);
		}

	}
}