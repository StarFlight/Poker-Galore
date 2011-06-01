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

package com.cubeia.util.players
{
	import com.cubeia.firebase.io.protocol.NotifyJoinPacket;
	import com.cubeia.firebase.io.protocol.PlayerInfoPacket;
	import com.cubeia.firebase.model.PlayerInfo;
	import com.cubeia.model.PokerPlayerInfo;
	import com.cubeia.poker.event.PlayerUpdatedEvent;
	import com.cubeia.poker.event.PokerEventDispatcher;
	
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	/**
	 * The Player Registry uses weak references. This means that if no
	 * one else holds a reference to the object in the Dictionary, then 
	 * it might get garbage collected.
	 */
	public class PlayerRegistry
	{
		/** Singleton instance */
		public static var instance:PlayerRegistry = new PlayerRegistry();
		
		private var registry:Dictionary = new Dictionary(true);
		
		[Bindable]
		public  var avatarUrlMap:Dictionary = new Dictionary(true);
		[Bindable]
		public var picMap:Object = new Object();
		//myMap[“name”]=”John”
		//public static var BOT_AVATAR:String = "http://www.iconarchive.com/icons/daniel-loxton/skeptic/48/Alien-Abduction-icon.png";
		//public static var GENERIC_PLAYER_AVATAR:String = "http://www.iconarchive.com/icons/eric-merced/u2/48/Bono-icon.png";
		
		public static var BOT_AVATAR:String = "assets/avatar/bot.png";
		
		public static var GENERIC_PLAYER_AVATAR:String = "assets/avatar/no_avatar.gif";
		
		public function PlayerRegistry()  {
		}
		[Bindable]
		public static var names:Array = [
				"Player" 
				/* "Johnny Ooh",
				"Victorious!",
				"Fretardo",
				"Playboyy",
				"HairyD00d" */
				];
		
		[Bindable]
		public static var pics:Array = [
				"http://profile.ak.fbcdn.net/v229/1617/54/q100000345965848_9310.jpg" 
				/* "http://profile.ak.fbcdn.net/profile6/1359/75/q652186730_5813.jpg",
				"http://profile.ak.fbcdn.net/profile6/1912/24/q683803227_8393.jpg",
				"http://profile.ak.fbcdn.net/v227/1953/92/q100000238333476_2563.jpg",
				"http://www.iconarchive.com/icons/th3-prophetman/gta/48/Playboy-X-icon.png",
				"http://www.iconarchive.com/icons/daniel-loxton/skeptic/48/Yeti-icon.png" */
				];
		
		/*
		 * Get player information. This can be from the local cache or from a
		 * remote service depending on availability.
		 */
		public function getPlayer(playerId:int):PokerPlayerInfo {
			
			
			var player:PokerPlayerInfo = registry[playerId];
			if (player != null) {
				return player;
			} else {
				trace("PlayerRegistry cache miss. Looking up remote player: "+playerId);
				return lookupPlayer(playerId);
			}
		}
		
		/**
		 * Create and add a player object from a seat info packet
		 */
		public function addPlayer(info:PlayerInfoPacket):PokerPlayerInfo {
			
			
			var player:PokerPlayerInfo = registry[info.pid];
			if (player == null) {
				player = new PokerPlayerInfo();
				player.id = info.pid;
				player.name = info.nick;
				
				if (player.name.substr(0, 4) == "Bot_") {
					player.imageUrl = BOT_AVATAR;
				} else {
					player.imageUrl = GENERIC_PLAYER_AVATAR;
					//var index:int = Math.round(Math.random() * (pics.length-1));
					//player.imageUrl = pics[index];
				}
				registry[player.id] = player;
				// Dispatch updated event
				PokerEventDispatcher.dispatch(new PlayerUpdatedEvent(player));
			} 
			
			return player;
		}
		
		/**
		 * Create and add a player object from a seat info packet
		 */
		
		public function addPlayerFromInfo(info:PlayerInfo):PokerPlayerInfo {
			trace("Add player from infor: "+info.pid+", "+info.screenname);
			var player:PokerPlayerInfo = registry[info.pid];
			if (player == null) {
				player = new PokerPlayerInfo();
				player.id = info.pid;
				player.name = info.screenname;
				
				if (player.name.substr(0, 4) == "Bot_") {
					player.imageUrl = BOT_AVATAR;
				} else {
					player.imageUrl = GENERIC_PLAYER_AVATAR;
				}
				
				registry[player.id] = player;
				
				// Dispatch updated event
				PokerEventDispatcher.dispatch(new PlayerUpdatedEvent(player));
			}
			return player;
		}
		
		/**
		 * Create and add a player object from a notify join packet
		 */
		public function addPlayerFromJoin(info:NotifyJoinPacket):PokerPlayerInfo {
			var player:PokerPlayerInfo = registry[info.pid];
			if (player == null) {
				player = new PokerPlayerInfo();
				player.id = info.pid;
				player.name = info.nick;
				
				registry[player.id] = player;
				
				// Dispatch updated event
				PokerEventDispatcher.dispatch(new PlayerUpdatedEvent(player));
				
			}
			
			return player;
		}
		
		/**
		 * Get player information from remote service.
		 */
		public function lookupPlayer(playerId:int):PokerPlayerInfo {
			var player:PokerPlayerInfo =  getRandomPlayer(playerId);
			//trace("Lookup Joined player: "+playerId);
			PokerEventDispatcher.dispatch(new PlayerUpdatedEvent(player));
			return player;
		}
		
		public function getRandomPlayer(playerId:int):PokerPlayerInfo {
			var index:int = Math.round(Math.random() * (pics.length-1));
			var player:PokerPlayerInfo = new PokerPlayerInfo();
			player.id = playerId;
			player.name = names[index];
			// player.imageUrl = pics[index];
			player.imageUrl = GENERIC_PLAYER_AVATAR;
			registry[player.id] = player;
			return player;
		}
		
		/*
		public function getRandomImage():String {
			var index:int = Math.round(Math.random() * (pics.length-1));
			return pics[index];
		}
		*/
	}
}