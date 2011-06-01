package com.cubeia.games.poker.admin.wicket.tournament;

import org.apache.wicket.PageParameters;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.form.Form;
import org.apache.wicket.markup.html.panel.FeedbackPanel;
import org.apache.wicket.model.PropertyModel;
import org.apache.wicket.spring.injection.annot.SpringBean;

import com.cubeia.games.poker.admin.db.AdminDAO;
import com.cubeia.games.poker.admin.wicket.BasePage;
import com.cubeia.games.poker.persistence.tournament.model.TournamentConfiguration;

public class EditTournament extends BasePage {

    @SpringBean(name="abstractDAO")
    private AdminDAO abstractDAO;
    
    @SuppressWarnings("unused")
    private TournamentConfiguration tournament;
    
    public EditTournament(final PageParameters parameters) {
        final Integer tournamentId = parameters.getInt("tournamentId");
        
        System.out.println(".... tournamnet id: "+tournamentId);
        
        loadFormData(tournamentId);
        
        Form tournamentForm = new Form("tournamentForm") {
            private static final long serialVersionUID = 1L;
            @Override
            protected void onSubmit() {
                // TODO: Update tournament configuration here
                info("Tournament updated, id = " + tournamentId);
                loadFormData(tournamentId);
            }
        };
        
        tournamentForm.add(new Label("id", new PropertyModel(this, "tournament.id")));
        tournamentForm.add(new Label("name", new PropertyModel(this, "tournament.name")));
        tournamentForm.add(new Label("seatsPerTable", new PropertyModel(this, "tournament.seatsPerTable")));
        tournamentForm.add(new Label("timingType", new PropertyModel(this, "tournament.timingType")));
        tournamentForm.add(new Label("minPlayers", new PropertyModel(this, "tournament.minPlayers")));
        tournamentForm.add(new Label("maxPlayers", new PropertyModel(this, "tournament.maxPlayers")));
        
        add(tournamentForm);
        add(new FeedbackPanel("feedback"));
    }

    private void loadFormData(final Integer tournamentId) {
        tournament = abstractDAO.getItem(TournamentConfiguration.class, tournamentId);
    }
    
    @Override
    public String getPageTitle() {
        return "Edit Tournament";
    }

}
