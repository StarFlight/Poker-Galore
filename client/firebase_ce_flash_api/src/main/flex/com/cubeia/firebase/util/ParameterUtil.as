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

package com.cubeia.firebase.util
{
	import com.cubeia.firebase.io.protocol.ParameterTypeEnum;
	import com.cubeia.firebase.io.protocol.Param;
	import com.cubeia.firebase.io.PacketInputStream;
	
	public class ParameterUtil
	{
		/**
		 * Parse date param
		 * 
		 * @param param object to parse
		 * @return parsed date
		 */
		static public function parseDate(param:Param):Date
		{
			if ( param.type == ParameterTypeEnum.DATE )
			{
				return new Date(param.value.readInt()*1000);
			}
			return null;
		}
		
		/**
		 * Parse string parameter
		 * 
		 * @param param object to parse
		 * @return parsed string
		 */static public function parseString(param:Param):String
		{
			if ( param.type == ParameterTypeEnum.STRING )
			{
				var strlen:int = param.value.readShort();
				return new String(param.value.readUTFBytes(strlen));
			}
			return null;
		}
		
		/**
		 * Parse int param
		 * 
		 * @param param object to parse
		 * @return parsed int
		 */static public function parseInteger(param:Param):int
		{
			if ( param.type == ParameterTypeEnum.makeParameterTypeEnum(ParameterTypeEnum.INT) )
			{
				return param.value.readInt();
			}
			return -1;
		}
		
		/**
		 * create date param
		 * 
		 * @param key key value
		 * @param value 
		 * @return 
		 */
		static public function makeDateParam(key:String, value:Date):Param
		{
			var param:Param = new Param();
			param.key = key;
			param.type = ParameterTypeEnum.DATE;
			param.value.writeInt(value.getDate());
			return param;
		}

		/**
		 * create string param
		 * 
		 * @param key key value
		 * @param value 
		 * @return 
		 */
		static public function makeStringParam(key:String, value:String):Param
		{
			var param:Param = new Param();
			param.key = key;
			param.type = ParameterTypeEnum.STRING;
			param.value.writeUTF(value);
			return param;
		}

		/**
		 * create int param
		 * 
		 * @param key key value
		 * @param value 
		 * @return 
		 */
		static public function makeIntegerParam(key:String, value:int):Param
		{
			var param:Param = new Param();
			param.key = key;
			param.type = ParameterTypeEnum.INT;
			param.value.writeInt(value);
			return param;
		}
		
	}
}