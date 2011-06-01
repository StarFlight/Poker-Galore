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

package com.cubeia.poker;

import java.io.Serializable;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;

import ca.ualberta.cs.poker.Card;

import com.cubeia.poker.action.ActionRequest;
import com.cubeia.poker.action.PokerAction;
import com.cubeia.poker.adapter.ServerAdapter;
import com.cubeia.poker.player.PokerPlayer;
import com.cubeia.poker.rounds.blinds.BlindsInfo;

/**
 * Each game type, such as Texas Hold'em or Omaha should implement this interface.
 *
 * TODO: *SERIOUS* cleanup and probably major refactoring.
 */
public interface GameType extends Serializable {

	public void startHand(SortedMap<Integer, PokerPlayer> seatingMap, Map<Integer, PokerPlayer> playerMap);

	public void act(PokerAction action);

	public List<Card> getCommunityCards();

	public SortedMap<Integer, PokerPlayer> getSeatingMap();

	public PokerPlayer getPlayer(int playerId);

	public void scheduleRoundTimeout();
	
	public void requestAction(ActionRequest r);

//	public void requestAction(PokerPlayer player, PossibleAction... option);

	public BlindsInfo getBlindsInfo();

	public Iterable<PokerPlayer> getPlayers();
	
	public int countNonFoldedPlayers();

	public void prepareNewHand();

	public void notifyDealerButton(int dealerButtonSeatId);

	public ServerAdapter getServerAdapter();

	public void timeout();

	public String getStateDescription();

	public boolean isPlayerInHand(int playerId);

	public PokerState getState();

	public int getAnteLevel();
	
	public void dealCommunityCards();
}
