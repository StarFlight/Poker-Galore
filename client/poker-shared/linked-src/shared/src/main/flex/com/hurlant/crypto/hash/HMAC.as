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

package com.hurlant.crypto.hash
{
	import flash.utils.ByteArray;
	import com.hurlant.util.Hex;
	
	public class HMAC
	{
		private var hash:IHash;
		private var bits:uint;
		
		/**
		 * Create a HMAC object, using a Hash function, and 
		 * optionally a number of bits to return. 
		 * The HMAC will be truncated to that size if needed.
		 */
		public function HMAC(hash:IHash, bits:uint=0) {
			this.hash = hash;
			this.bits = bits;
		}
		
		/**
		 * Compute a HMAC using a key and some data.
		 * It doesn't modify either, and returns a new ByteArray with the HMAC value.
		 */
		public function compute(key:ByteArray, data:ByteArray):ByteArray {
			var hashKey:ByteArray;
			if (key.length>hash.getInputSize()) {
				hashKey = hash.hash(key);
			} else {
				hashKey = new ByteArray;
				hashKey.writeBytes(key);
			}
			while (hashKey.length<hash.getInputSize()) {
				hashKey[hashKey.length]=0;
			}
			var innerKey:ByteArray = new ByteArray;
			var outerKey:ByteArray = new ByteArray;
			for (var i:uint=0;i<hashKey.length;i++) {
				innerKey[i] = hashKey[i] ^ 0x36;
				outerKey[i] = hashKey[i] ^ 0x5c;
			}
			// inner + data
			innerKey.position = hashKey.length;
			innerKey.writeBytes(data);
			var innerHash:ByteArray = hash.hash(innerKey);
			// outer + innerHash
			outerKey.position = hashKey.length;
			outerKey.writeBytes(innerHash);
			var outerHash:ByteArray = hash.hash(outerKey);
			if (bits>0 && bits<8*outerHash.length) {
				outerHash.length = bits/8;
			}
			return outerHash;
		}
		public function dispose():void {
			hash = null;
			bits = 0;
		}
		public function toString():String {
			return "hmac-"+(bits>0?bits+"-":"")+hash.toString();
		}
		
	}
}