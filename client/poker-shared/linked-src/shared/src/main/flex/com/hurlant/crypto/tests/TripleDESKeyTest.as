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
	import com.hurlant.crypto.symmetric.TripleDESKey;
	import com.hurlant.util.Hex;
	import flash.utils.ByteArray;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.ECBMode;
	
	public class TripleDESKeyTest extends TestCase
	{
		public function TripleDESKeyTest(h:ITestHarness)
		{
			super(h, "Triped Des Test");
			runTest(testECB,"Triple DES ECB Test Vectors");
			h.endTestCase();
		}
		
		/**
		 * Lots of vectors at http://csrc.nist.gov/publications/nistpubs/800-20/800-20.pdf
		 * XXX move them in here.
		 */
		public function testECB():void {
			var keys:Array = [
			"010101010101010101010101010101010101010101010101",
			"dd24b3aafcc69278d650dad234956b01e371384619492ac4",
			];
			var pts:Array = [
			"8000000000000000",
			"F36B21045A030303",
			];
			var cts:Array = [
			"95F8A5E5DD31D900",
			"E823A43DEEA4D0A4",
			];
			
			for (var i:uint=0;i<keys.length;i++) {
				var key:ByteArray = Hex.toArray(keys[i]);
				var pt:ByteArray = Hex.toArray(pts[i]);
				var ede:TripleDESKey = new TripleDESKey(key);
				ede.encrypt(pt);
				var out:String = Hex.fromArray(pt).toUpperCase();
				assert("comparing "+cts[i]+" to "+out, cts[i]==out);
				// now go back to plaintext
				ede.decrypt(pt);
				out = Hex.fromArray(pt).toUpperCase();
				assert("comparing "+pts[i]+" to "+out, pts[i]==out);
			}
		}
		
	}
}