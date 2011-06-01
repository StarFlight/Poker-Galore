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

package com.cubeia.poker.gametypes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.SortedMap;

import org.apache.log4j.Logger;

import ca.ualberta.cs.poker.Card;
import ca.ualberta.cs.poker.Deck;
import ca.ualberta.cs.poker.Hand;

import com.cubeia.poker.GameType;
import com.cubeia.poker.PokerState;
import com.cubeia.poker.action.ActionRequest;
import com.cubeia.poker.action.PokerAction;
import com.cubeia.poker.action.PokerActionType;
import com.cubeia.poker.adapter.HandEndStatus;
import com.cubeia.poker.adapter.ServerAdapter;
import com.cubeia.poker.model.PlayerHands;
import com.cubeia.poker.player.PokerPlayer;
import com.cubeia.poker.result.HandResult;
import com.cubeia.poker.result.Result;
import com.cubeia.poker.rounds.BettingRound;
import com.cubeia.poker.rounds.DealCommunityCardsRound;
import com.cubeia.poker.rounds.Round;
import com.cubeia.poker.rounds.RoundVisitor;
import com.cubeia.poker.rounds.blinds.BlindsInfo;
import com.cubeia.poker.rounds.blinds.BlindsRound;
import com.cubeia.poker.timing.Periods;
import com.cubeia.poker.util.HandResultCalculator;
import com.google.inject.Inject;

public class TexasHoldem implements GameType, RoundVisitor {

	private static final long serialVersionUID = -1523110440727681601L;

    private static transient Logger log = Logger.getLogger(TexasHoldem.class);

	private SortedMap<Integer, PokerPlayer> seatingMap;

	private Round currentRound;

	private Deck deck;

	private List<Card> communityCards = new ArrayList<Card>();

	private Map<Integer, PokerPlayer> playerMap = new HashMap<Integer, PokerPlayer>();

	/**
	 * 0 = pre flop 1 = flop 2 = turn 3 = river
	 */
	private int roundId;

	private BlindsInfo blindsInfo = new BlindsInfo();

	@Inject
	PokerState game;
	
	private Random random = new Random();
	
	private HandResultCalculator handResultCalculator = new HandResultCalculator();

	public String toString() {
	    return "TexasHoldem, current round["+currentRound+"] roundId["+roundId+"] ";
	}
	
	@Override
	public int getAnteLevel() {
		return game.getAnteLevel();
	}
	
	public void startHand(SortedMap<Integer, PokerPlayer> seatingMap,
			Map<Integer, PokerPlayer> playerMap) {
		this.seatingMap = seatingMap;
		this.playerMap = playerMap;
		initHand();
	}

	private void initHand() {				
		deck = new Deck(getRandom().nextInt());
		// FIXME: Use better seed for the shuffle
		deck.shuffle();
		currentRound = new BlindsRound(this, game.isTournamentTable());
		roundId = 0;
	}

	private Random getRandom() {
		return random;
	}

	public SortedMap<Integer, PokerPlayer> getSeatingMap() {
		return seatingMap;
	}

	public void act(PokerAction action) {
		currentRound.act(action);
		checkFinishedRound();
	}

	private void checkFinishedRound() {
		if (currentRound.isFinished()) {
			handleFinishedRound();
		}
	}

	private void dealPocketCards(PokerPlayer p, int n) {
		for (int i = 0; i < n; i++) {
			p.getPocketCards().addCard(deck.dealCard());
		}
		game.notifyPrivateCards(p.getId(), p.getPocketCards().getCards());
	}

	private void dealCommunityCards(int n) {
		List<Card> dealt = new LinkedList<Card>();
		for (int i = 0; i < n; i++) {
			dealt.add(deck.dealCard());
		}
		communityCards.addAll(dealt);
		game.notifyCommunityCards(dealt);
	}

	public List<Card> getCommunityCards() {
		return communityCards;
	}

	public PokerPlayer getPlayer(int playerId) {
		PokerPlayer pokerPlayer = playerMap.get(playerId);
		return pokerPlayer;
	}

	public Iterable<PokerPlayer> getPlayers() {
		return playerMap.values();
	}

	public void handleFinishedRound() {
		currentRound.visit(this);
	}
	
	private void reportPotUpdate() {
        game.updatePot();
    }

    /**
	 * Expose all pocket cards for players still in the hand
	 * i.e. not folded.
	 */
	private void exposeShowdownCards() {
        if (countNonFoldedPlayers() > 1) {
            for (PokerPlayer p : getSeatingMap().values()) {
                if (!p.hasFolded()) {
                	log.debug("exposing pocket cards for player #" + p.getId());
                    game.exposePrivateCards(p.getId(), p.getPocketCards().getCards());
                }
            }
        }
    }

    private void startBettingRound() {
    	log.trace("Starting new betting round. Round ID: "+(roundId+1));
		currentRound = new BettingRound(this, blindsInfo.getDealerButtonSeatId());
		roundId++;
	}
    
	private boolean isHandFinished() {
		return (roundId >= 3 || countNonFoldedPlayers() <= 1);
	}

	public int countNonFoldedPlayers() {
		int nonFolded = 0;
		for (PokerPlayer p : getSeatingMap().values()) {
			if (!p.hasFolded() && !p.isSittingOut()) {
				nonFolded++;
			}
		}

		return nonFolded;
	}
	
	public int countPlayersSittingIn() {
		int sittingIn = 0;
		for (PokerPlayer p : getSeatingMap().values()) {
			if (!p.isSittingOut()) {
				sittingIn++;
			}
		}

		return sittingIn;
	}	

	public void dealCommunityCards() {
		if (roundId == 0) {
			dealCommunityCards(3);
		} else {
			dealCommunityCards(1);
		}
	}

	private void handleFinishedHand(HandResult handResult) {	
		log.debug("Hand over. Result: "+handResult.getPlayerHands());
		game.notifyHandFinished(handResult, HandEndStatus.NORMAL);
	}
	
	private void handleCanceledHand() {
		game.notifyHandFinished(new HandResult(), HandEndStatus.CANCELED_TOO_FEW_PLAYERS);
	}	

	private HandResult createHandResult() {
		HandResult result = new HandResult();
		PlayerHands playerHands = createHandHolder();
		result.setPlayerHands(playerHands);
		log.debug("Inside createHandResult and call to set winner");
		// TODO
		// Add player winner flag here
		Map<PokerPlayer, Result> playerResults = handResultCalculator.getPlayerResults(result.getPlayerHands(), game.getPotHolder(), playerMap);
		result.setResults(playerResults);
		return result;
	}

	private PlayerHands createHandHolder() {
		PlayerHands holder = new PlayerHands();
		for (PokerPlayer player : playerMap.values()) {
			if (!player.hasFolded()) {
				Hand h = new Hand();
				h.addCards(player.getPocketCards().getCards());
				h.addCards(getCommunityCards());
				holder.addHand(player.getId(), h);
			}
		}

		return holder;
	}

	private void moveChipsToPot() {
		
		game.getPotHolder().moveChipsToPot(seatingMap.values());
		
		for (PokerPlayer p : seatingMap.values()) {
			p.setHasActed(false);
			p.clearActionRequest();
			p.commitBetStack();
		}
	}

	public void requestAction(ActionRequest r) {
		if (blindRequested(r) && game.isTournamentTable()) {
			game.getServerAdapter().scheduleTimeout(game.getTimingProfile().getTime(Periods.AUTO_POST_BLIND_DELAY));
		} else {
			game.requestAction(r);
		}
	}
	
	public void scheduleRoundTimeout() {
		log.debug("scheduleRoundTimeout in: "+ game.getTimingProfile().getTime(Periods.RIVER));
		game.getServerAdapter().scheduleTimeout(game.getTimingProfile().getTime(Periods.RIVER));
	}

	private boolean blindRequested(ActionRequest r) {
		return r.isOptionEnabled(PokerActionType.SMALL_BLIND) || r.isOptionEnabled(PokerActionType.BIG_BLIND);
	}

//	public void requestAction(PokerPlayer player,
//			PossibleAction ... possibleActions) {
//		ActionRequest actionRequest = new ActionRequest();
//		List<PossibleAction> options = new ArrayList<PossibleAction>();
//
//		for (PossibleAction action : possibleActions) {
//			options.add(action);
//		}
//
//		actionRequest.setOptions(options);
//		actionRequest.setPlayerId(player.getId());
//		player.setActionRequest(actionRequest);
//		logDebug("Requesting action " + actionRequest);
//		game.requestAction(actionRequest);
//	}

	public BlindsInfo getBlindsInfo() {
		return blindsInfo;
	}

	public void prepareNewHand() {
		communityCards.clear();
		for (PokerPlayer player : playerMap.values()) {
			player.clearHand();
			player.setHasFolded(false);
		}		
	}

	public void notifyDealerButton(int dealerButtonSeatId) {
		game.notifyDealerButton(dealerButtonSeatId);
	}

	public ServerAdapter getServerAdapter() {
		return game.getServerAdapter();
	}

	public void timeout() {
		log.debug("Timeout");
		currentRound.timeout();
		checkFinishedRound();
	}

	public PokerState getState() {
		return game;
	}

	public String getStateDescription() {
		return currentRound == null ? "th-round=null" : currentRound.getClass() + "_" + currentRound.getStateDescription();
	}

	public boolean isPlayerInHand(int playerId) {
		return playerMap.get(playerId) == null ? false : playerMap.get(playerId).isInHand();
	}

	public void visit(BettingRound bettingRound) {
		moveChipsToPot();
		reportPotUpdate();
		
		if (isHandFinished()) {
			log.debug("exposeShowdownCards");
		    exposeShowdownCards();
			handleFinishedHand(createHandResult());
			game.getPotHolder().clearPots();
		} else {
//			dealCommunityCards();
//			startBettingRound();
			
			// Start deal community cards round
			currentRound = new DealCommunityCardsRound(this);
			// Schedule timeout for the community cards round
			scheduleRoundTimeout();
		}		
	}

	public void visit(BlindsRound blindsRound) {
		if (blindsRound.isCanceled()) {
			handleCanceledHand();
		} else {
			updateBlindsInfo(blindsRound);
			dealPocketCards();
			prepareBettingRound();
		}
	}
	
	public void visit(DealCommunityCardsRound round) {
		startBettingRound();
	}

	private void prepareBettingRound() {
		int bbSeatId = blindsInfo.getBigBlindSeatId();
		currentRound = new BettingRound(this, bbSeatId);
	}

	private void updateBlindsInfo(BlindsRound blindsRound) {
		this.blindsInfo = blindsRound.getBlindsInfo();
	}

	private void dealPocketCards() {
		for (PokerPlayer p : seatingMap.values()) {
			if (!p.isSittingOut()) {
				dealPocketCards(p, 2);
			}
		}
	}

}
