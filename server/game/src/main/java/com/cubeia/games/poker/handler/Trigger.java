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

package com.cubeia.games.poker.handler;

import java.io.Serializable;

/**
 * Container class for timeout triggers.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class Trigger implements Serializable {
    
    /** Version Id */
    private static final long serialVersionUID = 1L;
    
    private final TriggerType type;
    private int pid = 0;
    private int seq = -1;
    
    public Trigger(TriggerType type) {
        this.type = type; 
    }
    
    public Trigger(TriggerType type, int pid) {
        this.type = type; 
        this.pid = pid;
    }
    
    public String toString() {
        return "pid["+pid+"] type["+type+"] seq["+seq+"]";
    }
    
    public int getPid() {
        return pid;
    }
    
    public TriggerType getType() {
        return type;
    }
    
    public int getSeq() {
		return seq;
	}
    
    public void setSeq(int seq) {
		this.seq = seq;
	}
}
