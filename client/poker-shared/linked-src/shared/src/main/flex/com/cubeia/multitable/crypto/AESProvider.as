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
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.crypto.symmetric.ICipher;

	public class AESProvider implements CryptoProvider
	{
		private var pad2:PKCS5 = new PKCS5(16);
		private var cipher:ICipher;
	
		public function decrypt(buffer:ByteArray):ByteArray
		{
			cipher.decrypt(buffer);
			buffer.position = 0;
			return buffer;
		}
		
		public function encrypt(buffer:ByteArray):ByteArray
		{
			cipher.encrypt(buffer);
			buffer.position = 0;
			return buffer;
		}
		
		public function setSessionKey(buffer:ByteArray):void
		{
			cipher = Crypto.getCipher("simple-aes128-cbc", buffer, pad2);
		}
		
	}
}