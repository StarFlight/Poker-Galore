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

package com.cubeia.poker.adapter;

import java.util.List;

import ca.ualberta.cs.poker.Card;

import com.cubeia.poker.action.ActionRequest;
import com.cubeia.poker.action.PokerAction;
import com.cubeia.poker.player.PokerPlayer;
import com.cubeia.poker.player.PokerPlayerStatus;
import com.cubeia.poker.pot.Pot;
import com.cubeia.poker.result.HandResult;
import com.cubeia.poker.tournament.RoundReport;

public interface ServerAdapter {
	
	public void scheduleTimeout(long millis);
	
	public void requestAction(ActionRequest request);

	public void notifyCommunityCards(List<Card> cards);
	
	/**
	 * Notify all players who is dealer.
	 * 
	 * @param playerId
	 */
	public void notifyDealerButton(int seatId);
	
	/**
	 * Sends the private cards to the given player and notify
	 * all other players with hidden cards.
	 * 
	 * @param playerId
	 * @param cards
	 */
	public void notifyPrivateCards(int playerId, List<Card> cards);
	
	public void exposePrivateCards(int playerId, List<Card> cards);
	
    /**
     * A new hand is about to start.
     */
    public void notifyNewHand();
    
    
	/**
	 * Notifies that the hand has ended.
	 * 
	 * @param handResult Summary of the results or null if hand was cancelled
	 * @param handEndStatus the way the hand ended, for example normal or canceled
	 */
	public void notifyHandEnd(HandResult handResult, HandEndStatus handEndStatus);

	/**
	 * Notify players about updated player balance.
	 * 
	 * @param player
	 */
	public void notifyPlayerBalance(PokerPlayer player);
	
	/**
	 * Called after an action from the player has been successfully
	 * dealt with.
	 * 
	 * @param action, not null.
	 */
	public void notifyActionPerformed(PokerAction action);
	
	/**
	 * Reports the end of a round to a tournament coordinator.
	 * 
	 * @param report, a report value object. Not null.
	 */
	public void reportTournamentRound(RoundReport report);
	
	/**
     * Remove all players in state LEAVING or DISCONNECTED
     */
    public void cleanupPlayers();
    
    public void updatePots(Iterable<Pot> iterable);

    public void notifyPlayerStatusChanged(int playerId, PokerPlayerStatus status, String imageUrl, int winnerFl);

    /**
	 * Notify players about updated player balance.
	 * 
	 * @param player
	 */
    public void notifyPlayerBalanceReset(PokerPlayer player);
    
}
