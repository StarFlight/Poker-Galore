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

package com.cubeia.games.poker.persistence;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;

import org.apache.log4j.Logger;

import com.cubeia.firebase.api.service.ServiceRegistry;
import com.cubeia.firebase.api.service.persistence.PublicPersistenceService;

/**
 * Base class for handling persistence.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class AbstractDAO {

    private static transient Logger log = Logger.getLogger(AbstractDAO.class);
    
    protected static boolean persist = true; 
    
    protected static Map<String, Boolean> persistCustom = new ConcurrentHashMap<String, Boolean>();
    
    protected EntityManager em;

    /**
     * Will use EntityManager named 'poker'.
     * @param registry
     */
    public AbstractDAO(ServiceRegistry registry) {
        if (persist) {
            PublicPersistenceService service = registry.getServiceInstance(PublicPersistenceService.class);
            em = service.getEntityManager("poker");
            if (em == null) {
                log.info("Will ignore persistence calls since no entity-manager was found for 'poker'.");
                persist = false;
            }
        }
    }
    
    /**
     * Will use specified EntityManager.
     * 
     * @param registry
     * @param entityManager
     */
    public AbstractDAO(ServiceRegistry registry, String entityManager) {
        if (!persistCustom.containsKey(entityManager) || persistCustom.get(entityManager).booleanValue()) {
            PublicPersistenceService service = registry.getServiceInstance(PublicPersistenceService.class);
            em = service.getEntityManager(entityManager);
            if (em == null) {
                log.info("Will ignore persistence calls since no entity-manager was found for '"+entityManager+"'.");
                persistCustom.put(entityManager, new Boolean(false));
            }
        }
    }

    public void persist(Object entity) {
        if (em != null) {
            EntityTransaction tx = null;
            try {
                tx = em.getTransaction();
                tx.begin();
                log.debug("OMG OMG OMG !!! Persist: "+entity);
                em.persist(entity);
                
                tx.commit();
                
            } catch (RuntimeException e) {
                if ( tx != null && tx.isActive() ) tx.rollback();
                throw e; // or display error message
                
            }  finally {
                em.close();
            }
        }
    }

}
