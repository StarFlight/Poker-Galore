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
	import com.cubeia.firebase.io.protocol.TableSnapshotPacket;
	import com.cubeia.firebase.io.protocol.Param;
	import com.cubeia.firebase.io.protocol.TableUpdatePacket;
	import com.cubeia.firebase.io.protocol.ParameterTypeEnum;
	import com.cubeia.firebase.util.ParameterUtil;
	
	public class LobbyDataItem
	{

        private var _values:Object = new Object();

       	public var tableid:int;
       	public var address:String;
       	public var name:String;
       	public var capacity:int;
       	public var seated:int;
       	        
        public function makeSnapshotEvent(tableSnapshotPacket:TableSnapshotPacket):void
        {
        	tableid 	= tableSnapshotPacket.tableid;
        	address 	= tableSnapshotPacket.address;
        	name 		= tableSnapshotPacket.name;
        	capacity	= tableSnapshotPacket.capacity;
        	seated		= tableSnapshotPacket.seated;
        	
       	  	for each ( var param:Param in tableSnapshotPacket.params ) {
       	  		_values[param.key] = param;
       	  	}
        }

    	public function makeUpdateEvent(tableUpdatePacket:TableUpdatePacket):void
        {
        	tableid 	= tableUpdatePacket.tableid;
        	seated		= tableUpdatePacket.seated;
        	
       	  	for each ( var param:Param in tableUpdatePacket ){
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