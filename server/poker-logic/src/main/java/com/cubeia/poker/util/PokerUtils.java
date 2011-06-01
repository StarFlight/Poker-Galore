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

package com.cubeia.poker.util;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.SortedMap;

public class PokerUtils {

	/**
	 * Gets the next element after the given element in a sorted map.
	 * 
	 * If the given element is the last element, the first element in the map
	 * will be returned.
	 * 
	 * @param <K>
	 *            The type of the key.
	 * @param <V>
	 *            The type of the value.
	 * @param fromKey
	 *            the key to start looking from
	 * @param sortedMap
	 *            a sorted map to find an element in
	 * @return the next element after the given element in a sorted map.
	 */
	public static <K, V> V getElementAfter(K fromKey, SortedMap<K, V> sortedMap) {
		if (sortedMap.isEmpty()) {
			return null; // Return null since the map is empty!
		}
		
		SortedMap<K, V> tailMap = sortedMap.tailMap(fromKey);
		V result;
		V fromValue = sortedMap.get(fromKey);

		if (tailMap.isEmpty()) {
			result = sortedMap.get(sortedMap.firstKey());
		} else if (tailMap.size() == 1 && tailMap.firstKey().equals(fromKey)) {
			result = sortedMap.get(sortedMap.firstKey());
		} else {
			Iterator<V> iterator = tailMap.values().iterator();

			result = iterator.next();
			if (result.equals(fromValue)) {
				if (iterator.hasNext()) {
					result = iterator.next();
				}
			}
		}
		return result;
	}

	public static <K, V> List<V> unwrapList(SortedMap<K, V> sortedMap, K fromKey) {
		List<V> list = new ArrayList<V>();
		
		list.addAll(sortedMap.tailMap(fromKey).values());
		list.addAll(sortedMap.headMap(fromKey).values());
		
		return list;
	}	
	
	/**
	 * Checks if the given number is between from and to.
	 * 
	 * If to is smaller than from, all values greater than from are considered
	 * being between the two.
	 * 
	 * @param number
	 * @param from
	 * @param to
	 * @return
	 */
	public static boolean isBetween(int number, int from, int to) {
		if (from > to) {
			return number > from || number < to;
		} else {
			return number > from && number < to;
		}
	}

}