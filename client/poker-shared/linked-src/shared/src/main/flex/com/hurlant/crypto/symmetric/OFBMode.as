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

	public class OFBMode extends IVMode implements IMode
	{
		public function OFBMode(key:ISymmetricKey, padding:IPad=null)
		{
			super(key, null);
		}
		
		public function encrypt(src:ByteArray):void
		{
			var vector:ByteArray = getIV4e();
			core(src, vector);
		}
		
		public function decrypt(src:ByteArray):void
		{
			var vector:ByteArray = getIV4d();
			core(src, vector);
		}
		
		private function core(src:ByteArray, iv:ByteArray):void { 
			var l:uint = src.length;
			var tmp:ByteArray = new ByteArray;
			for (var i:uint=0;i<src.length;i+=blockSize) {
				key.encrypt(iv);
				tmp.position=0;
				tmp.writeBytes(iv);
				var chunk:uint = (i+blockSize<l)?blockSize:l-i;
				for (var j:uint=0;j<chunk;j++) {
					src[i+j] ^= iv[j];
				}
				iv.position=0;
				iv.writeBytes(tmp);
			}
		}
		public function toString():String {
			return key.toString()+"-ofb";
		}
		
	}
}