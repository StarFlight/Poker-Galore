/**
 * Copyright (C) 2010 Cubeia Ltd <info@cubeia.com>
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
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.hurlant.util.der
{
	import com.hurlant.math.BigInteger;
	
	import flash.utils.ByteArray;
	import com.hurlant.util.der.Sequence;
	
	// goal 1: to be able to parse an RSA Private Key PEM file.
	// goal 2: to parse an X509v3 cert. kinda.
	
	/**
	 * DER for dummies:
	 * http://luca.ntop.org/Teaching/Appunti/asn1.html
	 * 
	 * This class does the bare minimum to get by. if that.
	 */
	public class DER
	{
		public static var indent:String = "";
		
		public static function parse(der:ByteArray, structure:*=null):IAsn1Type {
			// type
			var type:int = der.readUnsignedByte();
			var constructed:Boolean = (type&0x20)!=0;
			type &=0x1F;
			// length
			var len:int = der.readUnsignedByte();
			if (len>=0x80) {
				// long form of length
				var count:int = len & 0x7f;
				len = 0;
				while (count>0) {
					len = (len<<8) | der.readUnsignedByte();
					count--;
				}
			}
			// data
			var b:ByteArray
			switch (type) {
				case 0x00: // WHAT IS THIS THINGY? (seen as 0xa0)
					// (note to self: read a spec someday.)
					// for now, treat as a sequence.
				case 0x10: // SEQUENCE/SEQUENCE OF. whatever
					// treat as an array
					var p:int = der.position;
					var o:Sequence = new Sequence(type, len);
					var arrayStruct:Array = structure as Array;
					while (der.position < p+len) {
						var tmpStruct:Object = null
						if (arrayStruct!=null) {
							tmpStruct = arrayStruct.shift();
						}
						if (tmpStruct!=null) {
							var name:String = tmpStruct.name;
							var value:* = tmpStruct.value;
							var obj:IAsn1Type = DER.parse(der, value);
							o.push(obj);
							o[name] = obj;
						} else {
							o.push(DER.parse(der));
						}
					}
					return o;
				case 0x11: // SET/SET OF
					p = der.position;
					var s:Set = new Set(type, len);
					while (der.position < p+len) {
						s.push(DER.parse(der));
					}
					return s;
				case 0x02: // INTEGER
					// put in a BigInteger
					b = new ByteArray;
					der.readBytes(b,0,len);
					b.position=0;
					return new Integer(type, len, b);
				case 0x06: // OBJECT IDENTIFIER:
					b = new ByteArray;
					der.readBytes(b,0,len);
					b.position=0;
					return new ObjectIdentifier(type, len, b);
				default:
					trace("I DONT KNOW HOW TO HANDLE DER stuff of TYPE "+type);
					// fall through
				case 0x04: // OCTET STRING
				case 0x03: // BIT STRING
					// stuff in a ByteArray for now.
					var bs:ByteString = new ByteString(type, len);
					der.readBytes(bs,0,len);
					return bs;
				case 0x05: // NULL
					// if len!=0, something's horribly wrong.
					// should I check?
					return null;
				case 0x13: // PrintableString
					var ps:PrintableString = new PrintableString(type, len);
					ps.setString(der.readMultiByte(len, "US-ASCII"));
					return ps;
				case 0x14: // T61String
					ps = new PrintableString(type, len);
					ps.setString(der.readMultiByte(len, "latin1"));
					return ps;
				case 0x17: // UTCTime
					var ut:UTCTime = new UTCTime(type, len);
					ut.setUTCTime(der.readMultiByte(len, "US-ASCII"));
					return ut;
			}
		}
	}
}