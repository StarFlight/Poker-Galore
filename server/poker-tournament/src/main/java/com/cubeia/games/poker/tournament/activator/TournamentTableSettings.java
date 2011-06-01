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

package com.cubeia.games.poker.tournament.activator;

import java.io.Serializable;

import com.cubeia.poker.timing.TimingFactory;
import com.cubeia.poker.timing.TimingProfile;

public class TournamentTableSettings implements Serializable {
    
    /** version id */
    private static final long serialVersionUID = 1L;
    
    private TimingProfile timingProfile = TimingFactory.getRegistry().getDefaultTimingProfile();

    public TimingProfile getTimingProfile() {
        return timingProfile;
    }

    public void setTimingProfile(TimingProfile timingProfile) {
        this.timingProfile = timingProfile;
    }
    
}
