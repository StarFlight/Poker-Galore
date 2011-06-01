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
	public class UTCTime implements IAsn1Type
	{
		protected var type:uint;
		protected var len:uint;
		protected var date:Date;
		
		public function UTCTime(type:uint, len:uint)
		{
			this.type = type;
			this.len = len;
		}
		
		public function getLength():uint
		{
			return len;
		}
		
		public function getType():uint
		{
			return type;
		}
		
		public function setUTCTime(str:String):void {
			var year:uint = 2000 + parseInt(str.substr(0, 2)); // Y2.1K unsafe!@!!
			var month:uint = parseInt(str.substr(2,2));
			var day:uint = parseInt(str.substr(4,2));
			var hour:uint = parseInt(str.substr(6,2));
			var minute:uint = parseInt(str.substr(8,2));
			// XXX this could be off by a day. parse the rest. someday.
			date = new Date(year, month, day, hour, minute);
		}
		
		public function toString():String {
			return DER.indent+"UTCTime["+type+"]["+len+"]["+date+"]";
		}
		
	}
}