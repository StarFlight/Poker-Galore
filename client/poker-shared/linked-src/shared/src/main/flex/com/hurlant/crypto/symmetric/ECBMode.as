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
	import com.hurlant.util.Memory;
	import com.hurlant.util.Hex;
	
	/**
	 * ECB mode.
	 * This uses a padding and a symmetric key.
	 * If no padding is given, PKCS#5 is used.
	 */
	public class ECBMode implements IMode
	{
		private var key:ISymmetricKey;
		private var padding:IPad;
		
		public function ECBMode(key:ISymmetricKey, padding:IPad = null) {
			this.key = key;
			if (padding == null) {
				padding = new PKCS5(key.getBlockSize());
			}
			this.padding = padding;
		}
		
		public function getBlockSize():uint {
			return key.getBlockSize();
		}
		
		public function encrypt(src:ByteArray):void {
			padding.pad(src);
			src.position = 0;
			var blockSize:uint = key.getBlockSize();
			var tmp:ByteArray = new ByteArray;
			var dst:ByteArray = new ByteArray;
			for (var i:uint=0;i<src.length;i+=blockSize) {
				tmp.length=0;
				src.readBytes(tmp, 0, blockSize);
				key.encrypt(tmp);
				dst.writeBytes(tmp);
			}
			src.length=0;
			src.writeBytes(dst);
		}
		public function decrypt(src:ByteArray):void {
			src.position = 0;
			var blockSize:uint = key.getBlockSize();
			
			// sanity check.
			if (src.length%blockSize!=0) {
				throw new Error("ECB mode cipher length must be a multiple of blocksize "+blockSize);
			}
			
			var tmp:ByteArray = new ByteArray;
			var dst:ByteArray = new ByteArray;
			for (var i:uint=0;i<src.length;i+=blockSize) {
				tmp.length=0;
				src.readBytes(tmp, 0, blockSize);
				
				key.decrypt(tmp);
				dst.writeBytes(tmp);
			}
			padding.unpad(dst);
			src.length=0;
			src.writeBytes(dst);
		}
		public function dispose():void {
			key.dispose();
			key = null;
			padding = null;
			Memory.gc();
		}
		public function toString():String {
			return key.toString()+"-ecb";
		}
	}
}