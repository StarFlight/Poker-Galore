package com.cubeia.poker.lobby
{
	import flash.events.Event;

	public class LobbyJoinEvent extends Event
	{
		public static const LOBBY_JOINEVENT:String = "poker_lobby";
		
		public function LobbyJoinEvent(tableId:int, capacity:int, seatId:int = -1, watch:Boolean = true)
		{
			_tableId = tableId;
			_seatId = seatId;
			_watch = watch;
			_capacity = capacity;
			super(LOBBY_JOINEVENT);
		}

		public function get tableId():int
		{
			return _tableId;
		}

		public function get seatId():int
		{
			return _seatId;
		}

		public function get capacity():int
		{
			return _capacity;
		}

		public function get watch():Boolean
		{
			return _watch;
		}

		private var _watch:Boolean;
		private var	_tableId:int;
		private var	_seatId:int;
		private var _capacity:int;
	}
}