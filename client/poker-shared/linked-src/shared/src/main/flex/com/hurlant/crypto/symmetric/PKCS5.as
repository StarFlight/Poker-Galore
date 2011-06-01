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
	
	public class PKCS5 implements IPad
	{
		private var blockSize:uint;
		
		public function PKCS5(blockSize:uint=0) {
			this.blockSize = blockSize;
		}
		
		public function pad(a:ByteArray):void {
			var c:uint = blockSize-a.length%blockSize;
			for (var i:uint=0;i<c;i++){
				a[a.length] = c;
			}
		}
		public function unpad(a:ByteArray):void {
			var c:uint = a.length%blockSize;
			if (c!=0) throw new Error("PKCS#5::unpad: ByteArray.length isn't a multiple of the blockSize");
			c = a[a.length-1];
			for (var i:uint=c;i>0;i--) {
				var v:uint = a[a.length-1];
				a.length--;
				if (c!=v) throw new Error("PKCS#5:unpad: Invalid padding value. expected ["+c+"], found ["+v+"]");
			}
			// that is all.
		}

		public function setBlockSize(bs:uint):void {
			blockSize = bs;
		}

	}
}