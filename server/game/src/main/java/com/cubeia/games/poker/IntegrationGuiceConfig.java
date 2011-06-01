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

import org.apache.log4j.Logger;

import com.cubeia.firebase.api.game.GameProcessor;
import com.cubeia.firebase.api.game.TournamentProcessor;
import com.cubeia.firebase.api.game.table.TableInterceptor;
import com.cubeia.firebase.api.game.table.TableListener;
import com.cubeia.firebase.guice.game.ConfigurationAdapter;
import com.cubeia.poker.PokerState;

public class IntegrationGuiceConfig extends ConfigurationAdapter {


	private static transient Logger log = Logger.getLogger(IntegrationGuiceConfig.class);
	
	@Override
	public Class<? extends GameProcessor> getGameProcessorClass() {
		return Processor.class;
	}

	@Override
	public Class<? extends TableListener> getTableListenerClass() {
		log.warn("Guice Config - getTableListenerClass");
		return PokerTableListener.class;
	}

	@Override
	public Class<?> getGameStateClass() {
		return PokerState.class;
	}

	@Override
	public Class<? extends TableInterceptor> getTableInterceptorClass() {
		return PokerTableInterceptor.class;
	}

	@Override
	public Class<? extends TournamentProcessor> getTournamentProcessorClass() {
		return Processor.class;
	}
}
