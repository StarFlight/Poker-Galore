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

package com.cubeia.games.poker.tournament.activator.external.jmx;

import java.lang.management.ManagementFactory;

import javax.management.MBeanServer;
import javax.management.ObjectName;

import org.apache.log4j.Logger;

import com.cubeia.games.poker.tournament.activator.PokerTournamentActivator;

public class JMXActivator implements JMXActivatorMBean {

    private static final String JMX_BIND_NAME = "com.cubeia.poker:type=TournamentActivator";
    
    private static final transient Logger log = Logger.getLogger(JMXActivator.class);

    private final PokerTournamentActivator activator;
    
    public JMXActivator(PokerTournamentActivator activator) {
        this.activator = activator;
        initJmx();
    }

    public void checkInstancesNow() {
        activator.checkInstancesNow();
    }

    public void shutdownTournament(int mttInstanceId) {
        activator.shutdownTournament(mttInstanceId);
    }

    public void startTournament(int mttInstanceId) {
        activator.startTournament(mttInstanceId);
    }
    
    public void destroyTournament(int mttInstanceId) {
        activator.destroyTournament(mttInstanceId);
    }
    
    public void destroy() {
        destroyJmx();
    }
    

    /*------------------------------------------------
        
        JMX INITIALIZATION & DESTRUCTION
    
     ------------------------------------------------*/
    
    private void initJmx() {
        try {
            MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();
            ObjectName monitorName = new ObjectName(JMX_BIND_NAME);
            mbs.registerMBean(this, monitorName);
        } catch(Exception e) {
            log.error("failed to start mbean server", e);
        }
    }
    
    
    /**
     * Hmm, haven't found a good hook for shutting down JMX yet.
     */
    private void destroyJmx() {
        try {
            MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();
            ObjectName monitorName = new ObjectName(JMX_BIND_NAME);
            if(mbs.isRegistered(monitorName)) {
                mbs.unregisterMBean(monitorName);
            }
        } catch(Exception e) {
            log.error("failed to start mbean server", e);
        }
    }

   

}
