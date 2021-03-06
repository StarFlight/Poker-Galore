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

package com.hurlant.util.der
{
	import flash.utils.ByteArray;
	import com.hurlant.util.Hex;

	public class ByteString extends ByteArray implements IAsn1Type
	{
		private var type:uint;
		private var len:uint;
		
		public function ByteString(type:uint, length:uint) {
			this.type = type;
			this.len = length;
		}
		
		public function getLength():uint
		{
			return len;
		}
		
		public function getType():uint
		{
			return type;
		}
		
		override public function toString():String {
			return DER.indent+"ByteString["+type+"]["+len+"]["+Hex.fromArray(this)+"]";
		}
		
	}
}