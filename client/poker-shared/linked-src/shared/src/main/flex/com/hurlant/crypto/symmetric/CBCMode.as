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
	 * CBC confidentiality mode. why not.
	 */
	public class CBCMode extends IVMode implements IMode
	{
		
		public function CBCMode(key:ISymmetricKey, padding:IPad = null) {
			super(key, padding);
		}

		public function encrypt(src:ByteArray):void {
			padding.pad(src);
			var vector:ByteArray = getIV4e();
			for (var i:uint=0;i<src.length;i+=blockSize) {
				for (var j:uint=0;j<blockSize;j++) {
					src[i+j] ^= vector[j];
				}
				key.encrypt(src, i);
				vector.position=0;
				vector.writeBytes(src, i, blockSize);
			}
		}
		public function decrypt(src:ByteArray):void {
			var vector:ByteArray = getIV4d();
			var tmp:ByteArray = new ByteArray;
			for (var i:uint=0;i<src.length;i+=blockSize) {
				tmp.position=0;
				tmp.writeBytes(src, i, blockSize);
				key.decrypt(src, i);
				for (var j:uint=0;j<blockSize;j++) {
					src[i+j] ^= vector[j];
				}
				vector.position=0;
				vector.writeBytes(tmp, 0, blockSize);
			}
			padding.unpad(src);
		}
		
		public function toString():String {
			return key.toString()+"-cbc";
		}
	}
}
