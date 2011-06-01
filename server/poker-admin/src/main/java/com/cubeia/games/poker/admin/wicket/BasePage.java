package com.cubeia.games.poker.admin.wicket;

import org.apache.wicket.behavior.HeaderContributor;
import org.apache.wicket.markup.html.WebPage;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.model.Model;

public abstract class BasePage extends WebPage {
	
	public BasePage() {
		add(new MenuPanel("menuPanel", this.getClass()));
		add(HeaderContributor.forCss(BasePage.class, "style.css"));
		
		// defer setting the title model object as the title may not be generated now
		add(new Label("title", new Model()));
	}
	
	@Override
	protected void onBeforeRender() {
	    super.onBeforeRender();
	    
	    get("title").setModelObject(getPageTitle());
	}
	
	public abstract String getPageTitle();
}
