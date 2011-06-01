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
	import com.cubeia.games.poker.io.protocol.GameCard;
	import com.cubeia.games.poker.io.protocol.RequestAction;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	
	public class Table
	{
		public var id:int;
		
		[Bindable]
		public var myPlayerId:int;

		[Bindable]
		public var mySeat:Seat;
		
		
		/** Type of card game */
		public var gameType:String = GameType.TEXAS_HOLDEM;
		
		/** Type of betting */
		public var bettingType:String = BetType.NO_LIMIT;
		
		/** All players at the table */
		private var players:Dictionary = new Dictionary();
		
		
		[Bindable]
		/** hand history mode */
		public var handHistoryMode:Boolean = false;
		
		[Bindable]
		public var seats:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var communityCards:ArrayCollection = new ArrayCollection(new Array(5));
		
		[Bindable]
		public var dealerButtonPosition:int = -1;
		
		[Bindable]
		public var mainPot:Number;
		
		[Bindable]
		public var seated:Boolean = false;
		
		[Bindable]
		/** request action */
		public var requestAction:RequestAction;

		[Bindable]
		/** max amount to bet */
		public var maxBetAmount:Number;
		
		[Bindable]
		/** enable/disable bet controls */
		public var betControlsEnabled:Boolean = false;

		// Maybe a list is better suited for this?
		[Bindable]
		public var chatOutput:String = "";
		
		/**
		 * Table constructor. You must provide the number of seats
		 * this table contains.
		 */
		public function Table(tableId:int, seatCount:int){
			this.id = tableId;
			seats = new ArrayCollection(new Array(seatCount));
			var i:int;
			for (i = 0; i < seatCount; i++)
			{
			    var seat:Seat = new Seat(i);
			    seat.tableId = id;
			    seats[i] = seat;
			}
			clearCommunityCards();
		}
		
		
		public function clearCommunityCards():void {
			for ( var i:int = 0; i < communityCards.length; i ++ ) {
				communityCards.setItemAt(null, i);
			}
			
		}
		
		public function addCommunityCard(gameCard:GameCard):void {
			// search for first empty location and place the card there
			for ( var i:int = 0; i < communityCards.length; i ++ ) {
				var card:GameCard = GameCard(communityCards.getItemAt(i));
				if ( card == null ) {
					communityCards.setItemAt(gameCard,i);
					return;
				}
			}
			
		}
		
		public function getSeat(seatId:int):Seat {
			return seats.getItemAt(seatId) as Seat;
		}
		
		public function getNumberOfSeats():int {
			return seats.length;
		}
		
		/** Returns the seat id/index for the given player id. -1 if not found */
		public function getPlayerSeat(playerId:int):int {
			var seatId:int = -1;
			for each (var seat:Seat in seats) {
				if (seat.player != null && seat.player.id == playerId) {
					seatId = seat.id;
					break;
				}
			}
			return seatId;
		}
		/* reset winner flag */		
		public function notifyWinner(playerId:int, winnerFl:int):int {
			var seatId:int = -1;
			for each (var seat:Seat in seats) {
				if (seat.player != null && seat.player.id == playerId) {
					seatId = seat.id;
					if (winnerFl == 1) {
						(seats[seatId] as Seat).handWinner = true;
					} else {
						(seats[seatId] as Seat).handWinner = false;
					}
					break;
				}
			}
			return seatId;
		}
		
		
		// ---------------------------------------------
		//
		//    PLAYER METHODS
		//
		// --------------------------------------------- 
		
		/**
		 * Get a player by player id. Will return null
		 * if the player was not found.
		 */
		public function getPlayer(playerId:int):Player {
			var player:Player = players[playerId];
			if (!player) {
				trace("Player["+playerId+"] not found at Table["+id+"]. PlayerList: "+players);
			}
			return player;
		}
		
		public function getNumberOfPlayers():uint {
		    return getAllPlayerIds().length;
		}

		public function getAllPlayerIds():Array {
			var a:Array = new Array();
			for (var key:Object in players)
				a.push(key);
			return a;
		}
		
		public function seatPlayer(player:Player, seatId:int):void {
			//Alert.show("Add player " + player.id + " to players collection ");
			players[player.id] = player;
			// temporarily patch to add player in registry for avatar
			if (seatId != -1) {
				(seats[seatId] as Seat).seatPlayer(player);
				if (player.id == myPlayerId) {
				//	Alert.show("Set seat as taken " + seatId);
					(seats[seatId] as Seat).mySeat = true;
					mySeat = (seats[seatId] as Seat);
					seated = true;
				}
			}
		}
		
		public function unseatPlayer(player:Player):void {
			delete players[player.id];
			var seatId:int = getPlayerSeat(player.id); 
			(seats[seatId] as Seat).unseatPlayer(player);
		}
		
		
		// ---------------------------------------------
		//
		//    END OF PLAYER METHODS
		//
		// --------------------------------------------- 
	}
}