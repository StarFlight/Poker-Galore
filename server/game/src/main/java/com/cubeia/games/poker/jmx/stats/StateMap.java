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

import java.util.Date;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.log4j.Logger;

public class StateMap {

	private static final Logger log = Logger.getLogger(StateMap.class);
	
	private ConcurrentHashMap<Integer, String> stateMap = new ConcurrentHashMap<Integer, String>();
	
	private ConcurrentHashMap<Integer, Date> dateMap = new ConcurrentHashMap<Integer, Date>();
	
	private int counter = 0;
	
	private final int CHECK_DEAD_TABLES_INTERVAL = 1000;
	
	private final int MILLIS_BEFORE_CONSIDERING_TABLE_DEAD = 60000; 
	
	public void setState(int tableId, String state) {
		stateMap.put(tableId, state);
		dateMap.put(tableId, new Date());
		
		if (counter++ > CHECK_DEAD_TABLES_INTERVAL) {
			counter = 0;
			checkDeadTables();
		}
	}
	
	private void checkDeadTables() {
		Date cutOff = new Date(System.currentTimeMillis() - MILLIS_BEFORE_CONSIDERING_TABLE_DEAD);
		for (Entry<Integer, Date> entry : dateMap.entrySet()) {
			if (entry.getValue().before(cutOff)) {
				log.warn("Table " + entry.getKey() + " has not changed since: " + entry.getValue());
			}
		}
	}

	public String getState(int tableId) {
		return stateMap.get(tableId);
	}

	public Date getLastChangeDate(int tableId) {
		return dateMap.get(tableId);
	}
}
