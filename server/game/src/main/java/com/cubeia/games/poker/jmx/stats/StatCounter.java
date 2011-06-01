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

package com.cubeia.games.poker.jmx.stats;

import java.util.concurrent.ConcurrentLinkedQueue;

/**
 * Count hits over a given time period.
 * Getting the count has performance impact so it is important not to call this
 * method often and/or concurrently. (It is typically designed for using with
 * a JMX interface which polls about once per second).
 * 
 * This class is not targeted towards highly concurrent data (e.g. > 100 hits per second).
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class StatCounter {
    
    private ConcurrentLinkedQueue<Hit> cache = new ConcurrentLinkedQueue<Hit>(); 
    
    private final long window;
    
    
    /**
     * Add a hit and remove tail object if too old.
     * The removal of the head object is only a safety precaution if no-one is polling
     * the stats object. (Polling cleans up the cache of all old objects).
     */
    public void register() {
        cache.add(new Hit());
        synchronized (cache) {
            if (System.currentTimeMillis() > cache.peek().time + window) {
                cache.remove();
            }
        }
    }
    
    public int getCurrent() {
        cleanAllOldObjects();
        return cache.size();
    }
    
    
	private void cleanAllOldObjects() {
        synchronized (cache) {
            while (cache.size() > 0) {
                if (System.currentTimeMillis() > cache.peek().time + window) {
                    cache.remove();
                } else {
                    break;
                }
            }
        }
        
    }

    public StatCounter(long millis) {
        this.window = millis;
	}
	
    
    private class Hit {
        public long time = System.currentTimeMillis();    
    }
	
}
