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
	import com.hurlant.crypto.hash.MD5;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
	
	public class MD5Test extends TestCase
	{
		public function MD5Test(h:ITestHarness)
		{
			super(h, "MD5 Test");
			runTest(testMd5,"MD5 Test Vectors");
			h.endTestCase();
		}
		
		/**
		 * Test Vectors grabbed from
		 * http://www.faqs.org/rfcs/rfc1321.html
		 */
		public function testMd5():void {
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
			"d41d8cd98f00b204e9800998ecf8427e",
			"0cc175b9c0f1b6a831c399e269772661",
			"900150983cd24fb0d6963f7d28e17f72",
			"f96b697d7cb7938d525a2f31aaf161d0",
			"c3fcd3d76192e4007dfb496cca67e13b",
			"d174ab98d277d9f5a5611c2c9f419d9f",
			"57edf4a22be3c955ac49da2e2107b67a"
			];
			var md5:MD5 = new MD5;
			for (var i:uint=0;i<srcs.length;i++) {
				var src:ByteArray = Hex.toArray(srcs[i]);
				var digest:ByteArray = md5.hash(src);
				assert("MD5 Test "+i, Hex.fromArray(digest) == hashes[i]);
			}
			
		}
		
	}
}