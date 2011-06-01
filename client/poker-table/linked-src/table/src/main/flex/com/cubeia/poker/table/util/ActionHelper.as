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

package com.cubeia.poker.table.util
{
	import com.cubeia.games.poker.io.protocol.ActionTypeEnum;
	import com.cubeia.games.poker.io.protocol.PerformAction;
	import com.cubeia.poker.table.model.Player;
	import com.cubeia.poker.table.model.Table;

	public class ActionHelper
	{
		public function ActionHelper()
		{
		}
		
		public static function getActionString(table:Table, action:PerformAction):String
		{
			var playerName:String = table.getPlayer(action.player).screenname;
			var betAmount:Number = action.betAmount / 100;
			var raiseAmount:Number = action.raiseAmount / 100;
			
			switch ( action.action.type ) 
			{
				case ActionTypeEnum.BET :
					return playerName + " bets " + betAmount.toFixed(2);
					break;
				case ActionTypeEnum.BIG_BLIND :
					return playerName + " posts Big Blind " + betAmount.toFixed(2);
					break;
				case ActionTypeEnum.CALL :
					return playerName + " calls " + betAmount.toFixed(2);
					break;
				case ActionTypeEnum.CHECK :
					return playerName + " checks";
					break;
				case ActionTypeEnum.FOLD :
					return playerName + " folds";
					break;
				case ActionTypeEnum.RAISE :
					return playerName + " raises " + raiseAmount.toFixed(2) + " to " + betAmount.toFixed(2);
					break;
				case ActionTypeEnum.SMALL_BLIND :
					return playerName + " posts Small Blind " + betAmount.toFixed(2);
					break;
				case ActionTypeEnum.DECLINE_ENTRY_BET :
					return playerName + " declines entry bet";
					break;
			}
			return "";
		}
	}
}