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
	import com.hurlant.math.BigInteger;
	import com.hurlant.util.Hex;
	
	public class BigIntegerTest extends TestCase
	{
		public function BigIntegerTest(h:ITestHarness)
		{
			super(h, "BigInteger Tests");
			runTest(testAdd, "BigInteger Addition");
			h.endTestCase();
		}
		
		public function testAdd():void {
			var n1:BigInteger = BigInteger.nbv(25);
			var n2:BigInteger = BigInteger.nbv(1002);
			var n3:BigInteger = n1.add(n2);
			var v:int = n3.valueOf();
			assert("25+1002 = "+v, 25+1002==v);

			var p:BigInteger = new BigInteger(Hex.toArray("e564d8b801a61f47"));
			var xp:BigInteger = new BigInteger(Hex.toArray("99246db2a3507fa"));
			
			xp = xp.add(p);
			
			assert("xp==eef71f932bdb2741", xp.toString(16)=="eef71f932bdb2741");
		}
		
	}
}