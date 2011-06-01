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
	
	/**
	 * Tiny interface that represents a padding mechanism.
	 */
	public interface IPad
	{
		/**
		 * Add padding to the array
		 */
		function pad(a:ByteArray):void;
		/**
		 * Remove padding from the array.
		 * @throws Error if the padding is invalid.
		 */
		function unpad(a:ByteArray):void;
		/**
		 * Set the blockSize to work on
		 */
		function setBlockSize(bs:uint):void;
	}
}