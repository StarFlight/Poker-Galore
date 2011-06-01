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

import com.cubeia.poker.player.PokerPlayer;
import com.cubeia.poker.player.SitOutStatus;

public class WaitingForSmallBlindState extends AbstractBlindsState {

	private static final long serialVersionUID = 4983163822097132780L;
	
	@Override
	public void smallBlind(int playerId, BlindsRound context) {
		int smallBlind = context.getBlindsInfo().getSmallBlindPlayerId();
		if (smallBlind == playerId) {
			PokerPlayer player = context.getGame().getPlayer(playerId);
			player.addBet(context.getBlindsInfo().getSmallBlindLevel());
			context.smallBlindPosted();
		} else {
			throw new IllegalArgumentException("Expected player " + smallBlind + " to act, but got action from " + playerId);
		}
		
	}
	
	@Override
	public void declineEntryBet(Integer playerId, BlindsRound context) {
		int smallBlind = context.getBlindsInfo().getSmallBlindPlayerId();
		if (smallBlind == playerId) {
			PokerPlayer player = context.getGame().getPlayer(playerId);
			player.setSitOutStatus(SitOutStatus.MISSED_SMALL_BLIND);
			context.getBlindsInfo().setHasDeadSmallBlind(true);
			context.smallBlindDeclined(player);
		} else {
			throw new IllegalArgumentException("Expected player " + smallBlind + " to act, but got action from " + playerId);
		}		
	}
	
	@Override
	public void timeout(BlindsRound context) {
		if (context.isTournamentBlinds()) {
			smallBlind(context.getBlindsInfo().getSmallBlindPlayerId(), context);
		} else {
			int smallBlind = context.getBlindsInfo().getSmallBlindPlayerId();
			PokerPlayer player = context.getGame().getPlayer(smallBlind);
			player.setSitOutStatus(SitOutStatus.MISSED_SMALL_BLIND);
			context.getBlindsInfo().setHasDeadSmallBlind(true);
			context.smallBlindDeclined(player);
		}
	}
}
