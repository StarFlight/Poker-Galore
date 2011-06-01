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
import com.cubeia.firebase.api.service.Contract;
import com.cubeia.firebase.api.service.RoutableService;

public interface PokerBoardServiceContract extends Contract,RoutableService  { 
	
	 public PlayerProfile getUserProfile(int userId) throws Exception;
	 public long getUserBalance(int userId)  throws Exception;
	 public void resetUserBalance(int id, int balance) throws Exception;
	 public void insertUserBalance(int id) throws Exception;	
	
} 