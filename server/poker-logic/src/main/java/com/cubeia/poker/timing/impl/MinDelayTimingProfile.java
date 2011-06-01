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
 * Minimum delay. To be used with unit tests and automated stuff that does not 
 * want to wait the proper timeouts.
 * 
 * All timeouts are set to 100ms
 * 
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class MinDelayTimingProfile implements TimingProfile {

	private static final long serialVersionUID = 5616827479149407827L;

	public String toString() {
        return "MinDelayTimingProfile";
    }
    
	public long getTime(Periods period) {
		switch (period) {
			default:
				return 100;
		}
	}

}
