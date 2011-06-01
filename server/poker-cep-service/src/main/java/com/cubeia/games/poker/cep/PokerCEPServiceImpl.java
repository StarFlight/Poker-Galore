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

package com.cubeia.games.poker.cep;

import org.apache.log4j.Logger;

import com.cubeia.backoffice.cem.CEPService;
import com.cubeia.backoffice.cep.api.event.Event;
import com.cubeia.backoffice.cep.api.event.EventSubType;
import com.cubeia.backoffice.cep.api.event.EventType;
import com.cubeia.firebase.api.server.SystemException;
import com.cubeia.firebase.api.service.Service;
import com.cubeia.firebase.api.service.ServiceContext;
import com.cubeia.firebase.api.service.ServiceRegistry;
import com.cubeia.poker.player.PokerPlayer;

public class PokerCEPServiceImpl implements PokerCEPService, Service {
    
    private static final transient Logger log = Logger.getLogger(PokerCEPServiceImpl.class);
    
    private CEPService cepService;

    private ServiceRegistry serviceRegistry;
    
    
    /*--------------------------------------
     * 
     * SERVICE LIFE CYCLE METHODS 
     * 
     *--------------------------------------*/
    

    public void init(ServiceContext context) throws SystemException {
        serviceRegistry = context.getParentRegistry();
    }

    public void start() {
        cepService = serviceRegistry.getServiceInstance(CEPService.class);
        if (cepService == null) {
            log.info("No CEP Service found for Poker. Events will not be reported.");
        }
    }

    public void stop() {}
    
    public void destroy() {}

   
   
    /*--------------------------------------
     * 
     * BUSINESS LOGIC IMPLEMENTATION
     * 
     *--------------------------------------*/
    
    /**
     * Report a hand result for a single player as an event.
     * 
     */
    public void reportHandResult(int tableId, PokerPlayer player, long amount) {
        if (cepAvailable()) {
            // FIXME: Dummy rake calculation here (5%)
            double rake = Math.abs((100 * amount) * 0.05);
            
            Event event = new Event(EventType.TABLE.name());
            event.setSubtype(EventSubType.HAND_RESULT.name());
            event.setUser(new Long(player.getId()));
            event.setAmount(new Long(amount));
            event.setOperator(new Long(1));
            event.setRake(new Long(Math.round(rake)));
            event.setContext(new Long(tableId));
            
            cepService.reportEvent(event);
        }
    }

    
    /**
     * Report that a hand ended at a table with the given id and currency.
     * 
     */
    public void reportHandEnd(int tableId, EventMontaryType monetaryType) {
    	if (!cepAvailable()) return; // SANITY CHECK !!!
    	
        EventSubType subType;
        
        switch (monetaryType) {
            case REAL_MONEY: 
                subType = EventSubType.REAL_MONEY;
                break;
            case PLAY_MONEY: 
                subType = EventSubType.PLAY_MONEY;
                break;
            case TOURNAMENT: 
                subType = EventSubType.TOURNAMENT;
                break;
            default:
                subType = EventSubType.PLAY_MONEY;
                    
        }
        
        Event event = new Event(EventType.HAND_COMPLETE.name());
        event.setSubtype(subType.name());
        event.setContext(new Long(tableId));
        
        cepService.reportEvent(event);
    }
    
    
    /*--------------------------------------
     * 
     * PRIVATE METHODS
     * 
     *--------------------------------------*/
    
    private boolean cepAvailable() {
        return cepService != null;
    }
}
