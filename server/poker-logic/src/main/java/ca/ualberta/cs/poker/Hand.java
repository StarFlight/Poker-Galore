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

package ca.ualberta.cs.poker;

/***************************************************************************
Copyright (c) 2000:
      University of Alberta,
      Deptartment of Computing Science
      Computer Poker Research Group

      See "Liscence.txt"
 ***************************************************************************/

import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;
import java.util.StringTokenizer;

/**
 * Stores a Hand of Cards (up to a maximum of 7)
 *
 * Part of replicated game state
 *
 * @author  Aaron Davidson
 */

public class Hand implements Serializable {

	private static final long serialVersionUID = 1L;

	public final static int MAX_CARDS = 7;

	private int[] cards;

	public Hand() {
		cards = new int[MAX_CARDS + 1];
		cards[0] = 0;
	}

	/**
	 * @param cs A string representing a Hand of cards
	 */
	public Hand(String cs) {
		cards = new int[MAX_CARDS + 1];
		cards[0] = 0;
		StringTokenizer t = new StringTokenizer(cs," -");
		while(t.hasMoreTokens()) {
			String s = t.nextToken();
			if (s.length()==2) {
				Card c = new Card(s.charAt(0),s.charAt(1));
				if (c.getIndex() != Card.BAD_CARD)
					addCard(c);
			}
		}     
	}

	/**
	 * Duplicate an existing hand.
	 * @param h the hand to clone.
	 */
	public Hand(Hand h) {
		cards = new int[MAX_CARDS + 1];
		cards[0] = h.size();
		for (int i=1;i<=cards[0];i++)
			cards[i] = h.cards[i];
	}

	/**
	 * Get the size of the hand.
	 * @return the number of cards in the hand
	 */
	public int size() {
		return cards[0];
	}

	/**
	 * Remove the last card in the hand.
	 */
	public void removeCard() {
		if (cards[0] > 0) {
			cards[0]--;
		}
	}

	/**
	 * Remove the all cards from the hand.
	 */
	public void makeEmpty() {
		cards = new int[MAX_CARDS + 1];
		cards[0] = 0;
	}

	/**
	 * Add a card to the hand. (if there is room)
	 * @param c the card to add
	 * @return true if the card was added, false otherwise
	 */
	public void addCards(List<Card> cards) {
		for (Card card : cards) {
			addCard(card);
		}
	}

	/**
	 * Add a card to the hand. (if there is room)
	 * @param c the card to add
	 * @return true if the card was added, false otherwise
	 */
	public boolean addCard(Card c) {
		if (c == null) return false;
		if (cards[0] == MAX_CARDS) return false; 
		cards[0]++;
		cards[cards[0]] = c.getIndex();
		return true;
	}

	/**
	 * Add a card to the hand. (if there is room)
	 * @param i the index value of the card to add
	 * @return true if the card was added, false otherwise
	 */
	public boolean addCard(int i) {
		if (cards[0] == MAX_CARDS) return false; 
		cards[0]++;
		cards[cards[0]] = i;
		return true;
	}

	/**
	 * Get the a specified card in the hand
	 * @param pos the position (1..n) of the card in the hand
	 * @return the card at position pos
	 */
	public Card getCard(int pos) {
		if (pos < 1 || pos > cards[0]) return null;
		return new Card(cards[pos]);
	}


	/**
	 * Add a card to the hand. (if there is room)
	 * @param c the card to add
	 */
	public void setCard(int pos, Card c) {
		if (cards[0] < pos) return; 
		cards[pos] = c.getIndex();
	}

	/** 
	 * Obtain the array of card indexes for this hand.
	 * First element contains the size of the hand.
	 * @return array of card indexs (size = MAX_CARDS+1)
	 */
	int[] getCardArray() {
		return cards;
	}  

	/**
	 * Returns a list of cards.
	 * Changes to this list is *not* reflected in the hand.
	 * 
	 * @return
	 */
	public List<Card> getCards() {
		List<Card> result = new LinkedList<Card>();
		for (int i = 1; i <= cards[0]; i++) {
			result.add(new Card(cards[i]));
		}
		return result;
	}


	/** 
	 * Bubble Sort the hand to have cards in descending order, but card index.
	 * Used for database indexing.
	 */
	public void sort() {
		boolean flag = true;
		while (flag) {
			flag = false;
			for (int i=1;i<cards[0];i++) {
				if (cards[i] < cards[i+1]) {
					flag = true;
					int t = cards[i];
					cards[i] = cards[i+1];
					cards[i+1] = t;
				}
			}
		}
	}

	/**
	 * Get a string representation of this Hand.
	 */
	public String toString() {
		StringBuilder s = new StringBuilder();
		for (int i=1; i <= cards[0]; i++)
			s.append(" ").append(getCard(i).toString());
		return s.toString();
	}


	/**
	 * Get the specified card id 
	 * @param pos the position (1..n) of the card in the hand
	 * @return the card at position pos
	 */
	public int getCardIndex(int pos) {
		return cards[pos];
	}
}

