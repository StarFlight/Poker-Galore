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
	
	public class StyxSerializer
	{
		public static var HEADER_SIZE:int = 4;
  	    private var factory:ObjectFactory;

		/**
		 * Get ObjectFactory instance, can be null
		 * 
		 * @return ObjectFactory
		 */
		public function getObjectFactory():ObjectFactory {
			return factory;
		}
			
	  	/**
	     * Initialize this class with the automatically generated
	     * ObjectFactory
	     */
	    public function StyxSerializer(factory:ObjectFactory):void {
			this.factory = factory;
	    }
	
	    /**
	     * Unpack a byte sequence into a concrete ProtocolObject.
	     * 
	     * @param inBuffer - byte array of packed object
	     * @return ProtocolObject
	     */
	    public function unpack(inBuffer:ByteArray):ProtocolObject  {
	
	    	var payloadLength:int = inBuffer.readInt();
	    	
	    	// Styx by default uses length exclusive from the length header
	        if( inBuffer.bytesAvailable < payloadLength-HEADER_SIZE)
	            return null;
	        
	        var classId:int = inBuffer.readUnsignedByte();
	        var po:ProtocolObject = factory.create(classId);
	        po.load(inBuffer);
	
	        return po;
	    }
   
	    /**
	     * Pack a ProtocolObject into a styx byte array
	     * 
	     * @param protocolObject - Object to pack
	     */
	    public function pack(protocolObject:ProtocolObject):ByteArray {
	        var packed:ByteArray = protocolObject.save();
	        var buf:ByteArray = new ByteArray();
	        buf.writeInt(1+HEADER_SIZE+packed.length);
	        buf.writeByte(protocolObject.classId());
	        packed.position = 0;
	        buf.writeBytes(packed);
	        buf.position = 0;
	        return buf;
	    }
	}
}