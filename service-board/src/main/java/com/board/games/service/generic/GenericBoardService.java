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
package com.board.games.service.generic;

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
public class GenericBoardService implements BoardService{

	@Override
	public PlayerProfile getUserProfile(int userId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public long getUserBalance(int userId) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void resetUserBalance(int id, int balance) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertUserBalance(int id) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void init(ServiceContext con) throws SystemException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public ClientServiceAction onAction(ServiceAction action) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public LoginHandler locateLoginHandler(LoginRequestAction request) {
		// TODO Auto-generated method stub
		return null;
	}

	
}
