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
	import com.hurlant.crypto.prng.Random;
	import com.hurlant.crypto.symmetric.ECBMode;
	import com.hurlant.crypto.symmetric.XTeaKey;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class XTeaKeyTest extends TestCase
	{
		public function XTeaKeyTest(h:ITestHarness) {
			super(h, "XTeaKey Test");
			runTest(testGetBlockSize, "XTea Block Size");
			runTest(testVectors, "XTea Test Vectors");
			
			h.endTestCase();
		}
		
		public function testGetBlockSize():void {
			var tea:XTeaKey = new XTeaKey(Hex.toArray("deadbabecafebeefdeadbabecafebeef"));
			assert("tea blocksize", tea.getBlockSize()==8);
		}
		
		public function testVectors():void {
			// blah.
			// can't find working test vectors.
			// algorithms should not get published without vectors :(
			var keys:Array=[
			"00000000000000000000000000000000",
			"2b02056806144976775d0e266c287843"];
			var pts:Array=[
			"0000000000000000",
			"74657374206d652e"];
			var cts:Array=[
			"2dc7e8d3695b0538",
			"7909582138198783"];
			// self-fullfilling vectors.
			// oh well, at least I can decrypt what I produce. :(
			
			for (var i:uint=0;i<keys.length;i++) {
				var key:ByteArray = Hex.toArray(keys[i]);
				var pt:ByteArray = Hex.toArray(pts[i]);
				var tea:XTeaKey = new XTeaKey(key);
				tea.encrypt(pt);
				var out:String = Hex.fromArray(pt);
				assert("comparing "+cts[i]+" to "+out, cts[i]==out);
				// now go back to plaintext.
				pt.position=0;
				tea.decrypt(pt);
				out = Hex.fromArray(pt);
				assert("comparing "+pts[i]+" to "+out, pts[i]==out);
			}
		}

	}
}