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

package com.cubeia.poker.table.handler
{
	import com.cubeia.firebase.events.GamePacketEvent;
	import com.cubeia.firebase.events.PacketEvent;
	import com.cubeia.firebase.io.ProtocolObject;
	import com.cubeia.firebase.io.StyxSerializer;
	import com.cubeia.firebase.io.protocol.JoinResponsePacket;
	import com.cubeia.firebase.io.protocol.JoinResponseStatusEnum;
	import com.cubeia.firebase.io.protocol.LeaveResponsePacket;
	import com.cubeia.firebase.io.protocol.NotifyJoinPacket;
	import com.cubeia.firebase.io.protocol.NotifyLeavePacket;
	import com.cubeia.firebase.io.protocol.SeatInfoPacket;
	import com.cubeia.firebase.io.protocol.TableChatPacket;
	import com.cubeia.firebase.model.PlayerInfo;
	import com.cubeia.games.poker.io.protocol.ActionTypeEnum;
	import com.cubeia.games.poker.io.protocol.BestHand;
	import com.cubeia.games.poker.io.protocol.DealHiddenCards;
	import com.cubeia.games.poker.io.protocol.DealPrivateCards;
	import com.cubeia.games.poker.io.protocol.DealPublicCards;
	import com.cubeia.games.poker.io.protocol.DealerButton;
	import com.cubeia.games.poker.io.protocol.ExposePrivateCards;
	import com.cubeia.games.poker.io.protocol.GameCard;
	import com.cubeia.games.poker.io.protocol.HandEnd;
	import com.cubeia.games.poker.io.protocol.PerformAction;
	import com.cubeia.games.poker.io.protocol.PlayerBalance;
	import com.cubeia.games.poker.io.protocol.PlayerPokerStatus;
	import com.cubeia.games.poker.io.protocol.PlayerTableStatusEnum;
	import com.cubeia.games.poker.io.protocol.Pot;
	import com.cubeia.games.poker.io.protocol.ProtocolObjectFactory;
	import com.cubeia.games.poker.io.protocol.RequestAction;
	import com.cubeia.games.poker.io.protocol.StartHandHistory;
	import com.cubeia.games.poker.io.protocol.StartNewHand;
	import com.cubeia.games.poker.io.protocol.StopHandHistory;
	import com.cubeia.model.PokerPlayerInfo;
	import com.cubeia.multitable.events.GamePacketDataEvent;
	import com.cubeia.poker.event.PokerEventDispatcher;
	import com.cubeia.poker.event.PokerLobbyEvent;
	import com.cubeia.poker.table.cards.VectCardFactory;
	import com.cubeia.poker.table.cards.WrappedGameCard;
	import com.cubeia.poker.table.model.BetType;
	import com.cubeia.poker.table.model.Player;
	import com.cubeia.poker.table.model.Table;
	import com.cubeia.poker.table.util.ActionHelper;
	import com.cubeia.util.players.PlayerRegistry;
	
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import mx.controls.Alert;
	
	/**
	 * The GamePacketHandler is responsible for applying incoming game packets
	 * to the game state and the Table.
	 */
	public class GamePacketHandler
	{
		/**
		 * serialization/deserialization of poker specific packets
		 */
		public static var protocolObjectFactory:ProtocolObjectFactory = new ProtocolObjectFactory();
		public static var styxSerializer:StyxSerializer = new StyxSerializer(protocolObjectFactory);
		
		
		private var table:Table;
		private var imageUrl:String;
		
		public function GamePacketHandler(table:Table, pi:PlayerInfo)
		{
			this.table = table;
			
		}

		public function onFirebasePacket(event:PacketEvent):void {
			var protocolObject:ProtocolObject = event.getObject();
			
			if ( protocolObject.classId() == SeatInfoPacket.CLASSID ) {
				var sip:SeatInfoPacket = SeatInfoPacket(protocolObject);
				
				// let the server know to update avatar
				var playerPokerStatus:PlayerPokerStatus = new PlayerPokerStatus();
				playerPokerStatus.player = sip.player.pid;
				playerPokerStatus.imageUrl = "unused";
				playerPokerStatus.status = 0;
				PokerTable.messageBusClient.sendGamePacket(sip.player.pid, table.id, GamePacketHandler.styxSerializer.pack(playerPokerStatus));
				
				PlayerRegistry.instance.addPlayer(sip.player);
				seatPlayer(sip.player.pid, sip.seat);
				
			} else if (protocolObject.classId() == NotifyJoinPacket.CLASSID) {
				var notifyJoinPacket:NotifyJoinPacket = NotifyJoinPacket(protocolObject);
				
				var playerPS:PlayerPokerStatus = new PlayerPokerStatus();
				playerPS.player = notifyJoinPacket.pid;
				playerPS.imageUrl = "unused";
				playerPS.status = 0;
				PokerTable.messageBusClient.sendGamePacket(notifyJoinPacket.pid, table.id, GamePacketHandler.styxSerializer.pack(playerPS));
				
				PlayerRegistry.instance.addPlayerFromJoin(notifyJoinPacket);
				seatPlayer(notifyJoinPacket.pid, notifyJoinPacket.seat);
				
			} else if (protocolObject.classId() == NotifyLeavePacket.CLASSID) {
				var notifyLeavePacket:NotifyLeavePacket = NotifyLeavePacket(protocolObject);
				unseatPlayer(notifyLeavePacket.pid);
				
			} else if (protocolObject.classId() == JoinResponsePacket.CLASSID) {
				var joinResponsePacket:JoinResponsePacket = JoinResponsePacket(protocolObject);
				
				if (joinResponsePacket.status == JoinResponseStatusEnum.OK) {
					seatPlayer(table.myPlayerId, joinResponsePacket.seat);
				}
			}  else if (protocolObject.classId() == TableChatPacket.CLASSID ) {
				var player:Player = table.getPlayer(TableChatPacket(protocolObject).pid);
				if ( player != null ) {
					table.chatOutput += player.screenname + ": " + TableChatPacket(protocolObject).message + "\n";
				}
				
			} else if ( protocolObject.classId() == LeaveResponsePacket.CLASSID ) {
				if (ExternalInterface.available) { 
					if (PokerTable.qtDemo) {
						ExternalInterface.call("actionHandler.closeWindow", "Cubeia Poker Table " + table.id + "("+table.myPlayerId+")");
					} else {
						ExternalInterface.call("window.close");
					}
				}
				PokerTable.messageBusClient.stop();
			}
		}

		private function seatPlayer(playerId:int, seat:int):void {
			var playerInfo:PokerPlayerInfo = PlayerRegistry.instance.getPlayer(playerId);
			
			var player:Player = Player.fromPlayerInfo(playerInfo);
			if (player == null) {
				//trace("**** WARNING *** player info is null " + playerId);
			} else {
				table.seatPlayer(player, seat);
			}
		}


		
		private function unseatPlayer(playerId:int):void {
			trace("Unseat player: "+playerId);
			var playerInfo:PokerPlayerInfo = PlayerRegistry.instance.getPlayer(playerId);
			var player:Player = Player.fromPlayerInfo(playerInfo);
			table.unseatPlayer(player);
		}
		
		
		/**
		 * Handle poker game packets
		 */
		public function onGamePacket(event:GamePacketDataEvent):void {
			var protocolObject:ProtocolObject = styxSerializer.unpack(event.packetData);
			var date:Date = new Date();
			// trace(date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds() + "." + date.getMilliseconds() + " - Received poker game packet [" + protocolObject.toString() + "]");
			switch ( protocolObject.classId() ) {
				case StartHandHistory.CLASSID :
					table.handHistoryMode = true;
					break;
				case StopHandHistory.CLASSID :
					table.handHistoryMode = false;
					break;
				case StartNewHand.CLASSID :
					trace("New hand started");
					//TODO: enable this call and remove it from DealerButton once this packet is sent from the server
					//table.clearCommunityCards();
					break;
				case DealPublicCards.CLASSID :
					dealPublicCards(DealPublicCards(protocolObject).cards);
					break;
				case DealerButton.CLASSID :
					// TODO: see StartNewHand
					trace("Dealer button moved");
					table.clearCommunityCards();
					handleStartNewHand();
					//////////////////////////////// 
					var dealerButton:DealerButton = DealerButton(protocolObject);
					table.dealerButtonPosition = dealerButton.seat;
					break;
				case DealHiddenCards.CLASSID :
					dealHiddenCards(DealHiddenCards(protocolObject).player, DealHiddenCards(protocolObject).count);
					break;
				case DealPrivateCards.CLASSID :
					dealPrivateCards(DealPrivateCards(protocolObject).cards);
					break;
				case PlayerBalance.CLASSID :
					trace("Player balance updated. Player "+PlayerBalance(protocolObject).player+" -> "+PlayerBalance(protocolObject).balance);
					table.getPlayer(PlayerBalance(protocolObject).player).balance = PlayerBalance(protocolObject).balance;
					break;
				case RequestAction.CLASSID :
					table.getPlayer(RequestAction(protocolObject).player).status = Player.STATUS_WAITING_TO_ACT;
					// update player timeToAct (triggers timeout bar)
					table.getPlayer(RequestAction(protocolObject).player).timeToAct = RequestAction(protocolObject).timeToAct; 
					if ( table.myPlayerId == RequestAction(protocolObject).player ) {
						table.betControlsEnabled = true;
						table.requestAction = RequestAction(protocolObject);
					}
					break;
				case PerformAction.CLASSID :
					handlePerformAction(PerformAction(protocolObject));
					break;
				case HandEnd.CLASSID :
					var handEnd:HandEnd = HandEnd(protocolObject);
					handleHandEnd(handEnd);
					break;
				case ExposePrivateCards.CLASSID :
					handleExposePrivateCards(ExposePrivateCards(protocolObject));
					break;
				case Pot.CLASSID :
					table.mainPot = (Pot(protocolObject).amount);
					break;
				case PlayerPokerStatus.CLASSID :
					handlePlayerStatusChanged(PlayerPokerStatus(protocolObject));
					break;
				default :
					trace("Received unhandled poker game packet [" + protocolObject.toString() + "]");
			}
		}
		
		private function handleStartNewHand():void {
			for each (var pid:int in table.getAllPlayerIds()) {
				var player:Player = table.getPlayer(pid);
				player.status = Player.STATUS_ACTED;
				player.betStack = 0;
				player.removePocketCards();
				player.removeBigPocketCards();
			}
			table.mainPot = 0; 
		}

		private function handlePerformAction(action:PerformAction):void {
			var player:Player = table.getPlayer(action.player);
			player.status = Player.STATUS_ACTED;
			player.betStack = action.stackAmount;
			player.balance = action.balance;
			
			// set player timeToAct to zero (stops timeout bar)
			player.timeToAct = 0;
			table.chatOutput += ActionHelper.getActionString(table, action) + "\n"; 
			performPlayerAction(action);
			
			if ( table.myPlayerId == action.player ) {
				table.betControlsEnabled = false;
				table.requestAction = new RequestAction();
			}
		}
		
		private function handleHandEnd(handEnd:HandEnd):void {
			for each ( var bestHand:BestHand in handEnd.hands ) {
				var playerName:String = table.getPlayer(bestHand.player).screenname;
				table.chatOutput += playerName + " shows " + bestHand.name + "\n";
				trace(playerName + " shows " + bestHand.name + "\n");
			}
		}
		
		private function handleExposePrivateCards(exposePrivateCards:ExposePrivateCards):void {
			setPlayerCards(exposePrivateCards.player, exposePrivateCards.cards);
		}
		
		private function dealPrivateCards(cards:Array):void {
			setPlayerCards(table.myPlayerId, cards);
		}
		
		private function setPlayerCards(playerId:int, cards:Array):void {
			var player:Player = table.getPlayer(playerId);
			if (player != null) {
				for ( var i:int = 0; i < cards.length; i ++ ) {
					player.pocketCards.setItemAt(new WrappedGameCard(GameCard(cards[i])), i);
					player.bigPocketCards.setItemAt(new WrappedGameCard(GameCard(cards[i])), i);
				}
			}
		}
		
		private function dealPublicCards(cards:Array):void {
			for ( var i:int = 0; i < cards.length; i ++ ) {
				table.addCommunityCard(cards[i] as GameCard);
			}
		}
		
		private function dealHiddenCards(playerId:int, count:int):void {
			var player:Player = table.getPlayer(playerId);
			for ( var i:int = 0; i < count; i ++ ) {
				player.pocketCards.setItemAt(new WrappedGameCard(null, true), i);
				player.bigPocketCards.setItemAt(new WrappedGameCard(null, true), i);
			}

		}
		
		private function performPlayerAction(action:PerformAction):void {
			var player:Player = table.getPlayer(action.player);
			switch ( action.action.type ) 
			{
				case ActionTypeEnum.FOLD :
					player.removePocketCards();
					player.removeBigPocketCards();
					player.status = Player.STATUS_SITOUT;
					break;
				default:
					player.status = Player.STATUS_ACTED;
					break;
			}
		}
		
		private function handlePlayerStatusChanged(status:PlayerPokerStatus):void {
			trace("Player status changed: Player["+status.player+"] -> Status["+status.status+"]"+"] -> ImageUrl["+status.imageUrl+"]");
			var player:Player = table.getPlayer(status.player);
			
//			trace("image url " + status.imageUrl + " for player " + status.player);
			player.imageUrl = status.imageUrl;
			if (status.winnerFl == 1) {
				//trace("handlePlayerStatusChanged got winnerFl msg for #" + player.id);
			}
			player.winnerFl = status.winnerFl;
			switch (status.status) {
				case PlayerTableStatusEnum.SITOUT :
					player.status = Player.STATUS_SITOUT;
					break;
				case PlayerTableStatusEnum.ALLIN :
					player.status = Player.STATUS_ALLIN;
					break;
			}
			table.notifyWinner(player.id,status.winnerFl);
		}
	
	}
}