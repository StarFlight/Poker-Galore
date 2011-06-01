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

package com.cubeia.games.poker.tournament;

import com.cubeia.firebase.api.mtt.MttInstance;
import com.cubeia.firebase.api.mtt.support.MTTStateSupport;
import com.cubeia.games.poker.tournament.state.PokerTournamentState;
import com.cubeia.games.poker.tournament.state.PokerTournamentStatus;

public class PokerTournamentUtil {

	public PokerTournamentState getPokerState(MttInstance instance) {
		return (PokerTournamentState) instance.getState().getState();
	}

	public void setTournamentStatus(MttInstance instance, PokerTournamentStatus status) {
		instance.getLobbyAccessor().setStringAttribute(PokerTournamentLobbyAttributes.STATUS.name(), status.name());
		getPokerState(instance).setStatus(status);
	}

	public MTTStateSupport getStateSupport(MttInstance instance) {
		return (MTTStateSupport) instance.getState();
	}

	public PokerTournamentState getPokerState(MTTStateSupport state) {
		return (PokerTournamentState) state.getState();
	}

}
