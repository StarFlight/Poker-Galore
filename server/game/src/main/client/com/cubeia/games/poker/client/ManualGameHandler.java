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

package com.cubeia.games.poker.client;

import com.cubeia.firebase.clients.java.connector.text.IOContext;
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
import com.cubeia.games.poker.io.protocol.PlayerState;
import com.cubeia.games.poker.io.protocol.Pot;
import com.cubeia.games.poker.io.protocol.RequestAction;
import com.cubeia.games.poker.io.protocol.StartHandHistory;
import com.cubeia.games.poker.io.protocol.StartNewHand;
import com.cubeia.games.poker.io.protocol.StopHandHistory;
import com.cubeia.games.poker.io.protocol.TournamentOut;

public class ManualGameHandler implements PacketVisitor {

	private final IOContext context;
	
	public ManualGameHandler(IOContext context) {
		this.context = context;
	}

	public void visit(DealerButton packet) {
		System.out.println("Player["+packet.seat+"] is dealer");
	}
	
	public void visit(DealPublicCards packet) {
		System.out.println("Public cards dealt: "+packet.cards);
	}

	public void visit(DealPrivateCards packet) {
		System.out.println("I was dealt: "+packet.cards);
	}

	public void visit(DealHiddenCards packet) {
		System.out.println("Hidden cards dealt: "+packet.count+" cards");
	}

	public void visit(StartNewHand packet) {
		System.out.println("Start a new hand. Dealer: "+packet.dealer);
	}

	public void visit(ExposePrivateCards packet) {
		System.out.println("Player "+packet.player+" shows: "+packet.cards);
	}

	public void visit(HandEnd packet) {
		String out = "\nHand over. Hands:\n";
		for (BestHand hand : packet.hands) {
			out += "\t"+hand.player +" - "+hand.name+" ("+hand.rank+")\n";
		}
		System.out.println(out);
	}
	
	public void visit(RequestAction packet) {
		if (packet.player == context.getPlayerId()) {
			System.out.println("I was requested to do something: "+packet.allowedActions);
			PokerTextClient.seq = packet.seq;
		} else {
			System.out.println("Player["+packet.player+"] was requested to act.");
		}
	}
	
	public void visit(PerformAction packet) {
		if (packet.player == context.getPlayerId()) {
			// System.out.println("I acted with: "+packet.action.type.name()+"  bet: "+packet.bet);
		} else {
			System.out.println("Player["+packet.player+"] acted: "+packet.action.type.name()+"  bet: "+packet.betAmount);
		}
	}
	
	public void visit(StartHandHistory packet) {
        System.out.println("-- Start History");
    }

    public void visit(StopHandHistory packet) {
        System.out.println("-- Stop History");
    }
	
    public void visit(TournamentOut packet) {
        System.out.println("Player: "+packet.player+" was out of tournament");
    }
    
    public void visit(PlayerBalance packet) {
        System.out.println("I got balance: "+packet.balance);
    }
    
	public void visit(GameCard packet) {}
	public void visit(BestHand packet) {}
	public void visit(PlayerState packet) {}
	public void visit(PlayerAction packet) {}
    public void visit(Pot packet) {}
	@Override
	public void visit(PlayerSitinRequest packet) {}

	@Override
	public void visit(PlayerPokerStatus packet) {
		if (packet.player == context.getPlayerId()) {
			System.out.println("My status has changed to: "+packet.status);
		} else {
			System.out.println("Player["+packet.player+"]'s status has changed to: "+packet.status);
		}
	}
    
}
