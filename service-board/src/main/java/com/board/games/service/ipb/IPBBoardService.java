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
package com.board.games.service.ipb;

import java.io.UnsupportedEncodingException;
import java.util.StringTokenizer;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.board.games.dao.GenericDAO;
import com.board.games.handler.ipb.IPBPokerLoginServiceImpl;
import com.board.games.model.PlayerBalance;
import com.board.games.model.PlayerProfile;
import com.board.games.service.BoardService;
import com.cubeia.firebase.api.action.local.LoginRequestAction;
import com.cubeia.firebase.api.action.service.ClientServiceAction;
import com.cubeia.firebase.api.action.service.ServiceAction;
import com.cubeia.firebase.api.login.LoginHandler;
import com.cubeia.firebase.api.server.SystemException;
import com.cubeia.firebase.api.service.ServiceContext;
import com.google.inject.Singleton;

@Singleton
public class IPBBoardService implements BoardService {

	private IPBPokerLoginServiceImpl loginServiceImpl = new IPBPokerLoginServiceImpl();
	
	private Logger log = Logger.getLogger(IPBBoardService.class);
    private static ApplicationContext applicationContext;
    
	public static ApplicationContext getApplicationContext() {
		return applicationContext;
	}	
	
	public void init(ServiceContext con) throws SystemException { 
		log.debug("Service Initialized");
	    applicationContext = new FileSystemXmlApplicationContext("file:/usr/local/firebase/firebase-1.7.2-CE/game/deploy/beans.xml");
		
	}
	
	@Override
	public ClientServiceAction onAction(ServiceAction action) {
		log.debug("Inside onAction of IPBService : NEW multiple avatar query");
		try {
			// Assume the client sent an UTF-8 encoded string
			String stringDataFromClient = new String(action.getData(),"UTF-8");
			log.debug("Receiving request data from client " + stringDataFromClient);
			
			 StringTokenizer st=new StringTokenizer(stringDataFromClient,";");
			 int request =Integer.parseInt(st.nextToken());
			 String stringDataToClient = null;
			 PlayerProfile playerProfile = null;
			 String playerId = null;
			 switch (request) {
			 // may need here since client may send directly the current win after each hand or triggered on server in listener
			 case 1 :
				 int id =(new Integer(st.nextToken()));
				 int balance =(new Integer(st.nextToken()));
				log.debug("Saving player balance of " + balance + " for player #" + id);
				resetUserBalance(id, balance);
				stringDataToClient = "1;"+String.valueOf(id)+";"+"Saving balance of "+String.valueOf(balance);
				break;
				//FIXME: Refactoring to do
			 case 2 :
				 playerId =(new String(st.nextToken()));
					log.debug("Retrieving avatar info for user " + playerId);
					// need the user id to query player at lobby level to get their avatar if one set
					playerProfile= getUserProfile(Integer.parseInt(playerId));
					stringDataToClient = "2;"+playerId+";"+playerProfile.getAvatar_location(); 
					break;
			 case 3 :
				 String userList = "";
				 stringDataToClient = "3;";
				 //FIXME: to do one sql query later instead of  multiple : quick and dirty to quick test
				 while(st.hasMoreTokens()) {
					 playerId = (String) st.nextToken();
					 log.debug("Processing player #" + playerId);
					 playerProfile = getUserProfile(Integer.parseInt(playerId));
					 userList += playerId+";"+ playerProfile.getAvatar_location()+";"+playerProfile.getName();
					 if (st.hasMoreElements()) {
						 userList += ";";
					 }
				}
				log.debug("userList " + userList);
			    stringDataToClient = "3;"+userList;
				log.debug("stringDataFromClient " + stringDataFromClient);
				break;
			 case 4 :
				 playerId =(new String(st.nextToken()));
					log.debug("Set initial amount for user if none found " + playerId);
		    	   long moneyAmount = 0;
		    		   try {
						moneyAmount= getUserBalance(Integer.parseInt(playerId));
						if (moneyAmount == -1) {
							// balance not added , create default balance
							insertUserBalance(Integer.parseInt(playerId));
							moneyAmount= getUserBalance(Integer.parseInt(playerId));
						}
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					stringDataToClient = "4;"+playerId+";"+Long.toString(moneyAmount); 
					break;
			default:
				log.debug("Undefined request");
				break;
				 
			 }
			log.debug("sending data to client: " + stringDataToClient);
			// set up action with data to send to the client
			ClientServiceAction dataToClient;
			dataToClient = new ClientServiceAction(action.getPlayerId(), action.getSeq(), stringDataToClient.getBytes("UTF-8"));
			log.debug("data to client: " + dataToClient);
			return dataToClient;
		} catch (UnsupportedEncodingException use) {
			log.error("Error processing client data", use);
			
		} catch (Exception e) {
			log.error("Error processing client data", e);
		}
		return null;
	}
	
	
	@Override	
    public PlayerProfile getUserProfile(int userId) throws Exception
    {
       GenericDAO genericDAO = (GenericDAO) getApplicationContext().getBean("ipbDAO");
       PlayerProfile playerProfile = genericDAO.selectPlayerProfile(userId);
       log.debug("Avatar location " + playerProfile.getAvatar_location() + " Name " + playerProfile.getName());
       return playerProfile;
    }	
    	
	@Override	
    public long getUserBalance(int userId) throws Exception
    {
	    GenericDAO genericDAO = (GenericDAO) getApplicationContext().getBean("ipbDAO");
	    PlayerBalance playerBalance = genericDAO.getPlayerBalance(userId);
	    if (playerBalance == null) {
	    	return -1;
	    }
	    log.debug("Player balance " + playerBalance.getBalance());
	    return playerBalance.getBalance();
	}
 
	@Override	
	public void insertUserBalance(int id) throws Exception{
	    GenericDAO genericDAO = (GenericDAO) getApplicationContext().getBean("ipbDAO");
	    genericDAO.insertPlayerBalance(id);
	}
	    
    
	@Override	
	public void resetUserBalance(int id, int balance) throws Exception{
		// balance is already calculate from client so update as it
		PlayerBalance playerBalance = new PlayerBalance(id, balance);
	    GenericDAO genericDAO = (GenericDAO) getApplicationContext().getBean("ipbDAO");
	    genericDAO.updatePlayerBalance(playerBalance);
	}


	@Override
	public LoginHandler locateLoginHandler(LoginRequestAction req) {
		return loginServiceImpl;
	}
	    

	
}
