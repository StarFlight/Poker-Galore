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

package com.hurlant.crypto.symmetric
{
	import flash.utils.ByteArray;
	
	public interface ISymmetricKey
	{
		/**
		 * Returns the block size used by this particular encryption algorithm
		 */
		function getBlockSize():uint;
		/**
		 * Encrypt one block of data in "block", starting at "index", of length "getBlockSize()"
		 */
		function encrypt(block:ByteArray, index:uint=0):void;
		/**
		 * Decrypt one block of data in "block", starting at "index", of length "getBlockSize()"
		 */
		function decrypt(block:ByteArray, index:uint=0):void;
		/**
		 * Attempts to destroy sensitive information from memory, such as encryption keys.
		 * Note: This is not guaranteed to work given the Flash sandbox model.
		 */
		function dispose():void;
		
		function toString():String;
	}
}