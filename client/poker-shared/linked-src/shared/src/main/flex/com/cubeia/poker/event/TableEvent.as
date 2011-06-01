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

package com.cubeia.poker.event
{
	public class TableEvent extends PokerEvent
	{
		public static const JOIN_TABLE_REQUEST:String = "table_join_table";
		public static const LEAVE_TABLE_REQUEST:String = "table_leave_table";
		
		public var seatIndex:int = -1;
		
		public function TableEvent(type:String, tableId:int, seatIndex:int = -1)
		{
			super(type, tableId);
			this.seatIndex = seatIndex;
		}

	}
}