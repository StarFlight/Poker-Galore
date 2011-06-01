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

package com.cubeia.games.poker.jmx;

import java.lang.management.ManagementFactory;
import java.util.Date;

import javax.management.MBeanServer;
import javax.management.ObjectName;

import org.apache.log4j.Logger;

import com.cubeia.games.poker.jmx.stats.StatCounter;
import com.cubeia.games.poker.jmx.stats.StateMap;

/**
 * Singleton implementation of a statistics holder.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class PokerStats implements PokerStatsMBean {
    
    private static final String JMX_BIND_NAME = "com.cubeia.poker:type=PokerStats";

    private static transient Logger log = Logger.getLogger(PokerStats.class);
    
    private static PokerStats instance = new PokerStats();
    
    /** 60 second timer counter */
    private StatCounter handsPerMinute = new StatCounter(1000*60);
    
    /** 1 hour timer counter */
    private StatCounter handsPerHour = new StatCounter(1000*60*60);
    
    private StateMap stateMap = new StateMap();

    /** 
     * If true, then state changes will be recorded in a map. The map will
     * also frequently be scanned for stale tables.
     * 
     * Default is false.
     */
	private boolean stateTrackingEnabled = false;
    
    /*------------------------------------------------
        
        CONSTRUCTOR(S)
    
     ------------------------------------------------*/
    
    public static PokerStats getInstance() {
        return instance;
    }
    
    
    private PokerStats() {
        initJmx();
    };
    
    /*------------------------------------------------
        
        STATISTICAL ACCESSORS AND REPORTING
    
     ------------------------------------------------*/
    
    public void reportHandEnd() {
        handsPerMinute.register();
        handsPerHour.register();
    }
    
    public int getHandsPerHour() {
        return handsPerHour.getCurrent();
    }


    public int getHandsPerMinute() {
        return handsPerMinute.getCurrent();
    }

	public String getCurrentState(int tableId) {
		return stateMap.getState(tableId);
	}
	
	/**
	 * Stores a representation of the state for a given table.
	 * 
	 * Note, will only have effect if stateTrackingEnabled is set to true.
	 * 
	 * @param tableId
	 * @param state
	 */
	public void setState(int tableId, String state) {
		if (stateTrackingEnabled) {
			stateMap.setState(tableId, state);
		}
	}
	
	public Date getLastChangeDate(int tableId) {
		return stateMap.getLastChangeDate(tableId);
	}
	
	public void setStateTrackingEnabled(boolean enabled) {
		this.stateTrackingEnabled = enabled;
	}
	
	public boolean isStateTrackingEnabled() {
		return stateTrackingEnabled;
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
    @SuppressWarnings("unused")
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