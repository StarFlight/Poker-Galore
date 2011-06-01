package com.cubeia.games.poker.admin.wicket.jmx;

import java.io.Serializable;

import org.apache.log4j.Logger;
import org.apache.wicket.PageParameters;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.form.Form;
import org.apache.wicket.markup.html.form.RequiredTextField;
import org.apache.wicket.markup.html.panel.FeedbackPanel;
import org.apache.wicket.model.PropertyModel;

import com.cubeia.firebase.service.clientreg.state.StateClientRegistryMBean;
import com.cubeia.games.poker.admin.jmx.FirebaseJMXFactory;
import com.cubeia.games.poker.admin.wicket.BasePage;

public class Clients extends BasePage {
    private static final transient Logger log = Logger.getLogger(Clients.class);
    
    private String message;

    private transient StateClientRegistryMBean mbeanProxy;
    
    public Clients(final PageParameters parameters) {
        FirebaseJMXFactory jmxFactory = new FirebaseJMXFactory();
        mbeanProxy = jmxFactory.createClientRegistryProxy();

        add(new FeedbackPanel("feedback"));
        
        // Total number of clients online
        ClientCounter counter = new ClientCounter();
        Label clientsOnline = new Label("clientsOnline", new PropertyModel(counter, "clients")); 
        
        try {
            counter.setClients(mbeanProxy.getNumberOfClients());
        } catch (Exception e) {
            log.warn("error calling jmx server", e);
            counter.setClients(-1);
            error("unable to contact jmx server: " + e.getMessage());
        }
        
        add(clientsOnline);
        
        // Send message form
        Form systemMessageForm = new Form("systemMessageForm") {
            private static final long serialVersionUID = 1L;
            
            @Override
            protected void validate() {
                super.validate();
            }
            
            @Override
            protected void onSubmit() {
                sendSystemMessage(message);
            }
        };
        
        systemMessageForm.add(new RequiredTextField("message", new PropertyModel(this, "message")));
        add(systemMessageForm);
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    private void sendSystemMessage(String message) {
        mbeanProxy.sendSystemMessage(0, 0, message);
    }

    @Override
    public String getPageTitle() {
        return "Live Players";
    }
    
    private class ClientCounter implements Serializable {
        
        private static final long serialVersionUID = 1L;
        
        private int clients = 0;

        public int getClients() {
            return clients;
        }

        public void setClients(int clients) {
            this.clients = clients;
        }
        
    }

}
