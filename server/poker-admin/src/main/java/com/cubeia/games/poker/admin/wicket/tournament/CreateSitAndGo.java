package com.cubeia.games.poker.admin.wicket.tournament;

import org.apache.log4j.Logger;
import org.apache.wicket.PageParameters;
import org.apache.wicket.markup.html.form.Form;
import org.apache.wicket.markup.html.form.RequiredTextField;
import org.apache.wicket.markup.html.panel.FeedbackPanel;
import org.apache.wicket.model.PropertyModel;
import org.apache.wicket.spring.injection.annot.SpringBean;

import com.cubeia.games.poker.admin.db.AdminDAO;
import com.cubeia.games.poker.admin.wicket.BasePage;
import com.cubeia.games.poker.persistence.tournament.model.TournamentConfiguration;

public class CreateSitAndGo extends BasePage {

    private static final transient Logger log = Logger.getLogger(CreateSitAndGo.class);
    
    @SpringBean(name="abstractDAO")
    private AdminDAO abstractDAO;
    
    private TournamentConfiguration tournament;
    
    public CreateSitAndGo(final PageParameters parameters) {
        resetFormData();
        
        Form tournamentForm = new Form("tournamentForm") {
            private static final long serialVersionUID = 1L;
            
            @Override
            protected void validate() {
                super.validate();
            }
            
            @Override
            protected void onSubmit() {
                abstractDAO.persist(tournament);
                log.debug("created tournament config with id = " + tournament);
            }
        };
        
        tournamentForm.add(new RequiredTextField("name", new PropertyModel(this, "tournament.name")));
        tournamentForm.add(new RequiredTextField("seatsPerTable", new PropertyModel(this, "tournament.seatsPerTable")));
        tournamentForm.add(new RequiredTextField("timingType", new PropertyModel(this, "tournament.timingType")));
        tournamentForm.add(new RequiredTextField("minPlayers", new PropertyModel(this, "tournament.minPlayers")));
        tournamentForm.add(new RequiredTextField("maxPlayers", new PropertyModel(this, "tournament.maxPlayers")));
        
        
        add(tournamentForm);
        add(new FeedbackPanel("feedback"));
    }
    
    private void resetFormData() {
        tournament = new TournamentConfiguration();
    }


    @Override
    public String getPageTitle() {
        return "Create Sit-And-Go Tournament";
    }

}
