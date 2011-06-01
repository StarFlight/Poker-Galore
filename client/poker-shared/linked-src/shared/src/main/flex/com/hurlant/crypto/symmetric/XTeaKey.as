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

package com.hurlant.crypto.symmetric
{
	import com.hurlant.crypto.prng.Random;
	import com.hurlant.util.Memory;
	
	import flash.utils.ByteArray;
	
	
	public class XTeaKey implements ISymmetricKey
	{
		public const NUM_ROUNDS:uint = 64;	
		private var k:Array;

		public function XTeaKey(a:ByteArray) {
			a.position=0;
			k = [a.readUnsignedInt(),a.readUnsignedInt(),a.readUnsignedInt(),a.readUnsignedInt()];
		}
		/**
		 * K is an hex string with 32 digits.
		 */
		public static function parseKey(K:String):XTeaKey {
			var a:ByteArray = new ByteArray;
			a.writeUnsignedInt(parseInt(K.substr(0,8),16));
			a.writeUnsignedInt(parseInt(K.substr(8,8),16));
			a.writeUnsignedInt(parseInt(K.substr(16,8),16));
			a.writeUnsignedInt(parseInt(K.substr(24,8),16));
			a.position = 0;
			return new XTeaKey(a);
		}
		
		public function getBlockSize():uint {
			return 8;
		}

		public function encrypt(block:ByteArray, index:uint=0):void {
			block.position = index;
			var v0:uint = block.readUnsignedInt();
			var v1:uint = block.readUnsignedInt();
			var i:uint;
			var sum:uint =0;
			var delta:uint = 0x9E3779B9;
			for (i=0; i<NUM_ROUNDS; i++) {
				v0 += (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + k[sum & 3]);
				sum += delta;
		        v1 += (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + k[(sum>>11) & 3]);
			}
			block.position-=8;
			block.writeUnsignedInt(v0);
			block.writeUnsignedInt(v1);
		}
		
		public function decrypt(block:ByteArray, index:uint=0):void {
			block.position = index;
			var v0:uint = block.readUnsignedInt();
			var v1:uint = block.readUnsignedInt();
			var i:uint;
			var delta:uint = 0x9E3779B9;
			var sum:uint = delta*NUM_ROUNDS;
			for (i=0; i<NUM_ROUNDS; i++) {
				v1 -= (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + k[(sum>>11) & 3]);
				sum -= delta;
				v0 -= (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + k[sum & 3]);
			}
			block.position-=8;
			block.writeUnsignedInt(v0);
			block.writeUnsignedInt(v1);
		}

		public function dispose():void {
			//private var k:Array;
			var r:Random = new Random;
			for (var i:uint=0;i<k.length;i++) {
				k[i] = r.nextByte();
				delete k[i];
			}
			k = null;
			Memory.gc();
		}

		public function toString():String {
			return "xtea";
		}
	}
	

}