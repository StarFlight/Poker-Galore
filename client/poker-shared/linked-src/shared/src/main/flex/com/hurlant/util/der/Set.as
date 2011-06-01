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
	public dynamic class Set extends Sequence implements IAsn1Type
	{
		public function Set(type:uint, length:uint) {
			super(type, length);
		}


		public override function toString():String {
			var s:String = DER.indent;
			DER.indent += "    ";
			var t:String = join("\n");
			DER.indent= s;
			return DER.indent+"Set["+type+"]["+len+"][\n"+t+"\n"+s+"]";
		}
		
	}
}