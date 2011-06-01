package com.cubeia.games.poker.admin.wicket;

import org.apache.wicket.PageParameters;

/**
 * Homepage
 */
public class HomePage extends BasePage {

	private static final long serialVersionUID = 1L;

	// TODO Add any page properties or variables here
	
	

    /**
	 * Constructor that is invoked when page is invoked without a session.
	 * 
	 * @param parameters
	 *            Page parameters
	 */
    public HomePage(final PageParameters parameters) {
    	
    }

    @Override
    public String getPageTitle() {
       return "Home";
    }
}
