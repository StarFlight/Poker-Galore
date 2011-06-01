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

package com.cubeia.firebase.model
{
	import com.cubeia.firebase.io.protocol.Param;
	import com.cubeia.firebase.io.protocol.ParameterTypeEnum;
	import com.cubeia.firebase.io.protocol.TournamentSnapshotPacket;
	import com.cubeia.firebase.io.protocol.TournamentUpdatePacket;
	import com.cubeia.firebase.util.ParameterUtil;
	
	public class TournamentDataItem
	{
        private var _values:Object = new Object();
       	public var mttId:int;
       	public var address:String;

        public function makeSnapshotEvent(tournamentSnapshotPacket:TournamentSnapshotPacket):void
        {
        	mttId 	= tournamentSnapshotPacket.mttid;
        	address = tournamentSnapshotPacket.address;
        	
       	  	for each ( var param:Param in tournamentSnapshotPacket.params ) {
       	  		_values[param.key] = param;
       	  	}
        }

    	public function makeUpdateEvent(tournamentUpdatePacket:TournamentUpdatePacket):void
        {
        	mttId = tournamentUpdatePacket.mttid;
        	
       	  	for each ( var param:Param in tournamentUpdatePacket.params ) {
       	  		_values[param.key] = param;
       	  	}
        }

		public function getParameterNames():Array
		{
			var parameterNames:Array = new Array();
			
			for ( var key:String in _values )
			{
				parameterNames.push(key);
			}	
			return parameterNames;
		}
        
        public function putParameter(name:String, value:Param):void
        {
        	_values[name] = value;
        }

        public function getParameter(name:String):Param
        {
        	return _values[name];
        }
        
      	public function getValue(key:String):*
        {
        	var param:Param = _values[key];
        	if ( param == null )
        		return null;
        	
        	param.value.position = 0;
        	
        	switch ( param.type ) {
        		case ParameterTypeEnum.INT :
        			return ParameterUtil.parseInteger(param);
        			break;
				case ParameterTypeEnum.DATE :
					return ParameterUtil.parseDate(param);
					break;
				case ParameterTypeEnum.STRING :
					return ParameterUtil.parseString(param);
					break;
        	}
        	return null;
        }
	}
}