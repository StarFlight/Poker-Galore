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

package com.cubeia.games.poker.util;

import java.io.IOException;
import java.nio.ByteBuffer;

import com.cubeia.firebase.api.action.GameDataAction;
import com.cubeia.firebase.io.ProtocolObject;
import com.cubeia.firebase.io.StyxSerializer;

public class ProtocolFactory {
    
    /** We only need writing so no injected factory is needed */
    private static StyxSerializer serializer = new StyxSerializer(null);
    
    public static GameDataAction createGameAction(ProtocolObject packet, int playerId, int tableId) {
        try {
            GameDataAction action = new GameDataAction(playerId, tableId);
            ByteBuffer buffer;
            buffer = serializer.pack(packet);
            action.setData(buffer);
            return action;
        } catch (IOException e) {
            throw new RuntimeException("Could not serialize game packet ["+packet+"]", e);
        }
    }
    
}
