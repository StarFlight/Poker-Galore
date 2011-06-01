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

package com.cubeia.poker.lobby
{
	import mx.controls.CheckBox;

	public class LobbyFilterItem extends CheckBox
	{
		[Inspectable]
		public var gameId:int;

		[Inspectable]
		public var lobbyPath:String;
		
		[Inspectable]
		public var clientFilter:Boolean = false;
		
		[Inspectable]
		public var property1:String;
		
		[Inspectable]
		public var property2:String;
		
		[Inspectable]
		public var operator:String;	
		
		[Inspectable]
		public var value:String;	
		
		[Inspectable]
		public var basePath:String;
		
		[Inspectable]
		public var tableType:String;
		
		[Inspectable]
		public var invert:Boolean;
		
		public function LobbyFilterItem()
		{
			selected = true;
			super();
		}
	}
}