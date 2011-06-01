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

package com.cubeia.games.poker.tournament.activator.scanner.db;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import com.cubeia.firebase.api.mtt.MttFactory;
import com.cubeia.firebase.api.mtt.lobby.MttLobbyObject;
import com.cubeia.firebase.api.service.ServiceRegistry;
import com.cubeia.games.poker.persistence.tournament.TournamentActivatorDAO;
import com.cubeia.games.poker.persistence.tournament.model.TournamentConfiguration;
import com.cubeia.games.poker.persistence.tournament.model.TournamentStartType;
import com.cubeia.games.poker.tournament.PokerTournamentLobbyAttributes;
import com.cubeia.games.poker.tournament.activator.PokerTournamentActivatorImpl;
import com.cubeia.games.poker.tournament.activator.PokerTournamentCreationParticipant;
import com.cubeia.games.poker.tournament.activator.scanner.AbstractTournamentScanner;
import com.cubeia.games.poker.tournament.state.PokerTournamentStatus;

/**
 * The DB Tournament Activator uses a database to read tournament configurations.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class DBTournamentScanner extends AbstractTournamentScanner implements Runnable {

    private static transient Logger log = Logger.getLogger(DBTournamentScanner.class);

    private ServiceRegistry services;

    private Map<Integer, TournamentConfiguration> runningSitAndGos = new HashMap<Integer, TournamentConfiguration>();


    /*------------------------------------------------

        LIFECYCLE METHODS

     ------------------------------------------------*/

    public DBTournamentScanner() {
        log.info("Poker Database Tournament Activator created");
    }


    public void start() {
        services = context.getServices();
        super.start();
    }
    



    /*------------------------------------------------

        PUBLIC ACTIVATOR INTERFACE METHODS

     ------------------------------------------------*/

    public void checkTournamentsNow() {
        synchronized (LOCK) {                       
            scanTournamentConfiguration();
            Set<Integer> removed = checkDestroyTournaments();
            restartSitAndGos(removed);
        }
    }




    /*------------------------------------------------

        PRIVATE & INTERNAL LOGIC METHODS

     ------------------------------------------------*/


    public void setMttFactory(MttFactory factory) {
        this.factory = factory;
    }

    public void run() {
        scanTournamentConfiguration();
    }

    /**
     * Read tournament configurations from database and apply them
     * as applicable to the system.
     */
    private void scanTournamentConfiguration() {
        try {
            TournamentActivatorDAO dao = new TournamentActivatorDAO(services);
            List<TournamentConfiguration> configs = dao.readAll();
            MttLobbyObject[] tournaments = factory.listTournamentInstances(PokerTournamentActivatorImpl.POKER_TOURNAMENT_ID);
            
            // TODO: Compare running and configured tournaments.
            // For sit and gos we should always have one running instance - DONE
            //
            // For scheduled tournaments we only need to verify that the tournament
            // is scheduled in the lobby (if applicable)
            
            
            for (TournamentConfiguration conf : configs) {
                if (conf.getStartType().equals(TournamentStartType.SIT_AND_GO)) {
                    
                    if (!isWaiting(conf, tournaments)) {
                        createNewSitAndGo(conf);
                    }
                    
                }
            }
            
        } catch (Exception e) {
            log.error("Could not read tournament configurations", e);
        }

    }


    private boolean isWaiting(TournamentConfiguration conf, MttLobbyObject[] tournaments) {
        boolean openForRegistration = false;
        for (MttLobbyObject mtt : tournaments) {
            if (mtt.getAttributes().get("NAME").getStringValue().equals(conf.getName())) {
                String status = (String) mtt.getAttributes().get(PokerTournamentLobbyAttributes.STATUS.name()).getData();
                if (status.equalsIgnoreCase(PokerTournamentStatus.REGISTERING.name())) {
                    openForRegistration = true;
                }
            }
        }
        return openForRegistration;
    }


    private void createNewSitAndGo(TournamentConfiguration conf) {
        MttLobbyObject mtt = factory.createMtt(context.getMttId(), conf.getName(), new PokerTournamentCreationParticipant(conf));
        runningSitAndGos.put(mtt.getObjectId(), conf);
        log.debug("Add created mtt id: "+mtt.getObjectId());
    }

    private void restartSitAndGos(Set<Integer> removed) {
        for (Integer instanceId : removed) {
            log.debug("Restart removed tournament: "+instanceId);
            createNewSitAndGo(runningSitAndGos.get(instanceId));
        }
    }

    
}
