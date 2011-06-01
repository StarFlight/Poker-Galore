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

package com.cubeia.games.poker.handler;

import com.cubeia.games.poker.io.protocol.BestHand;
import com.cubeia.games.poker.io.protocol.DealHiddenCards;
import com.cubeia.games.poker.io.protocol.DealPrivateCards;
import com.cubeia.games.poker.io.protocol.DealPublicCards;
import com.cubeia.games.poker.io.protocol.DealerButton;
import com.cubeia.games.poker.io.protocol.ExposePrivateCards;
import com.cubeia.games.poker.io.protocol.GameCard;
import com.cubeia.games.poker.io.protocol.HandEnd;
import com.cubeia.games.poker.io.protocol.PacketVisitor;
import com.cubeia.games.poker.io.protocol.PerformAction;
import com.cubeia.games.poker.io.protocol.PlayerAction;
import com.cubeia.games.poker.io.protocol.PlayerBalance;
import com.cubeia.games.poker.io.protocol.PlayerPokerStatus;
import com.cubeia.games.poker.io.protocol.PlayerSitinRequest;
import com.cubeia.games.poker.io.protocol.PlayerSitoutRequest;
import com.cubeia.games.poker.io.protocol.PlayerState;
import com.cubeia.games.poker.io.protocol.Pot;
import com.cubeia.games.poker.io.protocol.RequestAction;
import com.cubeia.games.poker.io.protocol.StartHandHistory;
import com.cubeia.games.poker.io.protocol.StartNewHand;
import com.cubeia.games.poker.io.protocol.StopHandHistory;
import com.cubeia.games.poker.io.protocol.TournamentOut;

public class DefaultPokerHandler implements PacketVisitor {
	
	public void visit(PerformAction packet) {}
	
	// -----  TO CLIENTS
	@Override
	public void visit(GameCard packet) {}
	@Override
	public void visit(DealPublicCards packet) {}
	@Override
	public void visit(DealPrivateCards packet) {}
	@Override
	public void visit(DealHiddenCards packet) {}
	@Override
	public void visit(StartNewHand packet) {}
	@Override
	public void visit(ExposePrivateCards packet) {}
	@Override
	public void visit(HandEnd packet) {}
	@Override
	public void visit(BestHand packet) {}
	@Override
	public void visit(PlayerState packet) {}
	@Override
	public void visit(PlayerAction packet) {}
	@Override
	public void visit(RequestAction packet) {}
	@Override
	public void visit(DealerButton packet) {}
	@Override
    public void visit(StartHandHistory packet) {}
    @Override
    public void visit(StopHandHistory packet) {}
    @Override
    public void visit(TournamentOut packet) {}
    @Override
	public void visit(PlayerBalance packet) {}
    @Override
    public void visit(Pot packet) {}
	@Override
	public void visit(PlayerSitinRequest packet) {}
	@Override
	public void visit(PlayerPokerStatus packet) {}
	@Override
	public void visit(PlayerSitoutRequest packet) {}
}
