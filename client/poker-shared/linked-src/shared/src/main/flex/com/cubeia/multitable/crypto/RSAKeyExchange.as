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

package com.cubeia.multitable.crypto
{
	import flash.utils.ByteArray;
	import com.hurlant.crypto.rsa.RSAKey;

	public class RSAKeyExchange implements KeyExchange
	{
		private var rsa:RSAKey;
		
		public function RSAKeyExchange(keyLength:int)
		{
			rsa = RSAKey.generate(512, "10001");
		}
		
		public function decryptSessionKey(buffer:ByteArray):ByteArray
		{
			var target:ByteArray = new ByteArray();
			rsa.decrypt(buffer, target, buffer.length);
			target.position = 0;
			return target;
		}
		
		public function getPublicKey():String
		{
			return rsa.n.toString(16);
		}
		
	}
}