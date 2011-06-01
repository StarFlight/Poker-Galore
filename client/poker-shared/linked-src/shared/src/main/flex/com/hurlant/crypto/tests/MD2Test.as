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

package com.hurlant.crypto.tests
{
	import com.hurlant.crypto.hash.MD2;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
	
	public class MD2Test extends TestCase
	{
		public function MD2Test(h:ITestHarness)
		{
			super(h, "MD2 Test");
			runTest(testMd2, "MD2 Test Vectors");
			h.endTestCase();
		}
		
		/**
		 * Test Vectors grabbed from
		 * http://www.faqs.org/rfcs/rfc1319.html
		 */
		public function testMd2():void {
			var srcs:Array = [
			"",
			Hex.fromString("a"),
			Hex.fromString("abc"),
			Hex.fromString("message digest"),
			Hex.fromString("abcdefghijklmnopqrstuvwxyz"),
			Hex.fromString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"),
			Hex.fromString("12345678901234567890123456789012345678901234567890123456789012345678901234567890")
			];
			var hashes:Array = [
			"8350e5a3e24c153df2275c9f80692773",
			"32ec01ec4a6dac72c0ab96fb34c0b5d1",
			"da853b0d3f88d99b30283a69e6ded6bb",
			"ab4f496bfb2a530b219ff33031fe06b0",
			"4e8ddff3650292ab5a4108c3aa47940b",
			"da33def2a42df13975352846c30338cd",
			"d5976f79d83d3a0dc9806c3c66f3efd8"
			];
			var md2:MD2 = new MD2;
			for (var i:uint=0;i<srcs.length;i++) {
				var src:ByteArray = Hex.toArray(srcs[i]);
				var digest:ByteArray = md2.hash(src);
				assert("MD2 Test "+i, Hex.fromArray(digest) == hashes[i]);
			}
		}
	}
}