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
	import flash.utils.ByteArray;

	/**
	 * This is the "full" CFB.
	 * CFB1 and CFB8 are hiding somewhere else.
	 * 
	 * Note: The constructor accepts an optional padding argument, but ignores it otherwise.
	 */
	public class CFBMode extends IVMode implements IMode
	{
		
		public function CFBMode(key:ISymmetricKey, padding:IPad = null) {
			super(key,null);
		}

		public function encrypt(src:ByteArray):void
		{
			var l:uint = src.length;
			var vector:ByteArray = getIV4e();
			for (var i:uint=0;i<src.length;i+=blockSize) {
				key.encrypt(vector);
				var chunk:uint = (i+blockSize<l)?blockSize:l-i;
				for (var j:uint=0;j<chunk;j++) {
					src[i+j] ^= vector[j];
				}
				vector.position=0;
				vector.writeBytes(src, i, chunk);
			}
		}
		
		public function decrypt(src:ByteArray):void
		{
			var l:uint = src.length;
			var vector:ByteArray = getIV4d();
			var tmp:ByteArray = new ByteArray;
			for (var i:uint=0;i<src.length;i+=blockSize) {
				key.encrypt(vector);
				var chunk:uint = (i+blockSize<l)?blockSize:l-i;
				tmp.position=0;
				tmp.writeBytes(src, i, chunk);
				for (var j:uint=0;j<chunk;j++) {
					src[i+j] ^= vector[j];
				}
				vector.position=0;
				vector.writeBytes(tmp);
			}
		}
		
		public function toString():String {
			return key.toString()+"-cfb";
		}

	}
}