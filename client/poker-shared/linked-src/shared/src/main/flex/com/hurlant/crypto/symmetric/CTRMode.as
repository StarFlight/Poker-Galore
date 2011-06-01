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

	public class CTRMode extends IVMode implements IMode
	{

		public function CTRMode(key:ISymmetricKey, padding:IPad = null) {
			super(key, padding);
		}
		
		public function encrypt(src:ByteArray):void
		{
			padding.pad(src);
			var vector:ByteArray = getIV4e();
			core(src, vector);
		}
		
		public function decrypt(src:ByteArray):void
		{
			var vector:ByteArray = getIV4d();
			core(src, vector);
			padding.unpad(src);
		}
		
		private function core(src:ByteArray, iv:ByteArray):void {
			var X:ByteArray = new ByteArray;
			var Xenc:ByteArray = new ByteArray;
			X.writeBytes(iv);
			for (var i:uint=0;i<src.length;i+=blockSize) {
				Xenc.position=0;
				Xenc.writeBytes(X);
				key.encrypt(Xenc);
				for (var j:uint=0;j<blockSize;j++) {
					src[i+j] ^= Xenc[j];
				}
				
 				for (j=blockSize-1;j>=0;--j) {
					X[j]++;
					if (X[j]!=0)
						break;
				}
			}
		}
		public function toString():String {
			return key.toString()+"-ctr";
		}
		
	}
}