/**
 * Copyright (C) 2009 Cubeia Ltd info@cubeia.com
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
 * along with this program.  If not, see http://www.gnu.org/licenses.
 */

package com.cubeia.firebase.events
{
	import com.cubeia.firebase.model.TournamentDataItem;
	import flash.events.Event;
	
	public class TournamentEvent extends Event
	{
		/**
		* TournamentEvent.TOURNAMENT_UPDATED defines the 
		* <code>type</code> property of the event object 
		* for a <code>_fb_tourn_updated</code> event.
		*
		* @eventType _fb_tourn_updated
		*/
		public static const TOURNAMENT_UPDATED:String 	= "_fb_tourn_updated";

		/**
		* TournamentEvent.TOURNAMENT_ADDED defines the 
		* <code>type</code> property of the event object 
		* for a <code>_fb_tourn_added</code> event.
		*
		* @eventType _fb_tourn_added
		*/
		public static const TOURNAMENT_ADDED:String 	= "_fb_tourn_added";

		/**
		* TournamentEvent.TOURNAMENT_REMOVED defines the 
		* <code>type</code> property of the event object 
		* for a <code>_fb_tourn_removed</code> event.
		*
		* @eventType _fb_tourn_removed
		*/
		public static const TOURNAMENT_REMOVED:String 	= "_fb_tourn_removed";

		public function TournamentEvent(eventType:String, mttId:int, tournamentDataItem:TournamentDataItem)
		{
			super(eventType);
			_mttId = mttId;
			_data = tournamentDataItem;
		}
		
		public function get mttId():int
		{
			return _mttId;	
		}
		
		
		public function get tournamentDataItem():TournamentDataItem
		{
			return _data;
		}
		
		private var _mttId:int;
		private var _data:TournamentDataItem;
	}
}