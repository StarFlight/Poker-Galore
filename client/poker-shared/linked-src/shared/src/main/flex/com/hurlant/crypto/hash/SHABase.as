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

package com.hurlant.crypto.hash
{
	import flash.utils.ByteArray;

	public class SHABase implements IHash
	{
		public function getInputSize():uint
		{
			return 64;
		}
		
		public function getHashSize():uint
		{
			return 0;
		}
		
		public function hash(src:ByteArray):ByteArray
		{
			var savedLength:uint = src.length;
			var len:uint = savedLength *8;
			// pad to nearest int.
			while (src.length%4!=0) {
				src[src.length]=0;
			}
			// convert ByteArray to an array of uint
			src.position=0;
			var a:Array = [];
			for (var i:uint=0;i<src.length;i+=4) {
				a.push(src.readUnsignedInt());
			}
			var h:Array = core(a, len);
			var out:ByteArray = new ByteArray;
			var words:uint = getHashSize()/4;
			for (i=0;i<words;i++) {
				out.writeUnsignedInt(h[i]);
			}
			// unpad, to leave the source untouched.
			src.length = savedLength;
			return out;
		}
		protected function core(x:Array, len:uint):Array {
			return null;
		}
		
		public function toString():String {
			return "sha";
		}
	}
}