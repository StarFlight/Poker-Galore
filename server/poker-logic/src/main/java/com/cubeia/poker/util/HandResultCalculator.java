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

package com.cubeia.poker.util;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import ca.ualberta.cs.poker.Hand;
import ca.ualberta.cs.poker.HandEvaluator;

import com.cubeia.poker.model.PlayerHands;
import com.cubeia.poker.player.PokerPlayer;
import com.cubeia.poker.pot.Pot;
import com.cubeia.poker.pot.PotHolder;
import com.cubeia.poker.result.Result;

public class HandResultCalculator implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@SuppressWarnings("unused")
	private static Logger log = Logger.getLogger(HandResultCalculator.class);
	

	
	/**
	 * Gets a map mapping the results of each player.
	 * 
	 * The results are the winnings or losses in the hand.
	 * 
	 * For example, if player A, B and C bet $10 each and player C won, the results will be:
	 * A->-$10, B->-$10, C->$20
	 * 
	 * @param hands
	 * @param potHolder
	 * @return
	 */
	public Map<PokerPlayer, Result> getPlayerResults(PlayerHands hands, PotHolder potHolder, Map<Integer, PokerPlayer> playerMap) {
		Map<PokerPlayer, Result> results = new HashMap<PokerPlayer, Result>();
		
		// Player ID to Net result (including own bets)
		Map<Integer, Long> netResults = new HashMap<Integer, Long>();
		Map<Integer, Long> netStakes = new HashMap<Integer, Long>();
		
		/*
		 * For each pot we need to figure out:
		 * 
		 * 1. Participating players
		 * 2. Winner(s) of the participating players
		 * 3. Net winnings and net losses for the participating players
		 * 
		 * Net winnings and losses are aggregated over all pots since
		 * a player can participate in more than one pot.
		 * 
		 * Finally we construct a result DTO for each player and return them
		 * as a map.
		 */
		
		for ( Pot pot : potHolder.getPots() ) {
			// Get participating players
			Map<PokerPlayer, Long> participants = pot.getPotContributors();
			Map<PokerPlayer, Long> potContributors = pot.getPotContributors();
			
			List<Integer> participantIds = new ArrayList<Integer>();
			for (PokerPlayer player : participants.keySet()) {
				participantIds.add(player.getId());
			}
			
			
			log.debug("Calculate winnings for Pot: "+pot);
			log.debug("participants in this Pot: "+participantIds);
			
			// We need to remove all non-participants first
			PlayerHands filteredHands = hands.filter(participantIds);
			
			// Check if we have participant hands first, if the hand was canceled this may be empty
			if (filteredHands.getHands().size() > 0) {
			
				// --- WINNERS --- 
				List<Integer> winners = getWinners(filteredHands);
				
				long potSize = pot.getPotSize();
				long potShare = potSize / winners.size();
				
				// Report winner shares
				for (Integer winnerId : winners) {
					PokerPlayer player = playerMap.get(winnerId);
					//TODO NEW
					player.setHandWinnerFl(1);
					//TODO Notify winners here
					
					Long stake = potContributors.get(player);
					addResultBalance(netResults, netStakes, winnerId, potShare, stake);
					log.debug(" --- Add winner pot result: "+winnerId+" : "+potShare+" - "+stake+" = "+(potShare-stake));
				}
	
				
				// --- LOSERS ---
				// Report loser losses
				participantIds.removeAll(winners);
				for (Integer loserId : participantIds) {
					PokerPlayer player = playerMap.get(loserId);
					Long stake = pot.getPotContributors().get(player);
					addResultBalance(netResults, netStakes, loserId, 0l, stake);
					log.debug(" --- Add loser pot result: "+loserId+" : -"+stake);
				}
			}
		}
		
		
		// Create result DTO's for the net results over all Pots
		for (Integer playerId : playerMap.keySet()) {
			PokerPlayer player = playerMap.get(playerId);
			
			Long netResult = netResults.get(playerId);
			Long playerStake = netStakes.get(playerId);
			
			long netResultSafe = netResult == null ? 0 : netResult;
			long playerStakeSafe = playerStake == null ? 0 : playerStake;
			
			Result result = new Result(netResultSafe, playerStakeSafe);
			results.put(player, result);
		}
		
		return results;
	}

	
	private void addResultBalance(Map<Integer, Long> netResults, Map<Integer, Long> netStakes, Integer playerId, Long winnings, Long stake) {
		Long balance = netResults.get(playerId);
		if (balance == null) {
			netResults.put(playerId, winnings - stake);
		} else {
			netResults.put(playerId, balance + winnings - stake);
		}
		
		Long totalStake = netStakes.get(playerId);
		if (totalStake == null) {
			netStakes.put(playerId, stake);
		} else {
			netStakes.put(playerId, totalStake + stake);
		}
	}
	
	
	private List<Integer> getWinners(PlayerHands hands) {
		List<Integer> winners = new ArrayList<Integer>();
		
		int highestRank = -1;
		
		for (Integer pid : hands.getHands().keySet()) {
			Hand hand = hands.getHands().get(pid);
			int rank = HandEvaluator.rankHand(hand);
			if (rank > highestRank) {
				winners.clear();
				highestRank = rank;
				winners.add(pid);
			} else if (rank == highestRank) {
				// Split pot
				winners.add(pid);
			}
		}
		return winners;
	}
}
