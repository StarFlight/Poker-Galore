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

package com.cubeia.poker.player;

import org.apache.log4j.Logger;

import ca.ualberta.cs.poker.Card;
import ca.ualberta.cs.poker.Hand;

import com.cubeia.poker.action.ActionRequest;
import com.cubeia.poker.action.PossibleAction;

public class DefaultPokerPlayer implements PokerPlayer {

	@SuppressWarnings("unused")
	private static final Logger log = Logger.getLogger(DefaultPokerPlayer.class);
	
	protected static final long serialVersionUID = 74353817602536715L;

	protected int betStack = 0;
	
	protected ActionRequest actionRequest;
	
	protected int playerId;
	
	protected int seatId;

	protected String imageUrl;
	
	protected Hand pocketCards = new Hand();
	
	protected boolean hasActed;
	
	protected boolean hasFolded;
	
	protected boolean hasOption;

	protected boolean isSitOutNextRound = false;
	
	protected SitOutStatus sitOutStatus;

	protected boolean hasPostedEntryBet;

	protected boolean isSittingOut;

	private long balance = 0;

	private boolean isInHand;

	private long returnedChips = 0;
	// ADDED TO DISPLAY WHO WINS THE HAND in the client check handresultevaluator where it is set
	// to reset when a new hand is dealt
	protected int winnerFl = 0;


	public int getHandWinnerFl() {
		return winnerFl;
	}

	public void setHandWinnerFl(int winnerFl) {
		this.winnerFl = winnerFl;
	}

	public DefaultPokerPlayer(int id) {
		playerId = id;
	}
	
	public DefaultPokerPlayer(int id, String picUrl) {
		playerId = id;
		imageUrl = picUrl;
		log.debug("Inside DefaultPokerPlayer " + imageUrl );
	}
	
	public String toString() {
	    return "pid["+playerId+"] seat["+seatId+"] imageUrl["+imageUrl+"] balance["+balance+"] sitout["+isSittingOut+"] sitoutstatus["+sitOutStatus+"] folded["+hasFolded+"] hasActed["+hasActed+"]";
	}
	
	public void addBet(long bet) {
		betStack += bet;
		if (betStack > balance) {
			throw new IllegalArgumentException("PokerPlayer["+playerId+"] - "+String.format("Bet (%d) is bigger than balance (%d)", bet, balance));
		}
	}

	public void clearActionRequest() {
		actionRequest = new ActionRequest();
		actionRequest.setPlayerId(playerId);
	}

	public void clearBetStack() {
		betStack = 0;
		returnedChips = 0;
	}

	public long getBetStack() {
		return betStack;
	}

	public int getId() {
		return playerId;
	}

	public Hand getPocketCards() {
		return pocketCards;
	}

	public ActionRequest getActionRequest() {
		return actionRequest;
	}

	public int getSeatId() {
		return seatId;
	}

	public String getImageUrl() {
		return imageUrl;
	}
	
	public boolean hasActed() {
		return hasActed;
	}

	public boolean hasFolded() {
		return hasFolded;
	}

	public void setActionRequest(ActionRequest actionRequest) {
		// log.trace("Setting action request " + actionRequest + " on player " + getId());
		this.actionRequest = actionRequest;
	}

	public void setHasActed(boolean b) {
		this.hasActed = b;
	}

	public void setHasFolded(boolean b) {
		this.hasFolded = b;
	}

	public void setHasOption(boolean b) {
		hasOption = b;
	}

	public boolean hasOption() {
		return hasOption;
	}

	public void addPocketCard(Card card) {
		pocketCards.addCard(card);
	}

	public void clearHand() {
		pocketCards.makeEmpty();
	}

	public void enableOption(PossibleAction option) {
		if (actionRequest == null) {
			actionRequest = new ActionRequest();
			actionRequest.setPlayerId(playerId);
		}

		actionRequest.enable(option);
	}

	public SitOutStatus getSitOutStatus() {
		return sitOutStatus;
	}

	public boolean hasPostedEntryBet() {
		return hasPostedEntryBet;
	}

	public void setSitOutStatus(SitOutStatus status) {
		this.isSittingOut = true;
		this.sitOutStatus = status;
	}

	public void setHasPostedEntryBet(boolean status) {
		hasPostedEntryBet = status;
	}


	
	public boolean isSittingOut() {
		return isSittingOut;
	}
	
	public void sitIn() {
		this.isSittingOut = false;
	}

	public void clearBalance() {
		this.balance = 0;
		this.returnedChips = 0;
	}

	public long getBalance() {
		return balance - betStack + returnedChips;
	}

	public void setPlayerIsInHand(boolean inHand) {
		this.isInHand = inHand;
	}

	public boolean isInHand() {
		return isInHand;
	}

	public void addChips(long chips) {
		this.balance += chips;
	}

	public void commitBetStack() {
		this.balance -= betStack;
		//this.balance += returnedChips;
		
		clearBetStack();
	}
	
	public void setBalance(long balance) {
		this.balance = balance;
	}

	@Override
	public boolean isAllIn() {
		return getBalance() == 0;
	}

	@Override
	public void addReturnedChips(long chips) {
		returnedChips = chips;
		
	}

	@Override
	public long getReturnedChips() {
		return returnedChips;
	}

	@Override
	public boolean getSitOutNextRound() {
		return isSitOutNextRound;
	}

	@Override
	public void setSitOutNextRound(boolean b) {
		isSitOutNextRound = b;
		
	}


}
