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

package com.cubeia.poker.action;

import java.io.Serializable;


/**
 * Represents one possible action that a player can make.
 *
 */
public class PossibleAction implements Serializable {

	private static final long serialVersionUID = 1L;

	private final PokerActionType actionType;
	
	private final long minAmount;
	
	private final long maxAmount;
	
	/**
	 * Constructs a possible action with min and max amount set to 0.
	 * 
	 * For example, this could be a check or a fold.
	 * 
	 * @param actionType
	 */
	public PossibleAction(PokerActionType actionType) {
		this(actionType, 0, 0);
	}
	
	/**
	 * Constrcuts a possible action with min and max set to amount.
	 * 
	 * This could for examble be a bet or a raise in fixed limit poker.
	 * 
	 * @param actionType
	 * @param amount
	 */
	public PossibleAction(PokerActionType actionType, long amount) {
		this(actionType, amount, amount);
	}	
	
	/**
	 * Constructs a possible action.
	 * 
	 * @param actionType
	 * @param minAmount
	 * @param maxAmount
	 */
	public PossibleAction(PokerActionType actionType, long minAmount, long maxAmount) {
		this.actionType = actionType;
		this.minAmount = minAmount;
		this.maxAmount = maxAmount;
	}

	public boolean allows(PokerActionType option) {
		return actionType == option;
	}

	public long getMaxAmount() {
		return maxAmount;
	}
	
	public long getMinAmount() {
		return minAmount;
	}

	public PokerActionType getActionType() {
		return actionType;
	}
	
	@Override
	public String toString() {
		return String.format("[Action: %s Min: %d Max: %d]", actionType, minAmount, maxAmount);
	}
}
