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

import com.board.games.model.PlayerProfile;
import com.cubeia.firebase.api.action.local.LoginRequestAction;
import com.cubeia.firebase.api.action.service.ClientServiceAction;
import com.cubeia.firebase.api.action.service.ServiceAction;
import com.cubeia.firebase.api.login.LoginHandler;
import com.cubeia.firebase.api.server.SystemException;
import com.cubeia.firebase.api.service.ServiceContext;

public interface BoardService {
	
	 public void init(ServiceContext con) throws SystemException;
	 public ClientServiceAction onAction(ServiceAction action);
	 
	 public PlayerProfile getUserProfile(int userId) throws Exception;
	 public long getUserBalance(int userId)  throws Exception;
	 public void resetUserBalance(int id, int balance) throws Exception;
	 public void insertUserBalance(int id) throws Exception;
	 
	 public LoginHandler locateLoginHandler(LoginRequestAction request);
	 
}
