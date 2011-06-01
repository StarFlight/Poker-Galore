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
	import com.hurlant.crypto.hash.SHA224;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
	
	public class SHA224Test extends TestCase
	{
		public function SHA224Test(h:ITestHarness)
		{
			super(h,"SHA-224 Test");
			runTest(testSha224,"SHA-224 Test Vectors");
			// takes a few seconds, but uncomment if you must.
			//runTest(testLongSha224,"SHA-224 Long Test Vectors");
			h.endTestCase();
		}
		
		/**
		 * Test vectors courtesy of
		 * http://www.ietf.org/rfc/rfc3874.txt
		 */
		public function testSha224():void {
			var srcs:Array = [
			Hex.fromString("abc"),
			Hex.fromString("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")];
			var hashes:Array = [
			"23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7",
			"75388b16512776cc5dba5da1fd890150b0c6455cb4f58b1952522525"];
			
			var sha224:SHA224 = new SHA224;
			for (var i:uint=0;i<srcs.length;i++) {
				var src:ByteArray = Hex.toArray(srcs[i]);
				var digest:ByteArray = sha224.hash(src);
				assert("SHA224 Test "+i, Hex.fromArray(digest) == hashes[i]);
			}
		}
		public function testLongSha224():void {
			var src:ByteArray = new ByteArray;
			var a:uint = "a".charCodeAt(0);
			for (var i:uint=0;i<1e6;i++) {
				src[i] = a;
			}
			var sha224:SHA224 = new SHA224;
			var digest:ByteArray = sha224.hash(src);
			var hash:String = "20794655980c91d8bbb4c1ea97618a4bf03f42581948b2ee4ee7ad67";
			assert("SHA224 Long Test", Hex.fromArray(digest) == hash);
		}
	}
}