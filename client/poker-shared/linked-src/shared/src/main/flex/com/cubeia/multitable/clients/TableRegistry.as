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

package com.cubeia.multitable.clients
{
	
	/**
	 * The table registry holds the id:s of all current subscribers to table messages
	 */
	public class TableRegistry
	{
		private var _data:Array;
		
		public function TableRegistry()
		{
			_data = new Array();
		}

		/**
		 * Add a table to the registry
		 */
		public function addTable(tableid:int):void
		{
			for each ( var tid:int in _data ) {
				// don't register twice
				if ( tid == tableid ) {
					return;
				}
			}
			_data.push(tableid);
		}

		/**
		 * Remove a table from the registry
		 */
		public function removeTable(tableid:int):void
		{
			for ( var i:int = 0; i < _data.length; i ++ ) {
				if ( _data[i] == tableid ) {
					_data.splice(i,1);
					return;
				}
			}
			_data.push(tableid);
		}

		/**
		 * Get the full list of tables
		 */
		public function getTableList():Array
		{
			return _data;
		}

	}
}