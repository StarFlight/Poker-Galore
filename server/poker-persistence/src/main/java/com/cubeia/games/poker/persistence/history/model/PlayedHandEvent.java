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

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
public class PlayedHandEvent implements Serializable {

    private static final long serialVersionUID = 1L;
    
    private Integer id;
    
    private int playerId = -1;
    
    private Long bet;
    
    private EventType type;
    
    private PlayedHand hand;

    @Id @GeneratedValue(strategy=GenerationType.AUTO)
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public int getPlayerId() {
        return playerId;
    }

    public void setPlayerId(int playerId) {
        this.playerId = playerId;
    }

    public Long getBet() {
        return bet;
    }

    public void setBet(Long bet) {
        this.bet = bet;
    }

    @Enumerated(EnumType.STRING)
    public EventType getType() {   
        return type;
    }

    public void setType(EventType type) {
        this.type = type;
    }

    @ManyToOne
    public PlayedHand getHand() {
        return hand;
    }

    public void setHand(PlayedHand hand) {
        this.hand = hand;
    }
    
    
}
