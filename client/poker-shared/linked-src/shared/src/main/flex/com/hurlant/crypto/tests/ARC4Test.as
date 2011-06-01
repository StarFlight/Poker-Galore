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
	import com.hurlant.util.Hex;
	import flash.utils.ByteArray;
	import com.hurlant.crypto.prng.ARC4;
	
	public class ARC4Test extends TestCase
	{
		public function ARC4Test(h:ITestHarness)
		{
			super(h, "ARC4 Test");
			runTest(testLameVectors,"ARC4 Test Vectors");
			h.endTestCase();
		}
		
		/**
		 * Sad test vectors pilfered from
		 * http://en.wikipedia.org/wiki/RC4
		 */
		public function testLameVectors():void {
			var keys:Array = [
			Hex.fromString("Key"),
			Hex.fromString("Wiki"),
			Hex.fromString("Secret")];
			var pts:Array = [
			Hex.fromString("Plaintext"),
			Hex.fromString("pedia"),
			Hex.fromString("Attack at dawn")];
			var cts:Array = [
			"BBF316E8D940AF0AD3",
			"1021BF0420",
			"45A01F645FC35B383552544B9BF5"];
			
			for (var i:uint=0;i<keys.length;i++) {
				var key:ByteArray = Hex.toArray(keys[i]);
				var pt:ByteArray = Hex.toArray(pts[i]);
				var rc4:ARC4 = new ARC4(key);
				rc4.encrypt(pt);
				var out:String = Hex.fromArray(pt).toUpperCase();
				assert("comparing "+cts[i]+" to "+out, cts[i]==out);
				// now go back to plaintext
				rc4.decrypt(pt);
				out = Hex.fromArray(pt);
				assert("comparing "+pts[i]+" to "+out, pts[i]==out);
			}
		}
		
	}
}