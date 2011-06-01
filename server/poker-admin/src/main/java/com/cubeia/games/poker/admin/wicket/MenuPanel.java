package com.cubeia.games.poker.admin.wicket;

import org.apache.wicket.AttributeModifier;
import org.apache.wicket.Page;
import org.apache.wicket.PageParameters;
import org.apache.wicket.markup.html.link.BookmarkablePageLink;
import org.apache.wicket.markup.html.panel.Panel;
import org.apache.wicket.model.Model;

import com.cubeia.games.poker.admin.wicket.jmx.Clients;
import com.cubeia.games.poker.admin.wicket.tournament.CreateSitAndGo;
import com.cubeia.games.poker.admin.wicket.tournament.EditTournament;

public class MenuPanel extends Panel {
    private static final long serialVersionUID = 1L;
    
	public MenuPanel(String id, Class<? extends BasePage> currentPageClass) {
		super(id);
        add(createPageLink("home", HomePage.class, currentPageClass));
        add(createPageLink("tournaments", Tournaments.class, currentPageClass));
        add(createPageLink("editTournament", EditTournament.class, currentPageClass, new PageParameters("tournamentId=1")));
        add(createPageLink("createSitAndGo", CreateSitAndGo.class, currentPageClass));
        add(createPageLink("clients", Clients.class, currentPageClass));
	}
	
	private BookmarkablePageLink createPageLink(
        String id, 
        Class<? extends Page> pageClass, 
        Class<? extends BasePage> currentPageClass) {
	    
	    BookmarkablePageLink link = new BookmarkablePageLink(id, pageClass);
	    if (pageClass.equals(currentPageClass)) {
	        link.add(new AttributeModifier("class", true, new Model("currentMenuItem")));
	    }
	    
        return link;
	}
	
	private BookmarkablePageLink createPageLink(
	        String id, 
	        Class<? extends Page> pageClass, 
	        Class<? extends BasePage> currentPageClass,
	        PageParameters params) {
	        
	        BookmarkablePageLink link = new BookmarkablePageLink(id, pageClass, params);
	        if (pageClass.equals(currentPageClass)) {
	            link.add(new AttributeModifier("class", true, new Model("currentMenuItem")));
	        }
	        
	        return link;
	    }
}
