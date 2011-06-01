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

package com.hurlant.crypto.prng
{
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.util.Memory;
	
	import flash.utils.ByteArray;

	public class ARC4 implements IPRNG, ICipher {
		private var i:int = 0;
		private var j:int = 0;
		private var S:ByteArray;
		private var key:ByteArray;
		private const psize:uint = 256;
		public function ARC4(key:ByteArray = null){
			S = new ByteArray;
			if (key) {
				init(key);
			}
		}
		public function getPoolSize():uint {
			return psize;
		}
		public function init(key:ByteArray):void {
			this.key = key; //keep a copy, as we need to reset our state for every encrypt/decrypt call.
			var i:int;
			var j:int;
			var t:int;
			for (i=0; i<256; ++i) {
				S[i] = i;
			}
			j=0;
			for (i=0; i<256; ++i) {
				j = (j + S[i] + key[i%key.length]) & 255;
				t = S[i];
				S[i] = S[j];
				S[j] = t;
			}
			this.i=0;
			this.j=0;
		}
		public function next():uint {
			var t:int;
			i = (i+1)&255;
			j = (j+S[i])&255;
			t = S[i];
			S[i] = S[j];
			S[j] = t;
			return S[(t+S[i])&255];
		}

		public function getBlockSize():uint {
			return 1;
		}
		
		public function encrypt(block:ByteArray):void {
			init(key);
			var i:uint = 0;
			while (i<block.length) {
				block[i++] ^= next();
			}
		}
		public function decrypt(block:ByteArray):void {
			encrypt(block); // the beauty of XOR.
		}
		public function dispose():void {
			var i:uint = 0;
			for (i=0;i<S.length;i++) {
				S[i] = Math.random()*256;
			}
			for (i=0;i<key.length;i++) {
				key[i] = Math.random()*256;
			}
			S.length=0;
			key.length=0;
			S = null;
			key = null;
			this.i = 0;
			this.j = 0;
			Memory.gc();
		}
		public function toString():String {
			return "rc4";
		}
	}
}