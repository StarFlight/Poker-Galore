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
	public class TestCase 
	{
		public var harness:ITestHarness;
		
		public function TestCase(h:ITestHarness, title:String) {
			harness = h;
			harness.beginTestCase(title);
		}
		
		
		public function assert(msg:String, value:Boolean):void {
			if (value) {
//				TestHarness.print("+ ",msg);
				return;
			}
			throw new Error("Test Failure:"+msg);
		}
		
		public function runTest(f:Function, title:String):void {
			harness.beginTest(title);
			try {
				f();
			} catch (e:Error) {
				trace("EXCEPTION THROWN: "+e);
				trace(e.getStackTrace());
				harness.failTest(e.toString());
				return;
			}
			harness.passTest();
		}
	}
}