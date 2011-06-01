package com.cubeia.games.poker.admin.wicket;

import org.apache.wicket.protocol.http.WebApplication;
import org.apache.wicket.spring.injection.annot.SpringComponentInjector;

public class WebApp extends WebApplication {

	/** Constructor */
    public WebApp() {
    	
    }
    
    @Override
    protected void init() {
    	super.init();
    	addComponentInstantiationListener(new SpringComponentInjector(this));
    }

    /**
     * @see org.apache.wicket.Application#getHomePage()
     */
    public Class<?> getHomePage() {
        return HomePage.class;
    }
}
