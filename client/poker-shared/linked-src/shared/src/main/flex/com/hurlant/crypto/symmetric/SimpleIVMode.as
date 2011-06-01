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
	
	public class SimpleIVMode implements IMode, ICipher
	{
		protected var mode:IVMode;
		protected var cipher:ICipher;
		
		public function SimpleIVMode(mode:IVMode) {
			this.mode = mode;
			cipher = mode as ICipher;
		}
		
		public function getBlockSize():uint {
			return mode.getBlockSize();
		}
		
		public function dispose():void {
			mode.dispose();
			mode = null;
			cipher = null;
			Memory.gc();
		}
		
		public function encrypt(src:ByteArray):void {
			cipher.encrypt(src);
			var tmp:ByteArray = new ByteArray;
			tmp.writeBytes(mode.IV);
			tmp.writeBytes(src);
			src.position=0;
			src.writeBytes(tmp);
		}
		
		public function decrypt(src:ByteArray):void {
			var tmp:ByteArray = new ByteArray;
			tmp.writeBytes(src, 0, getBlockSize());
			mode.IV = tmp;
			tmp = new ByteArray;
			tmp.writeBytes(src, getBlockSize());
			cipher.decrypt(tmp);
			src.length=0;
			src.writeBytes(tmp);
		}
		public function toString():String {
			return "simple-"+cipher.toString();
		}
	}
}