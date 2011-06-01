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
package com.board.games.service;

import org.apache.log4j.Logger;

import com.board.games.handler.generic.GenericLoginHandler;
import com.board.games.model.PlayerProfile;
import com.cubeia.firebase.api.action.local.LoginRequestAction;
import com.cubeia.firebase.api.action.service.ClientServiceAction;
import com.cubeia.firebase.api.action.service.ServiceAction;
import com.cubeia.firebase.api.login.LoginHandler;
import com.cubeia.firebase.api.login.LoginLocator;
import com.cubeia.firebase.api.server.SystemException;
import com.cubeia.firebase.api.service.Service;
import com.cubeia.firebase.api.service.ServiceContext;
import com.cubeia.firebase.api.service.ServiceRegistry;
import com.cubeia.firebase.api.service.ServiceRouter;
import com.google.inject.Guice;
import com.google.inject.Injector;

public class PokerBoardService implements LoginLocator, Service, PokerBoardServiceContract {

	private GenericLoginHandler handler = new GenericLoginHandler();
	
	private BoardService boardService;

	private ServiceRouter router;
	
	private Injector injector = null;
	private Board board = null;
	
	
	private Logger log = Logger.getLogger(PokerBoardService.class);

	
	public PokerBoardService() {
		try {
			injector = Guice.createInjector(new BoardModule());
			board = injector.getInstance(Board.class);
		} catch (Exception e) {
			log.error("Exception in init " + e.toString());
		}
	}
	
	@Override
	public void init(ServiceContext con) throws SystemException {
		try {
			board.initialize(con);
		} catch (Exception e) {
			log.error("Exception occurred in init : " + e.toString());
		}
	}

	
	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

	@Override
	public void start() {
		// TODO Auto-generated method stub

	}

	@Override
	public void stop() {
		// TODO Auto-generated method stub

	}

	@Override
	public void setRouter(ServiceRouter router) {
		this.router = router;
	}
	
	
	@Override
	public void onAction(ServiceAction e) {
		ClientServiceAction dataToClient = board.process(e);
		if (dataToClient != null) {
		// dispatch data
		router.dispatchToPlayer(e.getPlayerId(), dataToClient);
		} else {
			log.debug("onAction : dataToclient is null");
		}

	}

	@Override
	public void init(ServiceRegistry serviceRegistry) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public LoginHandler locateLoginHandler(LoginRequestAction request) {
		return board.getLoginHandler(request);
		//return handler;
	}

	@Override
	public PlayerProfile getUserProfile(int userId) throws Exception {
		return board.getUserInfo(userId);
	}

	@Override
	public long getUserBalance(int userId) throws Exception {
		return board.getAccountBalance(userId);	
	}

	@Override
	public void resetUserBalance(int id, int balance) throws Exception {
		board.updateAccountBalance(id, balance);
		
	}

	@Override
	public void insertUserBalance(int id) throws Exception {
		boardService.insertUserBalance(id);
		
	}

}
