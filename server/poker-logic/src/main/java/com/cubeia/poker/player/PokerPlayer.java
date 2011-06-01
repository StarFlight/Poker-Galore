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

import java.io.Serializable;

import ca.ualberta.cs.poker.Card;
import ca.ualberta.cs.poker.Hand;

import com.cubeia.poker.action.ActionRequest;
import com.cubeia.poker.action.PossibleAction;

public interface PokerPlayer extends Serializable {

	/**
	 * 
	 * @return a list of cards, never <code>null</code>.
	 */
	public Hand getPocketCards();
	
	public void addPocketCard(Card card);
	
	public void clearHand();

	public boolean getSitOutNextRound();
	
	public void setSitOutNextRound(boolean b);
	
	/**
	 * Gets the player's id.
	 * @return
	 */
	public int getId();

	public int getSeatId();
	
	public String getImageUrl();

	public long getBetStack();

	public void addBet(long i);

	public void clearActionRequest();

	public void setActionRequest(ActionRequest possibleActions);

	public ActionRequest getActionRequest();

	public void setHasActed(boolean b);

	public void setHasFolded(boolean b);

	public boolean hasFolded();

	public boolean hasActed();

	public void setHasOption(boolean b);
	
	public boolean hasOption();

	public void clearBetStack();

	public void enableOption(PossibleAction option);

	public void setSitOutStatus(SitOutStatus status);

	public SitOutStatus getSitOutStatus();

	public boolean hasPostedEntryBet();

	public void setHasPostedEntryBet(boolean b);
	//NEW
	public void setHandWinnerFl(int winnerFl);

	public int getHandWinnerFl();
	
	public boolean isSittingOut();

	public void clearBalance();
	
	public long getBalance();
	
	/**
	 * Sets this player as being in a hand or not.
	 * 
	 * @param isInHand <code>true</code> if the player is in a hand, <code>false</code> when the player is not in a hand
	 */
	public void setPlayerIsInHand(boolean isInHand);

	/**
	 * Checks if this player is in a hand.
	 * @return <code>true</code> if the player is in a hand, <code>false</code> otherwise
	 */
	public boolean isInHand();

	/**
	 * Adds (or removes) chips to the player's chip stack.
	 * 
	 * @param chips chips to add (positive) or remove (negative)
	 */
	public void addChips(long chips);

	public void commitBetStack();
	
	public boolean isAllIn();
	
	public void sitIn();
	
	public void addReturnedChips(long chips);

	public long getReturnedChips();
	
}