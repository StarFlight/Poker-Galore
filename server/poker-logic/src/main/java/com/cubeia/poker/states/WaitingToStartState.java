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

package com.cubeia.poker.states;

import org.apache.log4j.Logger;

import com.cubeia.poker.PokerState;
import com.cubeia.poker.action.PokerAction;
import com.cubeia.poker.player.DefaultPokerPlayer;
import com.cubeia.poker.player.PokerPlayer;

public class WaitingToStartState extends AbstractPokerGameState {

	private static final long serialVersionUID = -4837159720440582936L;
	
	private static transient Logger log = Logger.getLogger(WaitingToStartState.class);

	public String toString() {
	    return "WaitingToStartState";
	}
	
	@Override
	public void timeout(PokerState context) {
		if (!context.isTournamentTable()) {
			context.setHandFinished(false);
			
			if (context.countSittingInPlayers() > 1) {
				
				// FIXME: Resetting all low to zero balances since we have no wallet yet
				log.debug("context antelevel : " + context.getAnteLevel());
				for (PokerPlayer pp : context.getSeatedPlayers()) {
					 if (pp.getBalance() < context.getAnteLevel()) {
                         log.debug("Resetting player balance. Player["+pp.getId()+"] -> " + context.getAnteLevel()* 100);
                         ((DefaultPokerPlayer)pp).setBalance(context.getAnteLevel()* 100);
                         context.notifyPlayerBalanceReset(pp);
					 }

				}
				log.debug("Inside WaitingToStartState: timeout : context start hand called ");
				context.startHand();
			} else {
				context.setHandFinished(true);
				context.setState(PokerState.NOT_STARTED);
				log.info("WILL NOT START NEW HAND, TOO FEW PLAYERS SEATED: " + context.countSittingInPlayers() + " sitting in of " + context.getSeatedPlayers().size());
				context.cleanupPlayers(); // Will remove disconnected and leaving players
			}
		} else {
			log.debug("Ignoring timeout in waiting to start state, since tournament hands are started by the tournament manager.");
		}
	}
	
	public void act(PokerAction action, PokerState pokerGame) {
		log.info("Discarding out of order action: "+action);
	}

}
