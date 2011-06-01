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

package com.hurlant.math
{
	use namespace bi_internal;
	
	/**
	 * Modular reduction using "classic" algorithm
	 */
	internal class ClassicReduction implements IReduction
	{
		private var m:BigInteger;
		public function ClassicReduction(m:BigInteger) {
			this.m = m;
		}
		public function convert(x:BigInteger):BigInteger {
			if (x.s<0 || x.compareTo(m)>=0) {
				return x.mod(m);
			}
			return x;
		}
		public function revert(x:BigInteger):BigInteger {
			return x;
		}
		public function reduce(x:BigInteger):void {
			x.divRemTo(m, null,x);
		}
		public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger):void {
			x.multiplyTo(y,r);
			reduce(r);
		}
		public function sqrTo(x:BigInteger, r:BigInteger):void {
			x.squareTo(r);
			reduce(r);
		}
	}
}