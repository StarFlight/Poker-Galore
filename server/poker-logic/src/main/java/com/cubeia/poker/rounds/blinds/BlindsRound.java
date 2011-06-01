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

package com.cubeia.poker.rounds.blinds;

import java.util.Collection;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;

import org.apache.log4j.Logger;

import com.cubeia.poker.GameType;
import com.cubeia.poker.action.PokerAction;
import com.cubeia.poker.action.PokerActionType;
import com.cubeia.poker.action.PossibleAction;
import com.cubeia.poker.player.PokerPlayer;
import com.cubeia.poker.player.SitOutStatus;
import com.cubeia.poker.rounds.Round;
import com.cubeia.poker.rounds.RoundVisitor;
import com.cubeia.poker.util.PokerUtils;

public class BlindsRound implements Round {

	private static final long serialVersionUID = -6452364533249060511L;

	private static transient Logger log = Logger.getLogger(BlindsRound.class);

	// TODO: Remove this dependency!
	private GameType game;

	private BlindsState currentState;

	private BlindsInfo blindsInfo = new BlindsInfo();

	private BlindsInfo previousBlindsInfo;

	private boolean isTournamentBlinds;

	public static final BlindsState WAITING_FOR_SMALL_BLIND_STATE = new WaitingForSmallBlindState();

	public static final BlindsState WAITING_FOR_BIG_BLIND_STATE = new WaitingForBigBlindState();

	public static final BlindsState WAITING_FOR_ENTRY_BET_STATE = new WaitingForEntryBetState();
	
	public static final BlindsState FINISHED_STATE = new FinishedState();
	
	public static final BlindsState CANCELED_STATE = new CanceledState();

	private SortedMap<Integer, PokerPlayer> sittingInPlayers;
	
	public BlindsRound(GameType game, boolean isTournament) {
		log.debug("Init new Blinds round");
		this.isTournamentBlinds = isTournament;
		this.game = game;
		this.sittingInPlayers = getSittingInPlayers(game.getSeatingMap());
		this.previousBlindsInfo = game.getBlindsInfo();
		blindsInfo.setAnteLevel(game.getAnteLevel());
		clearPlayerActionOptions();
		initBlinds();
		if (blindsInfo.hasDeadSmallBlind()) {
			currentState = WAITING_FOR_BIG_BLIND_STATE;
		} else {
			currentState = WAITING_FOR_SMALL_BLIND_STATE;
		}
	}

	private void clearPlayerActionOptions() {
		SortedMap<Integer, PokerPlayer> seatingMap = game.getSeatingMap();
		for (PokerPlayer p : seatingMap.values()) {
			p.clearActionRequest();
		}
	}

	private void initBlinds() {
		if (firstHandOnTable()) {
			initFirstHandOnTable();
		} else {
			if (previousBlindsInfo.isHeadsUpLogic()) {
				if (numberPlayersSittingIn() > 2) {
					moveFromHeadsUpToNonHeadsUp();
				} else {
					initHeadsUpHand();
				}
			} else {
				if (numberPlayersSittingIn() > 2) {
					initNonHeadsUpHand();
				} else {
					moveFromNonHeadsUpToHeadsUp();
				}
			}
		}
	}

	private boolean firstHandOnTable() {
		return !previousBlindsInfo.isDefined() || !atLeastOnePlayerHasEntered();
	}

	private boolean atLeastOnePlayerHasEntered() {
		boolean result = false;
		
		for (PokerPlayer player : sittingInPlayers.values()) {
			if (player.hasPostedEntryBet()) {
				result = true;
				break;
			}
		}
		
		return result;
	}

	private SortedMap<Integer, PokerPlayer> getSittingInPlayers(SortedMap<Integer, PokerPlayer> sortedMap) {
		SortedMap<Integer, PokerPlayer> copy = new TreeMap<Integer, PokerPlayer>(sortedMap);
		Iterator<PokerPlayer> iterator = copy.values().iterator();
		while (iterator.hasNext()) {
			PokerPlayer player = iterator.next();
			if (player.isSittingOut()) {
				iterator.remove();
			}
		}
		return copy;
	}

	private void moveFromNonHeadsUpToHeadsUp() {
		// Moving from non heads up to heads up.
		PokerPlayer bigBlind = getSittingInPlayerInSeatAfter(previousBlindsInfo.getBigBlindSeatId());
		setBigBlind(bigBlind);

		PokerPlayer smallBlind = getSittingInPlayerInSeatAfter(bigBlind.getSeatId());
		moveDealerButtonToSeatId(smallBlind.getSeatId());
		requestSmallBlind(smallBlind);
	}

	private void initNonHeadsUpHand() {
		log.debug("Initing non heads up hand on table");
		moveDealerButtonToSeatId(previousBlindsInfo.getSmallBlindSeatId());
		PokerPlayer smallBlind = getPlayerInSeat(previousBlindsInfo.getBigBlindSeatId());
		PokerPlayer bigBlind = getSittingInPlayerInSeatAfter(previousBlindsInfo.getBigBlindSeatId());
		setBigBlind(bigBlind);

		if (smallBlindStillSeated(smallBlind)) {
			requestSmallBlind(smallBlind);
		} else {
			handleDeadSmallBlind();
			requestBigBlind(bigBlind);
		}
	}

	private void handleDeadSmallBlind() {
		PokerPlayer player = game.getPlayer(previousBlindsInfo.getBigBlindPlayerId());

		if (player != null) {
			if (isSittingOut(player)) {
				player.setSitOutStatus(SitOutStatus.MISSED_SMALL_BLIND);
			}
		}
		// Always remember the small blind seat id anyway.
		blindsInfo.setSmallBlindSeatId(previousBlindsInfo.getBigBlindSeatId());
		blindsInfo.setHasDeadSmallBlind(true);
	}

	private void initHeadsUpHand() {
		// Keeping heads up logic.
		moveDealerButtonToSeatId(previousBlindsInfo.getBigBlindSeatId());
		PokerPlayer smallBlind = getPlayerInSeat(previousBlindsInfo.getBigBlindSeatId());
		PokerPlayer bigBlind = getSittingInPlayerInSeatAfter(previousBlindsInfo.getBigBlindSeatId());
		setBigBlind(bigBlind);

		if (smallBlindStillSeated(smallBlind)) {
			requestSmallBlind(smallBlind);
		} else {
			handleDeadSmallBlind();
			requestBigBlind(bigBlind);
		}
	}

	private void moveFromHeadsUpToNonHeadsUp() {
		// Turning off heads up logic.
		moveDealerButtonToSeatId(previousBlindsInfo.getSmallBlindSeatId());
		PokerPlayer smallBlind = getPlayerInSeat(previousBlindsInfo.getBigBlindSeatId());
		PokerPlayer bigBlind = getSittingInPlayerInSeatAfter(previousBlindsInfo.getBigBlindSeatId());
		setBigBlind(bigBlind);
		if (smallBlindStillSeated(smallBlind)) {
			requestSmallBlind(smallBlind);
		} else {
			handleDeadSmallBlind();
			requestBigBlind(bigBlind);
		}
	}

	private void initFirstHandOnTable() {
		// This is the first hand on this table.
		if (numberPlayersSittingIn() > 2) {
			initFirstNonHeadsUpHand();
		} else if (numberPlayersSittingIn() == 2) {
			initFirstHeadsUpHand();
		} else {
			throw new RuntimeException("Don't know how to start a hand with less than two players.");
		}
	}

	private void setBigBlind(PokerPlayer bigBlind) {
		blindsInfo.setBigBlind(bigBlind);
	}

	private void requestSmallBlind(PokerPlayer smallBlind) {
		getBlindsInfo().setSmallBlind(smallBlind);
		smallBlind.enableOption(new PossibleAction(PokerActionType.SMALL_BLIND, blindsInfo.getAnteLevel()/2));
		smallBlind.enableOption(new PossibleAction(PokerActionType.DECLINE_ENTRY_BET));
		game.requestAction(smallBlind.getActionRequest());
	}

	private void requestBigBlind(PokerPlayer bigBlind) {
		for (PokerPlayer p : game.getSeatingMap().values()) {
			p.clearActionRequest();
		}
		
		bigBlind.enableOption(new PossibleAction(PokerActionType.BIG_BLIND, blindsInfo.getAnteLevel()));
		bigBlind.enableOption(new PossibleAction(PokerActionType.DECLINE_ENTRY_BET));
		game.requestAction(bigBlind.getActionRequest());
	}
	
	private void initFirstHand(Iterator<PokerPlayer> iterator) {
		setAllPlayersToNoMissedBlinds();
		PokerPlayer smallBlind = iterator.next();

		// The small blind seat id can be set immediately.
		getBlindsInfo().setSmallBlind(smallBlind);
		requestSmallBlind(smallBlind);

		PokerPlayer bigBlind = iterator.next();
		setBigBlind(bigBlind);
	}

	private void setAllPlayersToNoMissedBlinds() {
		for (PokerPlayer p : game.getPlayers()) {
			p.setHasPostedEntryBet(true);
		}
	}

	private void initFirstHeadsUpHand() {
		log.debug("Initing first heads up hand on table");
		Collection<PokerPlayer> players = sittingInPlayers.values();
		PokerPlayer firstPlayer = players.iterator().next();
		moveDealerButtonToSeatId(firstPlayer.getSeatId());
		// Fetching a new iterator, so that the dealer will become the small blind.
		initFirstHand(players.iterator());
	}

	private void initFirstNonHeadsUpHand() {
		log.debug("Initing first non heads up hand on table");
		Iterator<PokerPlayer> iterator = sittingInPlayers.values().iterator();
		PokerPlayer firstPlayer = iterator.next();
		moveDealerButtonToSeatId(firstPlayer.getSeatId());
		initFirstHand(iterator);
	}

	private PokerPlayer getSittingInPlayerInSeatAfter(int seatId) {
		return PokerUtils.getElementAfter(seatId, sittingInPlayers);
	}

	private boolean isSittingOut(PokerPlayer player) {
		return player == null || player.isSittingOut();
	}

	private void moveDealerButtonToSeatId(int newDealerSeatId) {
		blindsInfo.setDealerButtonSeatId(newDealerSeatId);
		if (!isTournamentBlinds) {
			markPlayersWhoMissedBlinds(previousBlindsInfo.getDealerButtonSeatId(), blindsInfo.getDealerButtonSeatId());
		}
		game.notifyDealerButton(blindsInfo.getDealerButtonSeatId());
	}

	private void markPlayersWhoMissedBlinds(int buttonFromSeatId, int buttonToSeatId) {
		for (PokerPlayer p : game.getSeatingMap().values()) {
			if (PokerUtils.isBetween(p.getSeatId(), buttonFromSeatId, buttonToSeatId)
					&& !p.hasPostedEntryBet()
					&& p.getSitOutStatus() != SitOutStatus.NOT_ENTERED_YET) {
				p.setSitOutStatus(SitOutStatus.MISSED_BIG_BLIND);
			}
		}
	}

	private boolean smallBlindStillSeated(PokerPlayer smallBlind) {
		if (smallBlind == null) {
			return false;
		}

		PokerPlayer playerInSmallBlindSeat = getPlayerInSeat(smallBlind.getSeatId());
		return smallBlind.getId() == playerInSmallBlindSeat.getId() && smallBlind.hasPostedEntryBet();
	}

	private PokerPlayer getPlayerInSeat(int seatId) {
		return game.getSeatingMap().get(seatId);
	}

	private int numberPlayersSittingIn() {
		return sittingInPlayers.size();
	}

	public void act(PokerAction action) {
		switch (action.getActionType()) {
		case SMALL_BLIND:
			currentState.smallBlind(action.getPlayerId(), this);
			break;
		case BIG_BLIND:
			currentState.bigBlind(action.getPlayerId(), this);
			break;
		case DECLINE_ENTRY_BET:
			currentState.declineEntryBet(action.getPlayerId(), this);
			break;
		default:
			throw new IllegalArgumentException(action.getActionType() + " is not legal here");
		}
		getGame().getPlayer(action.getPlayerId()).clearActionRequest();
		game.getServerAdapter().notifyActionPerformed(action);
	}

	public BlindsInfo getBlindsInfo() {
		return blindsInfo;
	}

	public void smallBlindPosted() {
		this.currentState = WAITING_FOR_BIG_BLIND_STATE;
		PokerPlayer bigBlind = game.getPlayer(blindsInfo.getBigBlindPlayerId());
		requestBigBlind(bigBlind);
	}

	public void smallBlindDeclined(PokerPlayer player) {
		sittingInPlayers.remove(player.getSeatId());
		notifyPlayerSittingOut(player.getId(),player.getImageUrl());
		if (numberPlayersSittingIn() >= 2) {
			PokerPlayer bigBlind = game.getPlayer(blindsInfo.getBigBlindPlayerId());
			requestBigBlind(bigBlind);
			currentState = WAITING_FOR_BIG_BLIND_STATE;
		} else {
			currentState = CANCELED_STATE;
		}
	}

	private void notifyPlayerSittingOut(int playerId, String imageUrl) {
		if (game.getState() != null) {
			game.getState().notifyPlayerSittingOut(playerId,imageUrl);
		}
	}

	public void bigBlindPosted() {
		if (!isTournamentBlinds() && thereAreUnEnteredPlayersBetweenBigBlindAndDealerButton()) {
			log.debug("There are unentered players, requesting entry bet");
			this.currentState = WAITING_FOR_ENTRY_BET_STATE;
			PokerPlayer entryBetter = getNextEntryBetter();
			requestBigBlind(entryBetter);			
		} else {
			currentState = FINISHED_STATE;
		}
	}

	public PokerPlayer getNextEntryBetter() {
		PokerPlayer result = null;
		for (PokerPlayer player : PokerUtils.unwrapList(sittingInPlayers, blindsInfo.getBigBlindSeatId())) {
			if (!player.hasPostedEntryBet() && !player.isSittingOut()) {
				result = player;
				break;
			}
		}
		return result;
	}

	private boolean thereAreUnEnteredPlayersBetweenBigBlindAndDealerButton() {
		boolean result = false;
		
		for (PokerPlayer player : sittingInPlayers.values()) {
			if (isPlayerBetweenBigBlindAndDealerButton(player) && !player.hasPostedEntryBet() && !player.isSittingOut()) {
				result = true;
				break;
			}
		}
		
		return result;
	}

	private boolean isPlayerBetweenBigBlindAndDealerButton(PokerPlayer player) {
		return PokerUtils.isBetween(player.getSeatId(), blindsInfo.getBigBlindSeatId(), blindsInfo.getDealerButtonSeatId());
	}

	public void bigBlindDeclined(PokerPlayer player) {
		log.debug(player + " declined big blind.");
		sittingInPlayers.remove(player.getSeatId());
		notifyPlayerSittingOut(player.getId(), player.getImageUrl());
		PokerPlayer nextBig = getSittingInPlayerInSeatAfter(player.getSeatId());
		if (nextBig != null && playerIsSittingInAndNotSmallBlind(nextBig)) {
			requestBigBlind(nextBig);
			// Set the new player as big blind in the context
			blindsInfo.setBigBlind(nextBig);
		} else {
			currentState = CANCELED_STATE;
		}
	}
	
	public void entryBetDeclined(PokerPlayer player) {
		sittingInPlayers.remove(player.getSeatId());
		notifyPlayerSittingOut(player.getId(), player.getImageUrl());
		if (thereAreUnEnteredPlayersBetweenBigBlindAndDealerButton()) {
			log.debug("There are unentereed players, requesting entry bet");
			this.currentState = WAITING_FOR_ENTRY_BET_STATE;
			PokerPlayer entryBetter = getNextEntryBetter();
			requestBigBlind(entryBetter);			
		} else {
			currentState = FINISHED_STATE;
		}		
	}	

	private boolean playerIsSittingInAndNotSmallBlind(PokerPlayer nextBig) {
		if (blindsInfo.getSmallBlindPlayerId() == nextBig.getId()) {
			return false;
		}

		return true;
	}

	public GameType getGame() {
		return game;
	}

	public void timeout() {
		currentState.timeout(this);
	}

	public boolean isTournamentBlinds() {
		return isTournamentBlinds;
	}

	public String getStateDescription() {
		return currentState != null ? currentState.getClass().getName() : "currentState=null";
	}

	public boolean isFinished() {
		return currentState.isFinished();
	}
	
	public boolean isCanceled() {
		return currentState.isCanceled();
	}

	public void visit(RoundVisitor visitor) {
		visitor.visit(this);
	}
}
