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

package com.cubeia.poker.event
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * Singleton event dispatcher for poker events.
	 * Acts as a message broker.
	 */
	public class PokerEventDispatcher extends EventDispatcher
	{
		public static var instance:PokerEventDispatcher = new PokerEventDispatcher();
		
		public function PokerEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function dispatch(event:PokerEvent, global:Boolean = false):void {
			instance.dispatchEvent(event);
			if (global) {
				instance.dispatchEvent(new PokerEventWrapper(event));
			}
			
		}
		
	}
}