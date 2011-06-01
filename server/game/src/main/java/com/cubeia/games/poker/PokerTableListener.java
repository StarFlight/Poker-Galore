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

package com.cubeia.games.poker;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.LinkedList;
import java.util.List;

import org.apache.log4j.Logger;

import com.cubeia.backoffice.accounting.api.Money;
import com.cubeia.firebase.api.action.GameAction;
import com.cubeia.firebase.api.action.GameDataAction;
import com.cubeia.firebase.api.action.UnseatPlayersMttAction.Reason;
import com.cubeia.firebase.api.game.player.GenericPlayer;
import com.cubeia.firebase.api.game.player.PlayerStatus;
import com.cubeia.firebase.api.game.table.Table;
import com.cubeia.firebase.api.game.table.TournamentTableListener;
import com.cubeia.firebase.api.service.ServiceRouter;
import com.cubeia.firebase.guice.inject.Service;
import com.cubeia.games.poker.adapter.ActionTransformer;
import com.cubeia.games.poker.cache.ActionCache;
import com.cubeia.games.poker.io.protocol.StartHandHistory;
import com.cubeia.games.poker.io.protocol.StopHandHistory;
import com.cubeia.games.poker.model.PokerPlayerImpl;
import com.cubeia.games.poker.util.ProtocolFactory;
import com.cubeia.games.poker.util.WalletAmountConverter;
import com.cubeia.network.wallet.firebase.api.WalletServiceContract;
import com.cubeia.poker.PokerState;
import com.cubeia.poker.player.PokerPlayer;
import com.board.games.service.PokerBoardServiceContract;
import com.google.inject.Inject;

public class PokerTableListener implements TournamentTableListener {

	private static transient Logger log = Logger
			.getLogger(PokerTableListener.class);
	private ServiceRouter router;
	
	private static int counter = 0;
	@Inject
	ActionCache actionCache;

	@Service
	WalletServiceContract walletService;

	@Inject
	StateInjector stateInjector;

	@Inject
	PokerState state;

	private WalletAmountConverter amountConverter = new WalletAmountConverter();

	
	/**
	 * A Player has joined our table. =)
	 * 
	 */
	public void playerJoined(Table table, GenericPlayer player) {
		stateInjector.injectAdapter(table);
		log.debug("Player[" + player.getPlayerId() + ":" + player.getName()
				+ "] joined Table[" + table.getId() + ":"
				+ table.getMetaData().getName() + "]");
		if (state.isPlayerSeated(player.getPlayerId())) {
			log.debug("sitInPlayer #" + player.getPlayerId());
			sitInPlayer(table, player);
			log.debug("Broadcast avatar with player seated");
			state.notifyAvatarChange(player.getPlayerId());
		} else {
			addPlayer(table, player, false);
			// broadcast avatar
			log.debug("Broadcast avatar joined player # "
					+ player.getPlayerId());
			state.notifyAvatarChange(player.getPlayerId());
		}
	}

	/**
	 * A Player has left our table. =(
	 * 
	 */
	public void playerLeft(Table table, int playerId) {
		log.debug("RMV Player left: " + playerId);
		log.info("RMV Player left: " + playerId);
		stateInjector.injectAdapter(table);
		removePlayer(table, playerId, false);
	}

	public void tournamentPlayerJoined(Table table, GenericPlayer player,
			Serializable balance) {
		stateInjector.injectAdapter(table);
		PokerPlayer pokerPlayer = addPlayer(table, player, true);
		pokerPlayer.addChips((Long) balance);
	}

	public void tournamentPlayerRejoined(Table table, GenericPlayer player) {
		// log.debug("Tournament player rejoined: "+player);
		// addPlayer(table, player);
	}

	public void tournamentPlayerRemoved(Table table, int playerId, Reason reason) {
		stateInjector.injectAdapter(table);
		removePlayer(table, playerId, true);
	}

	/**
	 * Send current game state to the watching player
	 */
	public void watcherJoined(Table table, int playerId) {
		stateInjector.injectAdapter(table);
		sendGameState(table, playerId);
		log.debug("Inside watcherJoined PlayerID -> notif avatar changed"
				+ playerId);
		state.notifyAvatarChange(playerId);
	}

	public void playerStatusChanged(Table table, int playerId,
			PlayerStatus status) {
		log.debug("Inside playerStatusChanged PlayerID -> notif avatar changed"
				+ playerId);
		state.notifyAvatarChange(playerId);
	}

	public void seatReserved(Table table, GenericPlayer player) {
	}

	public void watcherLeft(Table table, int playerId) {
	}

	private void sendGameState(Table table, int playerId) {
		List<GameAction> actions = new LinkedList<GameAction>();
		actions.add(ProtocolFactory.createGameAction(new StartHandHistory(),
				playerId, table.getId()));
		actions.addAll(actionCache.getActions(table.getId()));
		actions.add(ProtocolFactory.createGameAction(new StopHandHistory(),
				playerId, table.getId()));
		table.getNotifier().notifyPlayer(playerId, actions);
	}

	private void sendTableBalance(PokerState state, Table table, int playerId) {
		int balance = state.getBalance(playerId);
		GameDataAction balanceAction = ActionTransformer
				.createPlayerBalanceAction(balance, playerId, table.getId());
		table.getNotifier().notifyAllPlayers(balanceAction);
	}

	private void sitInPlayer(Table table, GenericPlayer player) {
		sendGameState(table, player.getPlayerId());
		log.debug("Inside sitInPlayer --> ******* notify avatar");
		state.notifyAvatarChange(player.getPlayerId());
		state.playerIsSittingIn(player.getPlayerId());

	}

	
    public String getImageUrl(int userId) {
    	   log.debug("Inside init of getImageUrl ***NEW USING boardService");
    	   log.debug("Calling boardServiceContract");
    	   PokerBoardServiceContract boardServiceContract = PokerGame.getPokerBoardServiceContract();
    	   String imageUrl = "";
    	   if (boardServiceContract!=null) {
    		   try {
    			   com.board.games.model.PlayerProfile playerProfile = boardServiceContract.getUserProfile(userId);
    			   log.debug("Retrieving avata location " + playerProfile.getAvatar_location());
					imageUrl= playerProfile.getAvatar_location(); 
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					log.error(e.toString());
				}
    	   } else {
    		   log.error("boardServiceContract is null");
    	   }
    	   log.debug("ImageUrl from service " + imageUrl);
    	   return imageUrl;

    }
    public long getPlayerCash(int userId)
    {
    	   log.debug("Inside init of getPlayerCash ***NEW USING boardService");
    	   log.debug("Calling boardServiceContract");
    	   PokerBoardServiceContract boardServiceContract = PokerGame.getPokerBoardServiceContract();
    	   long moneyAmount = 0;
    	   if (boardServiceContract!=null) {
    		   try {
				moneyAmount= boardServiceContract.getUserBalance(userId);
				if (moneyAmount == -1) {
					// balance not added , create default balance
					boardServiceContract.insertUserBalance(userId);
					moneyAmount= boardServiceContract.getUserBalance(userId);
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    	   } else {
    		   log.error("boardServiceContract is null");
    	   }
    	   log.debug("getPlayerCash from service " + moneyAmount);
    	   return moneyAmount;    
    	   
    }
	
	private PokerPlayer addPlayer(Table table, GenericPlayer player,
			boolean tournamentPlayer) {
		sendGameState(table, player.getPlayerId());
		log.debug("**** Inside addPlayer ***");
		if (counter>9)
			counter = 0;
		String avatarUrl = getImageUrl(player.getPlayerId());
		PokerPlayer pokerPlayer = new PokerPlayerImpl(player,avatarUrl);
		counter++;
		state.addPlayer(pokerPlayer);

		if (!tournamentPlayer) {
			log.debug("Start wallet session for player: " + player);
			Long sessionId = startWalletSession(table, player);
			((PokerPlayerImpl) pokerPlayer).setSessionId(sessionId);

			// TODO: handle wallet error!
			
			if (sessionId != null) {
				// TODO: amount is hardcoded, user should give the amount
				log.debug("session is valid, amount hardcoded");
				state.notifyAvatarChange(player.getPlayerId());
				// Retrieve player's cash 
				long amount = getPlayerCash(player.getPlayerId());
				log.debug("amount retrieved " + amount);
				withdraw((int)amount, sessionId, table.getId());
				state.addChips(player.getPlayerId(), amount);
			}
		}

		sendTableBalance(state, table, player.getPlayerId());
		return pokerPlayer;
	}

	private Long startWalletSession(Table table, GenericPlayer player) {
		Long sessionId = walletService.startSession(PokerGame.CURRENCY_CODE,
				PokerGame.LICENSEE_ID, player.getPlayerId(), table.getId(),
				PokerGame.POKER_GAME_ID, player.getName());

		if (log.isDebugEnabled()) {
			log.debug("Created session account: sessionId[" + sessionId
					+ "], tableId[" + table.getId() + "], playerId["
					+ player.getPlayerId() + ":" + player.getName() + "]");
		}

		if (sessionId == null) {
			log.error("error opening wallet session. Table[" + table.getId()
					+ "] player[" + player + "]");
			return null;
		} else {
			return sessionId;
		}
	}

	private boolean endWalletSession(Table table, GenericPlayer player,
			long sessionId) {
		if (log.isDebugEnabled()) {
			log.debug("Close player table session account: sessionId["
					+ sessionId + "], tableId[" + table.getId() + "]");
		}
		walletService.endSession(sessionId);
		return true;
	}

	private void withdraw(int amount, long sessionId, int tableId) {
		if (log.isDebugEnabled()) {
			log.debug("Withdraw from player, sessionId[" + sessionId
					+ "], tableId[" + tableId + "], amount[" + amount + "]");
		}
		walletService.withdraw(convertToMoney(amount), PokerGame.LICENSEE_ID,
				sessionId, "To poker table[" + tableId + "]");
	}

	private void deposit(int amount, long sessionId, int tableId) {
		if (log.isDebugEnabled()) {
			log.debug("Deposit back to player, sessionId[" + sessionId
					+ "], tableId[" + tableId + "], amount[" + amount + "]");
		}
		walletService.deposit(convertToMoney(amount), PokerGame.LICENSEE_ID,
				sessionId, "From poker table[" + tableId + "]");
	}

	private Money convertToMoney(int amount) {
		BigDecimal walletAmount = amountConverter.convertToWalletAmount(amount);
		Money money = new Money(PokerGame.CURRENCY_CODE,
				PokerGame.CURRENCY_FRACTIONAL_DIGITS, walletAmount);
		return money;
	}

	private void removePlayer(Table table, int playerId,
			boolean tournamentPlayer) {
		if (!tournamentPlayer) {
			PokerPlayerImpl pokerPlayer = (PokerPlayerImpl) state
					.getPokerPlayer(playerId);
			if (pokerPlayer != null) { // Check if player was removed already
				handleSessionEnd(table, playerId, pokerPlayer);
			}
		}

		state.removePlayer(playerId);
	}

	private void handleSessionEnd(Table table, int playerId,
			PokerPlayerImpl pokerPlayer) {
		Long sessionId = pokerPlayer.getSessionId();

		log.debug("Handle session end for player[" + playerId + "], sessionid["
				+ sessionId + "]");
		if (sessionId != null) {
			long balance = pokerPlayer.getBalance();
			deposit((int) balance, sessionId, table.getId());
			// TODO: Add check that depositedAmount-balance is 0
			pokerPlayer.clearBalance();

			GenericPlayer player = table.getPlayerSet().getPlayer(playerId);
			boolean endSessionOk = endWalletSession(table, player, sessionId);
			if (endSessionOk) {
				pokerPlayer.setSessionId(null);
			} else {
				// TODO: how do we handle this???
				log.error("error ending wallet session");
			}
		}
	}
}
