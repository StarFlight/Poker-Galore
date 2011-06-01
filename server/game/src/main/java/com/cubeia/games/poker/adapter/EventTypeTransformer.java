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

package com.cubeia.games.poker.adapter;

import com.cubeia.games.poker.persistence.history.model.EventType;
import com.cubeia.poker.action.PokerActionType;

public class EventTypeTransformer {
    
    public static EventType transform(PokerActionType action) {
        switch (action) {
            case SMALL_BLIND:
                return EventType.SMALL_BLIND;
            case BIG_BLIND:
                return EventType.BIG_BLIND;
            case BET:
                return EventType.BET;
            case CALL:
                return EventType.CALL;
            case CHECK:
                return EventType.CHECK;
            case DECLINE_ENTRY_BET:
                return EventType.DENY_ENTRY_BET;
            case FOLD:
                return EventType.FOLD;
            case RAISE:
                return EventType.RAISE;
            
            default:
                return null;
        }
    }
    
}
