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

package com.cubeia.games.poker;
import java.util.Collections;
import java.util.List;
import org.apache.log4j.Logger;

import com.cubeia.backoffice.users.api.dto.User;
import com.cubeia.firebase.api.game.context.GameContext;
import com.cubeia.firebase.api.game.table.ExtendedDetailsProvider;
import com.cubeia.firebase.api.game.table.Table;
import com.cubeia.firebase.api.server.SystemException;
import com.cubeia.firebase.api.service.ServiceRegistry;
import com.cubeia.firebase.api.util.ParameterUtil;
import com.cubeia.firebase.guice.game.Configuration;
import com.cubeia.firebase.guice.game.GuiceGame;
import com.cubeia.firebase.io.protocol.Param;
import com.cubeia.games.poker.jmx.PokerStats;
import com.cubeia.network.users.firebase.api.UserServiceContract;
import com.board.games.service.PokerBoardServiceContract;
import com.google.inject.Module;

public class PokerGame extends GuiceGame implements ExtendedDetailsProvider {
    	
    public final static int POKER_GAME_ID = 7;
    
    // FIXME: Hardcoded licensee id
    public static final int LICENSEE_ID = "Cubeia".hashCode();

	// FIXME: Hardcoded currency code here, this will vary depending on game type and deployment of course
	public static String CURRENCY_CODE = "EUR";
	public static final int CURRENCY_FRACTIONAL_DIGITS = 2;
    
    private static ServiceRegistry services;

    private static PokerBoardServiceContract pokerBoardServiceContract;
    
    public static PokerBoardServiceContract getPokerBoardServiceContract() {
		return pokerBoardServiceContract;
	}


	//    private static ApplicationContext applicationContext;
	private static transient Logger log = Logger
	.getLogger(PokerGame.class);

    
	/*------------------------------------------------
	 
		LIFECYCLE METHODS

		The constructor and methods will be called 
		by Firebase which manages the life cycle of
		the Game.
		
	 ------------------------------------------------*/
	public PokerGame() {
	    // Trigger poker stats creation and binding to JMX
	    PokerStats.getInstance();
	    log.debug("Inside poker game instantiation");
	}
	



	public void init(GameContext con) throws SystemException {
    	super.init(con);
    	log.debug("Inside init of pokergame");
        services = con.getServices();
        pokerBoardServiceContract = services.getServiceInstance(PokerBoardServiceContract.class);
		   if (pokerBoardServiceContract == null) {
			   log.debug("Could not find pokerBoardServiceContract class ");
		   }
        
    }
	
	 public void destroy() {}
	 
	 
	/*------------------------------------------------
	 
		GUICE IoC METHODS
		
		Adapter methods for Guice support.

	 ------------------------------------------------*/
	
	 @Override
	 public Configuration getConfigurationHelp() {
		 return new IntegrationGuiceConfig();
	 }

	 @Override
	 protected void preInjectorCreation(List<Module> modules) {
		 modules.add(new IntegrationGuiceModule());
	 }
     
	 /*------------------------------------------------
 	  
 	 	END OF GUICE IoC METHODS
 	 
 	 ------------------------------------------------*/
	
    
	
	@Override
	public List<Param> getExtendedDetails(Table table, int playerId, boolean fromLobby) {
		if (true) {
			// FIXME: Getting classnotfound on UserService
			return Collections.emptyList();
		}
		
		UserServiceContract serv = services.getServiceInstance(UserServiceContract.class);
		User user = serv.getUserById(playerId);
		String externalId = user.getExternalUserId();
		if(externalId != null) {
			Param param = ParameterUtil.createParam("externalId", externalId);
			return Collections.singletonList(param);
		} else {
			return Collections.emptyList();
		}
	}
    
}
