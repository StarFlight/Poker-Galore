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
	import com.hurlant.crypto.tests.TestCase;
	import flash.utils.ByteArray;

	/**
	 * 
	 * Note: The constructor accepts an optional padding argument, but ignores it otherwise.
	 */
	public class CFB8Mode extends IVMode implements IMode
	{
		public function CFB8Mode(key:ISymmetricKey, padding:IPad = null) {
			super(key, null);
		}
		
		public function encrypt(src:ByteArray):void {
			var vector:ByteArray = getIV4e();
			var tmp:ByteArray = new ByteArray;
			for (var i:uint=0;i<src.length;i++) {
				tmp.position = 0;
				tmp.writeBytes(vector);
				key.encrypt(vector);
				src[i] ^= vector[0];
				// rotate
				for (var j:uint=0;j<blockSize-1;j++) {
					vector[j] = tmp[j+1];
				}
				vector[blockSize-1] = src[i];
			}
		}
		
		public function decrypt(src:ByteArray):void {
			var vector:ByteArray = getIV4d();
			var tmp:ByteArray = new ByteArray;
			for (var i:uint=0;i<src.length;i++) {
				var c:uint = src[i];
				tmp.position = 0;
				tmp.writeBytes(vector); // I <- tmp
				key.encrypt(vector);    // O <- vector
				src[i] ^= vector[0];
				// rotate
				for (var j:uint=0;j<blockSize-1;j++) {
					vector[j] = tmp[j+1];
				}
				vector[blockSize-1] = c;
			}

		}
		public function toString():String {
			return key.toString()+"-cfb8";
		}
	}
}