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

package com.cubeia.poker.login
{
	import com.cubeia.poker.event.PokerEvent;

	public class LoginEvent extends PokerEvent
	{
		public static const LOGIN_EVENT:String = "login_event";
		
		public function LoginEvent(username:String, password:String, host:String, operatorId:int)
		{
			_username = username;
			_password = password;
			_host = host;
			_operatorId = operatorId;
			super(LOGIN_EVENT);
		}

		public function get username():String
		{
			return _username;
		}

		public function get password():String
		{
			return _password;
		}

		public function get host():String
		{
			return _host;
		}
		
		public function get operatorId():int
		{
			return _operatorId;
		}

		private var	_username:String;
		private var	_password:String;
		private var	_host:String;
		private var	_operatorId:int;
		
	}
}