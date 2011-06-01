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

package com.cubeia.games.poker.cep;

import com.cubeia.firebase.api.service.Contract;
import com.cubeia.poker.player.PokerPlayer;

/**
 * Facade and wrapper for the Cubeia CEP Service.
 * 
 * This interface will allow contextual notifications that are
 * not tied to any CEP specific classes or domain objects (dependency isolation).
 * 
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public interface PokerCEPService extends Contract {

    void reportHandResult(int tableId, PokerPlayer p, long amount);
    
    public void reportHandEnd(int tableId, EventMontaryType monetaryType);
}
