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

import com.board.games.model.PlayerProfile;
import com.board.games.service.ipb.IPBBoardService;
import com.cubeia.firebase.api.action.local.LoginRequestAction;
import com.cubeia.firebase.api.action.service.ClientServiceAction;
import com.cubeia.firebase.api.action.service.ServiceAction;
import com.cubeia.firebase.api.login.LoginHandler;
import com.cubeia.firebase.api.server.SystemException;
import com.cubeia.firebase.api.service.ServiceContext;
import com.google.inject.Inject;
import com.google.inject.Singleton;
@Singleton
public class Board {

	private Logger log = Logger.getLogger(Board.class);
	protected BoardService boardService;
	@Inject
	public Board(BoardService boardService) {
		log.debug("Inside inject");
		this.boardService = boardService;
	}	

	public void initialize(ServiceContext con) throws SystemException {
		log.debug("Inside initialize");
		boardService.init(con);
	}

	public ClientServiceAction process(ServiceAction action) {
		log.debug("Inside process");
		return boardService.onAction(action);
	}

	public PlayerProfile getUserInfo(int userId) throws Exception {
		return boardService.getUserProfile(userId);
	}

	public long getAccountBalance(int userId) throws Exception {
		return boardService.getUserBalance(userId);
	}

	public void updateAccountBalance(int id, int balance) throws Exception {
		boardService.resetUserBalance(id, balance);
	}

	public void createAccountBalance(int id) throws Exception {
		boardService.insertUserBalance(id);

	}

	public LoginHandler getLoginHandler(LoginRequestAction request) {
		return boardService.locateLoginHandler(request);
	}
}