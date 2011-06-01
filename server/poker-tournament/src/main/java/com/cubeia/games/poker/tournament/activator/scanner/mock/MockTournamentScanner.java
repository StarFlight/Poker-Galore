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

package com.cubeia.games.poker.tournament.activator.scanner.mock;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import com.cubeia.firebase.api.mtt.activator.ActivatorContext;
import com.cubeia.firebase.api.mtt.lobby.MttLobbyObject;
import com.cubeia.firebase.io.protocol.Enums;
import com.cubeia.games.poker.tournament.PokerTournamentLobbyAttributes;
import com.cubeia.games.poker.tournament.activator.PokerTournamentCreationParticipant;
import com.cubeia.games.poker.tournament.activator.scanner.AbstractTournamentScanner;
import com.cubeia.games.poker.tournament.state.PokerTournamentStatus;
import com.cubeia.poker.timing.Timings;


/**
 * The Mock Tournament Activator creates new tournament automatically without the need of a database.
 * 
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class MockTournamentScanner extends AbstractTournamentScanner {

    private static transient Logger log = Logger.getLogger(MockTournamentScanner.class);

    private Map<String, PokerTournamentCreationParticipant> requestedTournaments = new HashMap<String, PokerTournamentCreationParticipant>();



    /*------------------------------------------------

        LIFECYCLE METHODS

     ------------------------------------------------*/

    public MockTournamentScanner() {
        requestedTournaments.put("headsup", new PokerTournamentCreationParticipant("headsup", 2));
        requestedTournaments.put("ten", new PokerTournamentCreationParticipant("ten", 10, Timings.SUPER_EXPRESS));
        requestedTournaments.put("hundred",  new PokerTournamentCreationParticipant("hundred", 100, Timings.SUPER_EXPRESS));
        requestedTournaments.put("1k",  new PokerTournamentCreationParticipant("1k", 1000, Timings.SUPER_EXPRESS));
        requestedTournaments.put("Five-oh",  new PokerTournamentCreationParticipant("Five-oh", 5000, Timings.EXPRESS));
        requestedTournaments.put("Big Ten",  new PokerTournamentCreationParticipant("Big Ten", 10000, Timings.EXPRESS));
        requestedTournaments.put("Twenty", new PokerTournamentCreationParticipant("Twenty", 20));
        requestedTournaments.put("Faaivssouzand", new PokerTournamentCreationParticipant("Faaivssouzand", 5000));
        requestedTournaments.put("Tensouzand", new PokerTournamentCreationParticipant("Tensouzand", 10000));
        requestedTournaments.put("Oansouzand", new PokerTournamentCreationParticipant("Oansouzand", 1000));
        requestedTournaments.put("2k", new PokerTournamentCreationParticipant("2k", 2000));
    }


    
    

    /*------------------------------------------------

        PUBLIC ACTIVATOR INTERFACE METHODS

     ------------------------------------------------*/

    public void checkTournamentsNow() {
        synchronized (LOCK) {
            checkTournaments();
            checkDestroyTournaments();
        }
    }



    /*------------------------------------------------

        PRIVATE METHODS

     ------------------------------------------------*/


    private void createInstance(String name, ActivatorContext context) {
        if (requestedTournaments.get(name) == null) {
            log.error("Won't start unknown tournament: " + name);
            return;
        }

        factory.createMtt(context.getMttId(), name, requestedTournaments.get(name));
    }	


    protected void checkTournaments() {
        MttLobbyObject[] tournamentInstances = factory.listTournamentInstances();
        Set<String> missingTournaments = new HashSet<String>();
        missingTournaments.addAll(requestedTournaments.keySet());

        for (MttLobbyObject t : tournamentInstances) {
            String status = (String) t.getAttributes().get(PokerTournamentLobbyAttributes.STATUS.name()).getData();
            if (status.equalsIgnoreCase(PokerTournamentStatus.REGISTERING.name())) {
                String name = (String) t.getAttributes().get(Enums.TournamentAttributes.NAME.name()).getData();
                missingTournaments.remove(name);
            }

//            if (status.equalsIgnoreCase(PokerTournamentStatus.FINISHED.name())) {
//                executorService.schedule(new Destroyer(t.getTournamentId()), DELAY_BEFORE_REMOVING_FINISHED_TOURNAMENTS, TimeUnit.SECONDS);
//            }
        }

        for (String name : missingTournaments) {
            createInstance(name, context);
        }
    }


}
