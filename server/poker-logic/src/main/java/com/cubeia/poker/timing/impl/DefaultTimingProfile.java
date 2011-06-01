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

package com.cubeia.poker.timing.impl;

import com.cubeia.poker.timing.Periods;
import com.cubeia.poker.timing.TimingProfile;

/**
 * Not the most pimp profile on the block, but rather just a simple
 * default implementation of a timing profile.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class DefaultTimingProfile implements TimingProfile {

	private static final long serialVersionUID = -3621659377668490319L;

	public String toString() {
        return "DefaultTimingProfile";
    }
    
	public long getTime(Periods period) {
		switch (period) {
			case POCKET_CARDS:
				return 3000;
			case FLOP:
				return 3000;
			case TURN:
				return 3000;
			case RIVER:
				return 3000;
			case START_NEW_HAND:
				return 8000;
			case ACTION_TIMEOUT:
				return 15000;
			case AUTO_POST_BLIND_DELAY:
				return 300;
			case LATENCY_GRACE_PERIOD:
				return 1000;
			default:
				return 5000;
		}
	}

}
