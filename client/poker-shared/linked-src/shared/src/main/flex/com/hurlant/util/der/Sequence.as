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
	public dynamic class Sequence extends Array implements IAsn1Type
	{
		protected var type:uint;
		protected var len:uint;
		
		public function Sequence(type:uint, length:uint) {
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
		
		public function toString():String {
			var s:String = DER.indent;
			DER.indent += "    ";
			var t:String = join("\n");
			DER.indent= s;
			return DER.indent+"Sequence["+type+"]["+len+"][\n"+t+"\n"+s+"]";
		}
		
		/////////
		
		public function findAttributeValue(oid:String):IAsn1Type {
			for each (var set:* in this) {
				if (set is Set) {
					var child:* = set[0];
					if (child is Sequence) {
						var tmp:* = child[0];
						if (tmp is ObjectIdentifier) {
							var id:ObjectIdentifier = tmp as ObjectIdentifier;
							if (id.toString()==oid) {
								return child[1] as IAsn1Type;
							}
						}
					}
				}
			}
			return null;
		}
		
	}
}