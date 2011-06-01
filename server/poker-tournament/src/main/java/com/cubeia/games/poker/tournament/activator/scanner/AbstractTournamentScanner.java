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

package com.cubeia.games.poker.tournament.activator.scanner;

import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

import org.apache.log4j.Logger;

import com.cubeia.firebase.api.mtt.MttFactory;
import com.cubeia.firebase.api.mtt.activator.ActivatorContext;
import com.cubeia.firebase.api.mtt.lobby.MttLobbyObject;
import com.cubeia.firebase.api.server.SystemException;
import com.cubeia.games.poker.tournament.PokerTournamentLobbyAttributes;
import com.cubeia.games.poker.tournament.activator.PokerActivator;
import com.cubeia.games.poker.tournament.state.PokerTournamentStatus;

public abstract class AbstractTournamentScanner implements PokerActivator, Runnable {

    public static final long INITIAL_TOURNAMENT_CHECK_DELAY = 5000;

    public static final long TOURNAMENT_CHECK_INTERVAL = 10000;

    public static final long SHUTDOWN_WAIT_TIME = 10000;
    
    public static final long DELAY_BEFORE_REMOVING_FINISHED_TOURNAMENTS = 30; // Seconds
    
    private static final transient Logger log = Logger.getLogger(AbstractTournamentScanner.class);
    
    protected MttFactory factory;

    protected ActivatorContext context;
    
    protected ScheduledExecutorService executorService = null;
    
    private ScheduledFuture<?> checkTablesFuture = null;
    
    /** Lock to synchronize reading and creation of tournament instances */
    protected final Object LOCK = new Object();
    
    

    

    /*------------------------------------------------

        LIFECYCLE METHODS

     ------------------------------------------------*/
    
    public void init(ActivatorContext context) throws SystemException {
        this.context = context;
    }
    
    
    public void start() {
        synchronized (LOCK) {                       
            if (checkTablesFuture != null) {
                log.warn("Start called on running activator.");
            }

            executorService = Executors.newScheduledThreadPool(1);
            checkTablesFuture = executorService.scheduleAtFixedRate(this, INITIAL_TOURNAMENT_CHECK_DELAY, TOURNAMENT_CHECK_INTERVAL, TimeUnit.MILLISECONDS);
        }       
    }
    
    
    public void setMttFactory(MttFactory factory) {
        this.factory = factory;
    }
    
    public void stop() {
        synchronized (LOCK) {       
            if (checkTablesFuture == null) {                
                // already stopped
                return;
            } 

            checkTablesFuture.cancel(false);        
            executorService.shutdown();

            try {
                executorService.awaitTermination(SHUTDOWN_WAIT_TIME, TimeUnit.MILLISECONDS);
            } catch (InterruptedException e) {
                log.error("interrupted waiting for checktable executor to terminate.", e);
            }

            if (!executorService.isTerminated()) {
                log.error("executor service failed to terminate on shutdown.");
            }

            checkTablesFuture = null;
            executorService = null;
        }       
    }
    
    public void destroy() {}
    
    
    /*------------------------------------------------

        ABSTRACT METHODS

     ------------------------------------------------*/

    
    
    
    /*------------------------------------------------

        PRIVATE & LOGIC METHODS

     ------------------------------------------------*/
    
    /**
     * Checks for finished tournaments and schedules them to be removed.
     */
    protected Set<Integer> checkDestroyTournaments() {
        MttLobbyObject[] tournamentInstances = factory.listTournamentInstances();
        Set<Integer> removed = new HashSet<Integer>();
        
        for (MttLobbyObject t : tournamentInstances) {
            String status = (String) t.getAttributes().get(PokerTournamentLobbyAttributes.STATUS.name()).getData();

            if (status.equalsIgnoreCase(PokerTournamentStatus.FINISHED.name())) {
                executorService.schedule(new Destroyer(t.getTournamentId()), DELAY_BEFORE_REMOVING_FINISHED_TOURNAMENTS, TimeUnit.SECONDS);
                removed.add(t.getTournamentId());
            }
        }
        return removed;
    }
    
    
    protected class Destroyer implements Runnable {

        private final int mttid;

        public Destroyer(int mttid) {
            this.mttid = mttid;
        }

        public void run() {
            // FIXME: Magic number 7 here is poker game id
            factory.destroyMtt(7, mttid);
        }
    }
    
    
    public void run() {
        try {
            synchronized (LOCK) {
                checkTournamentsNow();
            }
        } catch (Throwable t) {
            // Catching all errors so that the scheduler won't take the hit (and die).
            log.fatal("Failed checking tournaments: " + t, t);
        }       
    }
}
