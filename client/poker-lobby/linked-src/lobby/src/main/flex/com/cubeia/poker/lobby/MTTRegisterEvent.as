package com.cubeia.poker.lobby
{
	import flash.events.Event;

	public class MTTRegisterEvent extends Event
	{
		public static const MTT_REGISTER_EVENT:String = "_mtt_reg";
		
		public function MTTRegisterEvent(mttId:int)
		{
			_mttId = mttId;
			super(MTT_REGISTER_EVENT);
		}
		
		public function get mttId():int
		{
			return _mttId;
		}
		
		private var _mttId:int;
	}
}