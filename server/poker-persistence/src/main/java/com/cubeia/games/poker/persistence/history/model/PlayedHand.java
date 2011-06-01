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

package com.cubeia.games.poker.persistence.history.model;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

import org.apache.log4j.Logger;

@Entity
public class PlayedHand implements Serializable {
	
    private static final long serialVersionUID = 1L;
    
    private static Logger log = Logger.getLogger(PlayedHand.class);
    
	private Integer id;

    private int tableId = -1;
    
    private Date date = new Date();
    
    private Set<PlayedHandEvent> events;

    @Id @GeneratedValue(strategy=GenerationType.AUTO)
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    @OneToMany(mappedBy="hand", cascade={CascadeType.ALL})
    public Set<PlayedHandEvent> getEvents() {
    	if (events.size() > 150) {
    		log.warn("LARGE HAND HISTORY WARNING: Events="+events.size());
    	}
        return events;
    }

    public void setEvents(Set<PlayedHandEvent> events) {
        this.events = events;
    }

    public int getTableId() {
        return tableId;
    }

    public void setTableId(int tableId) {
        this.tableId = tableId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
    
}
