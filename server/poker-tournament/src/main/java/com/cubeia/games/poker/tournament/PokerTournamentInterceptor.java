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
import com.cubeia.firebase.api.mtt.model.MttRegisterResponse;
import com.cubeia.firebase.api.mtt.model.MttRegistrationRequest;
import com.cubeia.firebase.api.mtt.support.registry.PlayerInterceptor;
import com.cubeia.games.poker.tournament.state.PokerTournamentState;
import com.cubeia.games.poker.tournament.state.PokerTournamentStatus;

public class PokerTournamentInterceptor implements PlayerInterceptor {

	private transient PokerTournamentUtil util = new PokerTournamentUtil();
	
    @SuppressWarnings("unused")
    private final PokerTournament pokerTournament;

    public PokerTournamentInterceptor(PokerTournament pokerTournament) {
        this.pokerTournament = pokerTournament;
    }

    public MttRegisterResponse register(MttInstance instance, MttRegistrationRequest request) {
    	PokerTournamentState state = util.getPokerState(instance);
        if (state.getStatus() != PokerTournamentStatus.REGISTERING) {
            return MttRegisterResponse.ALLOWED;
        } else {
            return MttRegisterResponse.ALLOWED;
        }
    }

    public MttRegisterResponse unregister(MttInstance instance, int pid) {
    	PokerTournamentState state = util.getPokerState(instance);
    	
        if (state.getStatus() != PokerTournamentStatus.REGISTERING) {
            return MttRegisterResponse.DENIED;
        } else {
            return MttRegisterResponse.ALLOWED;
        }
    }

}
