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

import com.cubeia.firebase.api.game.TournamentProcessor;
import com.cubeia.firebase.api.game.table.TournamentTableListener;
import com.cubeia.firebase.guice.game.EventScoped;
import com.cubeia.games.poker.adapter.FirebaseServerAdapter;
import com.cubeia.games.poker.cache.ActionCache;
import com.cubeia.games.poker.handler.PokerHandler;
import com.google.inject.AbstractModule;

public class IntegrationGuiceModule extends AbstractModule {

	@Override
	protected void configure() {
		 bind(ActionCache.class).in(EventScoped.class);
		 bind(StateInjector.class);
		 bind(FirebaseServerAdapter.class).in(EventScoped.class);
		 bind(PokerHandler.class).in(EventScoped.class);
		 bind(TournamentProcessor.class).to(Processor.class);
		 bind(TournamentTableListener.class).to(PokerTableListener.class);
	}

}
