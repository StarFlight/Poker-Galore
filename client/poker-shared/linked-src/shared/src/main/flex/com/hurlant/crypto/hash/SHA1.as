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

package com.hurlant.crypto.hash
{
	import flash.utils.ByteArray;

	public class SHA1 extends SHABase implements IHash
	{
		public static const HASH_SIZE:int = 20;
		
		public override function getHashSize():uint {
			return HASH_SIZE;
		}
		
		protected override function core(x:Array, len:uint):Array
		{
		  /* append padding */
		  x[len >> 5] |= 0x80 << (24 - len % 32);
		  x[((len + 64 >> 9) << 4) + 15] = len;
		
		  var w:Array = [];
		  var a:uint =  0x67452301; //1732584193;
		  var b:uint = 0xEFCDAB89; //-271733879;
		  var c:uint = 0x98BADCFE; //-1732584194;
		  var d:uint = 0x10325476; //271733878;
		  var e:uint = 0xC3D2E1F0; //-1009589776;
		
		  for(var i:uint = 0; i < x.length; i += 16)
		  {
		  	
		    var olda:uint = a;
		    var oldb:uint = b;
		    var oldc:uint = c;
		    var oldd:uint = d;
		    var olde:uint = e;
		
		    for(var j:uint = 0; j < 80; j++)
		    {
		      if (j < 16) {
		      	w[j] = x[i + j] || 0;
		      } else {
		      	w[j] = rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
		      }
		      var t:uint = rol(a,5) + ft(j,b,c,d) + e + w[j] + kt(j);
		      e = d;
		      d = c;
		      c = rol(b, 30);
		      b = a;
		      a = t;
		    }
			a += olda;
			b += oldb;
			c += oldc;
			d += oldd;
			e += olde;
		  }
		  return [ a, b, c, d, e ];
		
		}
		
		/*
		 * Bitwise rotate a 32-bit number to the left.
		 */
		private function rol(num:uint, cnt:uint):uint
		{
		  return (num << cnt) | (num >>> (32 - cnt));
		}
		
		/*
		 * Perform the appropriate triplet combination function for the current
		 * iteration
		 */
		private function ft(t:uint, b:uint, c:uint, d:uint):uint
		{
		  if(t < 20) return (b & c) | ((~b) & d);
		  if(t < 40) return b ^ c ^ d;
		  if(t < 60) return (b & c) | (b & d) | (c & d);
		  return b ^ c ^ d;
		}
		
		/*
		 * Determine the appropriate additive constant for the current iteration
		 */
		private function kt(t:uint):uint
		{
		  return (t < 20) ? 0x5A827999 : (t < 40) ?  0x6ED9EBA1 :
		         (t < 60) ? 0x8F1BBCDC : 0xCA62C1D6;
		}
		public override function toString():String {
			return "sha1";
		}
	}
}
