package com.cubeia.games.poker.admin.wicket;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.wicket.PageParameters;
import org.apache.wicket.extensions.markup.html.repeater.data.table.AbstractColumn;
import org.apache.wicket.extensions.markup.html.repeater.data.table.DefaultDataTable;
import org.apache.wicket.extensions.markup.html.repeater.data.table.ISortableDataProvider;
import org.apache.wicket.extensions.markup.html.repeater.data.table.PropertyColumn;
import org.apache.wicket.extensions.markup.html.repeater.util.SortableDataProvider;
import org.apache.wicket.model.IModel;
import org.apache.wicket.model.Model;
import org.apache.wicket.spring.injection.annot.SpringBean;

import com.cubeia.games.poker.admin.db.AdminDAO;
import com.cubeia.games.poker.persistence.tournament.model.TournamentConfiguration;

/**
 * Homepage
 */
public class Tournaments extends BasePage {

	private static final long serialVersionUID = 1L;

	@SpringBean(name="abstractDAO")
	private AdminDAO abstractDAO;
	
    /**
	 * Constructor that is invoked when page is invoked without a session.
	 * 
	 * @param parameters
	 *            Page parameters
	 */
    public Tournaments(final PageParameters parameters) {
        ISortableDataProvider dataProvider = new SortableDataProviderExtension();
        ArrayList<AbstractColumn> columns = new ArrayList<AbstractColumn>();
        
        columns.add(new PropertyColumn(new Model("id"), "id"));
        columns.add(new PropertyColumn(new Model("Name"), "name"));
        columns.add(new PropertyColumn(new Model("Seats"), "seatsPerTable"));
        columns.add(new PropertyColumn(new Model("Min"), "minPlayers"));
        columns.add(new PropertyColumn(new Model("Max"), "maxPlayers"));
        columns.add(new PropertyColumn(new Model("Start Type"), "startType"));

        DefaultDataTable userTable = new DefaultDataTable("tournamentTable", columns, dataProvider , 20);
        add(userTable);
    	
    }
    
    
    private List<TournamentConfiguration> getTournamentList() {
        return abstractDAO.getAllTournaments();
    }
    
    
    
    
    private final class SortableDataProviderExtension extends SortableDataProvider {
        private static final long serialVersionUID = 1L;
        
        public SortableDataProviderExtension() {
            setSort("id", true);
        }

        @SuppressWarnings("unchecked")
        @Override
        public Iterator iterator(int first, int count) {
            return getTournamentList().subList(first, count+first).iterator();
        }

        

        @Override
        public IModel model(Object object) {
            return new Model((Serializable) object);
        }

        @Override
        public int size() {
            return getTournamentList().size();
        }
    }




    @Override
    public String getPageTitle() {
        return "Tournaments";
    }
}
