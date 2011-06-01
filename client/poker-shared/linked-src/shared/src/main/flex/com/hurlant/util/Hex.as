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

package com.hurlant.util
{
	import flash.utils.ByteArray;
	
	public class Hex
	{
		/**
		 * Support straight hex, or colon-laced hex.
		 * (that means 23:03:0e:f0, but *NOT* 23:3:e:f0)
		 * Whitespace characters are ignored.
		 */
		public static function toArray(hex:String):ByteArray {
			hex = hex.replace(/\s|:/gm,'');
			var a:ByteArray = new ByteArray;
			if (hex.length&1==1) hex="0"+hex;
			for (var i:uint=0;i<hex.length;i+=2) {
				a[i/2] = parseInt(hex.substr(i,2),16);
			}
			return a;
		}
		
		public static function fromArray(array:ByteArray, colons:Boolean=false):String {
			var s:String = "";
			for (var i:uint=0;i<array.length;i++) {
				s+=("0"+array[i].toString(16)).substr(-2,2);
				if (colons) {
					if (i<array.length-1) s+=":";
				}
			}
			return s;
		}
		
		/**
		 * 
		 * @param hex
		 * @return a UTF-8 string decoded from hex
		 * 
		 */
		public static function toString(hex:String):String {
			var a:ByteArray = toArray(hex);
			return a.readUTFBytes(a.length);
		}
		
		
		/**
		 * 
		 * @param str
		 * @return a hex string encoded from the UTF-8 string str
		 * 
		 */
		public static function fromString(str:String, colons:Boolean=false):String {
			var a:ByteArray = new ByteArray;
			a.writeUTFBytes(str);
			return fromArray(a, colons);
		}
		
	}
}