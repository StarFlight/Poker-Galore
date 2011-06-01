package com.cubeia.games.poker.admin.db;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.orm.jpa.support.JpaDaoSupport;
import org.springframework.transaction.annotation.Transactional;

import com.cubeia.games.poker.persistence.tournament.model.TournamentConfiguration;


/**
 * Base class for handling persistence.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
@Transactional
public class AbstractDAO extends JpaDaoSupport implements AdminDAO {

    @SuppressWarnings("unused")
    private static transient Logger log = Logger.getLogger(AbstractDAO.class);

    public static boolean persist = true; 
    
    /* (non-Javadoc)
     * @see com.cubeia.games.poker.admin.db.AdminDAO#getItem(java.lang.Class, java.lang.Integer)
     */
    @SuppressWarnings("unchecked")
    public <T> T getItem(Class<TournamentConfiguration> class1, Integer id) {
        return (T) getJpaTemplate().find(class1, id);
    }
    
    /* (non-Javadoc)
     * @see com.cubeia.games.poker.admin.db.AdminDAO#persist(java.lang.Object)
     */
    public void persist(Object entity) {
        getJpaTemplate().persist(entity);
    }

    
    /* (non-Javadoc)
     * @see com.cubeia.games.poker.admin.db.AdminDAO#getAllTournaments()
     */
    @SuppressWarnings("unchecked")
    public List<TournamentConfiguration> getAllTournaments() {
        List<TournamentConfiguration> result = getJpaTemplate().find("from TournamentConfiguration");
        return result;
    }
    
}
