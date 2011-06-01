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

package com.cubeia.poker.timing;

/**
 * A registry for returning timing definitions.
 * 
 * A Timing is a set of predefeined pause/waiting times between 
 * events in the game. E.g. waitperiod between last call to new cards are 
 * dealt.
 * 
 * My intentions are that we should eventually support different
 * sets of waiting period. This way we could support slow and express 
 * tables, the difference is just what timing profile they use.
 * 
 * Currently I am only using a default definition. This is hardly
 * a prioritized task atm, but I think it nice to have a well defined
 * interface so it wont be such a pain to implement different time
 * profiles later on.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public interface TimingRegistry {
	
	/**
	 * Get the default timing profile.
	 * 
	 * @return
	 */
	public TimingProfile getDefaultTimingProfile();
	
	/**
	 * Get a timing profile based on the given profile.
	 * 
	 * @param name
	 * @return
	 */
	public TimingProfile getTimingProfile(Timings profile);
	
	
	
}
