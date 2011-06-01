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

package com.cubeia.poker.table.model
{
	import mx.controls.Alert;

	/**
	 * This is a seat at the table.
	 * A table can have many seats, a seat can only have one player.
	 * 
	 * NOTE: If you seat a player, you will have to unseat him before
	 * seating a new player to the same seat.
	 */
	public class Seat
	{
		/** Seat id. This is local to the table */
		public var id:int;
		
		/** The id of my table */
		public var tableId:int = -1;
		
		[Bindable]
		public var mySeat:Boolean = false;
		
		[Bindable]
		public var handWinner:Boolean = false;
		
		/**
		 * Don't set this directly, use seatPlayer instead!
		 */
		[Bindable]
		public var player:Player;
		
		[Bindable]
		public var card1X:int;
		
		[Bindable]
		public var card1Y:int;		
		
		[Bindable]
		public var card2X:int;
		
		[Bindable]
		public var card2Y:int;		
		
		public function Seat(id:int) {
			this.id = id;
		}
		
		public function isFree():Boolean {
			return player == null;
		}
		
		public function seatPlayer(player:Player):void {
			if (this.player == null) {
				this.player = player;
				this.player.seatId = id;
			} else if (this.player.id != player.id) {
				throw new Error("You tried to seat a player in an occupied seat. Seated["+this.player.id+"] Supplied["+player.id+"]");	
			}
		}
		
		public function unseatPlayer(player:Player):void {
			if (this.player.id == player.id) {
				player.seatId = -1;
				this.player = null;
			} else {
				throw new Error("You tried to unseat a different player. Seated["+this.player.id+"] Supplied["+player.id+"]");	
			}
		}

	}
}