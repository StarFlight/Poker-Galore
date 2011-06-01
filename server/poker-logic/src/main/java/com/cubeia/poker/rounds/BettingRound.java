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

package com.cubeia.poker.rounds;

import java.util.List;
import java.util.SortedMap;

import org.apache.log4j.Logger;

import com.cubeia.poker.GameType;
import com.cubeia.poker.action.ActionRequestFactory;
import com.cubeia.poker.action.PokerAction;
import com.cubeia.poker.action.PokerActionType;
import com.cubeia.poker.player.PokerPlayer;
import com.cubeia.poker.player.PokerPlayerStatus;
import com.cubeia.poker.util.PokerUtils;

public class BettingRound implements Round, BettingRoundContext {

	private static final long serialVersionUID = -8666356150075950974L;

	private static transient Logger log = Logger.getLogger(BettingRound.class);

	private final GameType gameType;

	private long highBet = 0;

	private int playerToAct = 0;
	
	private final ActionRequestFactory actionRequestFactory;

	private boolean isFinished = false;

	/** Last highest bet that any raise must match */
	private long lastBetSize = 0;
	
	public BettingRound(GameType gameType, int dealerSeatId) {
		this.gameType = gameType;
		actionRequestFactory = new ActionRequestFactory(new NoLimitBetStrategy(this));
		if (gameType != null && gameType.getState() != null) { // can be null in unit tests
			lastBetSize = gameType.getState().getAnteLevel();
		}
		initBettingRound(dealerSeatId);
	}

	@Override
	public String toString() {
		return "BettingRound, isFinished["+isFinished+"]";
	}
	
	private void initBettingRound(int dealerSeatId) {
		log.debug("Init new betting round - dealer: "+dealerSeatId);
		SortedMap<Integer, PokerPlayer> seatingMap = gameType.getSeatingMap();
		for (PokerPlayer p : seatingMap.values()) {
			if (p.getBetStack() > highBet) {
				highBet = p.getBetStack();
			}
			p.clearActionRequest();
		}

		// Check if we should request actions at all
		PokerPlayer p = getNextPlayerToAct(dealerSeatId);
		if (p == null || allOtherPlayersAreAllIn(p)) {
			// No or only one player can act. We are currently in an all-in show down scenario
			log.debug("Schedule all in timeout from initBettingRound");
			isFinished = true;
			gameType.scheduleRoundTimeout();
		} else {
			requestNextAction(dealerSeatId);
		}
	}

	public void act(PokerAction action) {
		log.debug("Act : "+action);
		PokerPlayer player = gameType.getPlayer(action.getPlayerId());

		verifyValidAction(action, player);
		handleAction(action, player);
		gameType.getServerAdapter().notifyActionPerformed(action);
		// FIXME: Perhaps the new status information could be included in the action performed packet?
		if (player.getBalance() <= 0) {
			gameType.getServerAdapter().notifyPlayerStatusChanged(player.getId(), PokerPlayerStatus.ALLIN, player.getImageUrl(),0);
		}
		
		if (roundFinished()) {
			isFinished = true;
		} else {
			requestNextAction(player.getSeatId());
		}
	}

	private void requestNextAction(int lastSeatId) {
		PokerPlayer p = getNextPlayerToAct(lastSeatId);

		if (p == null) {
			isFinished = true;
			
		} else {
			if (p.getBetStack() < highBet) {
				// gameType.requestAction(p, PokerActionType.FOLD,
				// PokerActionType.CALL, PokerActionType.RAISE);
				p.setActionRequest(actionRequestFactory.createFoldCallRaiseActionRequest(p));
				gameType.requestAction(p.getActionRequest());
			} else {
				p.setActionRequest(actionRequestFactory.createFoldCheckBetActionRequest(p));
				gameType.requestAction(p.getActionRequest());
			}
			playerToAct = p.getId();
		}
	}

	private PokerPlayer getNextPlayerToAct(int lastActedSeatId) {
		PokerPlayer next = null;

		List<PokerPlayer> players = PokerUtils.unwrapList(gameType.getSeatingMap(), lastActedSeatId + 1);
		for (PokerPlayer player : players) {
			if (!player.hasFolded() && !player.hasActed() && !player.isSittingOut() && !player.isAllIn()) {
				next = player;
				break;
			}
		}
		return next;
	}

	private boolean roundFinished() {
		/*
		 * If there's only one non folded player left, the round (and hand) is
		 * finished.
		 */
		if (gameType.countNonFoldedPlayers() < 2) {
			return true;
		}

		for (PokerPlayer p : gameType.getSeatingMap().values()) {
			if (!p.hasFolded() && !p.hasActed() &&!p.isSittingOut()) {
				return false;
			}
		}
		return true;
	}

	private void handleAction(PokerAction action, PokerPlayer player) {
		switch (action.getActionType()) {
		case CALL:
			call(player);
			break;
		case CHECK:
			check(player);
			break;
		case FOLD:
			fold(player);
			break;
		case RAISE:
			setRaiseByAmount(player, action);
			raise(player, action.getBetAmount());
			break;
		case BET:
			bet(player, action.getBetAmount());
			break;
		default:
			throw new IllegalArgumentException();
		}
		player.setHasActed(true);
	}

	
	private void verifyValidAction(PokerAction action, PokerPlayer player) {
		if (playerToAct != action.getPlayerId()) {
			throw new IllegalArgumentException("Expected " + playerToAct + " to act, but got action from:" + player.getId());
		}

		if (!player.getActionRequest().matches(action)) {
			throw new IllegalArgumentException("Player " + player.getId() + " tried to act " + action.getActionType() + " but his options were "
					+ player.getActionRequest().getOptions());
		}
	}

	private void raise(PokerPlayer player, long amount) {
		if (amount <= highBet) {
			throw new IllegalArgumentException("PokerPlayer["+player.getId()+"] incorrect raise amount. Highbet["+highBet+"] amount["+amount+"]. " +
					"Amounts must be larger than current highest bet");
		}
		
		/** Check if player went all in with a below minimum raise */
		if (! (amount < 2*lastBetSize && player.isAllIn())) {
			lastBetSize = amount-highBet;
		} else {
			log.debug("Player["+player.getId()+"] made a below min raise but is allin.");
		}
		
		highBet = amount;
		player.addBet(highBet - player.getBetStack());
		resetHasActed();
	}
	
	private void setRaiseByAmount(PokerPlayer player, PokerAction action) {
		action.setRaiseAmount(action.getBetAmount() - highBet);
	}


	private void bet(PokerPlayer player, long amount) {
		lastBetSize = amount;
		highBet = highBet + amount;
		player.addBet(highBet - player.getBetStack());
		resetHasActed();
	}

	private void resetHasActed() {
		for (PokerPlayer p : gameType.getSeatingMap().values()) {
			if (!p.hasFolded()) {
				p.setHasActed(false);
			}
		}
	}

	private void fold(PokerPlayer player) {
		player.setHasFolded(true);
	}

	private void check(PokerPlayer player) {
		// Nothing to do.
	}

	private void call(PokerPlayer player) {
		player.addBet(getAmountToCall(player));
	}

	private long getAmountToCall(PokerPlayer player) {
		return Math.min(highBet - player.getBetStack(), player.getBalance());
	}

	public void timeout() {
		PokerPlayer player = gameType.getPlayer(playerToAct);
		if (player == null) {
			// throw new IllegalStateException("Expected " + playerToAct + " to act, but that player can not be found at the table!");
			log.debug("Expected " + playerToAct + " to act, but that player can not be found at the table! I will assume everyone is all in");
			return; // Are we allin?
		}
		if (player.getActionRequest().isOptionEnabled(PokerActionType.CHECK)) {
			act(new PokerAction(playerToAct, PokerActionType.CHECK, true));
		} else {
			act(new PokerAction(playerToAct, PokerActionType.FOLD, true));
		}
	}

	public String getStateDescription() {
		return "playerToAct=" + playerToAct + " roundFinished=" + roundFinished();
	}

	public boolean isFinished() {
		return isFinished;
	}

	public void visit(RoundVisitor visitor) {
		visitor.visit(this);
	}

	public boolean allOtherPlayersAreAllIn(PokerPlayer thisPlayer) {
		for (PokerPlayer player : gameType.getSeatingMap().values()) {
			if (!player.isSittingOut() && !player.hasFolded() && !player.equals(thisPlayer) && !player.isAllIn()) {
				return false;
			}
		}
		return true;
	}

	public long getHighestBet() {
		return highBet;
	}

	public long getMinBet() {
		return gameType.getAnteLevel();
	}

	public long getSizeOfLastBetOrRaise() {
		return lastBetSize ;
	}
}
