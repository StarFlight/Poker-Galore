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

import java.io.File;
import java.io.IOException;

import org.apache.log4j.Logger;
import org.ini4j.Ini;

import com.board.games.service.generic.GenericBoardService;
import com.board.games.service.ipb.IPBBoardService;
import com.google.inject.AbstractModule;

public class BoardModule extends AbstractModule {
	
	private Logger log = Logger.getLogger(BoardModule.class);
	
	@Override
	protected void configure() {
		try {
			Ini ini = new Ini(new File("PokerConfig.ini"));
			String boardType = ini.get("PokerConfig", "boardType");
			log.debug("configure for board type " + boardType);
			//if (boardType.equals("IPB") || boardType.equals("1")) {
				bind(BoardService.class).to(IPBBoardService.class);
			//} else {
				//bind(BoardService.class).to(GenericBoardService.class);
			//}
		} catch (IOException ioe) {
			log.error("Exception in init " + ioe.toString());
		} catch (Exception e) {
			log.error("Exception in init " + e.toString());
		}
	}
}
