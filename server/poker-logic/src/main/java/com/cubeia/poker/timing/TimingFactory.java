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

import com.cubeia.poker.timing.impl.TimingRegistryImpl;

/**
 * Use this factory class to access the server default registry.
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class TimingFactory {
	
	private static TimingRegistry registry = new TimingRegistryImpl();

	public static TimingRegistry getRegistry() {
		return registry;
	}
	
}
