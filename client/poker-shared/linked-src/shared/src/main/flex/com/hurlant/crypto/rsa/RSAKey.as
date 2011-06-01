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

package com.hurlant.crypto.rsa
{
	import com.hurlant.crypto.prng.Random;
	import com.hurlant.math.BigInteger;
	import com.hurlant.util.Memory;
	
	import flash.utils.ByteArray;
	
	/**
	 * Current limitations:
	 * exponent must be smaller than 2^31.
	 */
	public class RSAKey
	{
		// public key
		public var e:int;              // public exponent. must be <2^31
		public var n:BigInteger; // modulus
		// private key
		public var d:BigInteger;
		// extended private key
		public var p:BigInteger;
		public var q:BigInteger;
		public var dmp1:BigInteger
		public var dmq1:BigInteger;
		public var coeff:BigInteger;
		// flags. flags are cool.
		protected var canDecrypt:Boolean;
		protected var canEncrypt:Boolean;
		
		public function RSAKey(N:BigInteger, E:int, 
			D:BigInteger=null,
			P:BigInteger = null, Q:BigInteger=null,
			DP:BigInteger=null, DQ:BigInteger=null,
			C:BigInteger=null) {
				
			this.n = N;
			this.e = E;
			this.d = D;
			this.p = P;
			this.q = Q;
			this.dmp1 = DP;
			this.dmq1 = DQ;
			this.coeff = C;
			// adjust a few flags.
			canEncrypt = (n!=null&&e!=0);
			canDecrypt = (canEncrypt&&d!=null);
		}

		public static function parsePublicKey(N:String, E:String):RSAKey {
			return new RSAKey(new BigInteger(N, 16), parseInt(E,16));
		}
		public static function parsePrivateKey(N:String, E:String, D:String, 
			P:String=null,Q:String=null, DMP1:String=null, DMQ1:String=null, IQMP:String=null):RSAKey {
			if (P==null) {
				return new RSAKey(new BigInteger(N,16), parseInt(E,16), new BigInteger(D,16));
			} else {
				return new RSAKey(new BigInteger(N,16), parseInt(E,16), new BigInteger(D,16),
					new BigInteger(P,16), new BigInteger(Q,16),
					new BigInteger(DMP1,16), new BigInteger(DMQ1),
					new BigInteger(IQMP));				
			}
		}
		
		public function getBlockSize():uint {
			return (n.bitLength()+7)/8;
		}
		public function dispose():void {
			e = 0;
			n.dispose();
			n = null;
			Memory.gc();
		}
		public function encrypt(src:ByteArray, dst:ByteArray, length:uint, pad:Function=null):void {
			// adjust pad if needed
			if (pad==null) pad = pkcs1pad;
			// convert src to BigInteger
			if (src.position >= src.length) {
				src.position = 0;
			}
			var bl:uint = getBlockSize();
			var end:int = src.position + length;
			while (src.position<end) {
				var block:BigInteger = new BigInteger(pad(src, end, bl), bl);
				var chunk:BigInteger = doPublic(block);
				chunk.toArray(dst);
			}
		}
		public function decrypt(src:ByteArray, dst:ByteArray, length:uint, pad:Function=null):void {
			// adjust pad if needed
			if (pad==null) pad = pkcs1unpad;
			
			// convert src to BigInteger
			if (src.position >= src.length) {
				src.position = 0;
			}
			var bl:uint = getBlockSize();
			var end:int = src.position + length;
			while (src.position<end) {
				var block:BigInteger = new BigInteger(src, length);
				var chunk:BigInteger = doPrivate2(block);
				var b:ByteArray = pad(chunk, bl);
				dst.writeBytes(b);
			}
		}
		/**
		 * PKCS#1 pad. type 2, random.
		 * puts as much data from src into it, leaves what doesn't fit alone.
		 */
		private function pkcs1pad(src:ByteArray, end:int, n:uint):ByteArray {
			var out:ByteArray = new ByteArray;
			var p:uint = src.position;
			end = Math.min(end, src.length, p+n-11);
			src.position = end;
			var i:int = end-1;
			while (i>=p && n>11) {
				out[--n] = src[i--];
			}
			out[--n] = 0;
			var rng:Random = new Random;
			while (n>2) {
				var x:int = 0;
				while (x==0) x = rng.nextByte();
				out[--n] = x;
			}
			out[--n] = 2;
			out[--n] = 0;
			return out;
		}
		
		private function pkcs1unpad(src:BigInteger, n:uint):ByteArray {
			var b:ByteArray = src.toByteArray();
			var out:ByteArray = new ByteArray;
			var i:int = 0;
			while (i<b.length && b[i]==0) ++i;
			if (b.length-i != n-1 || b[i]!=2) {
				trace("PKCS#1 unpad: i="+i+", expected b[i]==2, got b[i]="+b[i]);
				return null;
			}
			++i;
			while (b[i]!=0) {
				if (++i>=b.length) {
					trace("PKCS#1 unpad: i="+i+", b[i-1]!=0 (="+b[i-1]+")");
					return null;
				}
			}
			while (++i < b.length) {
				out.writeByte(b[i]);
			}
			return out;
		}
		/**
		 * Raw pad.
		 */
		private function rawpad(src:ByteArray, end:int, n:uint):ByteArray {
			return src;
		}
		
		public function toString():String {
			return "rsa";
		}
		
		public function dump():String {
			var s:String= "N="+n.toString(16)+"\n"+
			"E="+e.toString(16)+"\n";
			if (canDecrypt) {
				s+="D="+d.toString(16)+"\n";
				if (p!=null && q!=null) {
					s+="P="+p.toString(16)+"\n";
					s+="Q="+q.toString(16)+"\n";
					s+="DMP1="+dmp1.toString(16)+"\n";
					s+="DMQ1="+dmq1.toString(16)+"\n";
					s+="IQMP="+coeff.toString(16)+"\n";
				}
			}
			return s;
		}
		
		
		/**
		 * 
		 * note: We should have a "nice" variant of this function that takes a callback,
		 * 		and perform the computation is small fragments, to keep the web browser
		 * 		usable.
		 * 
		 * @param B
		 * @param E
		 * @return a new random private key B bits long, using public expt E
		 * 
		 */
		public static function generate(B:uint, E:String):RSAKey {
			var rng:Random = new Random;
			var qs:uint = B>>1;
			var key:RSAKey = new RSAKey(null,0,null);
			key.e = parseInt(E, 16);
			var ee:BigInteger = new BigInteger(E,16);
			for (;;) {
				for (;;) {
					key.p = bigRandom(B-qs, rng);
					if (key.p.subtract(BigInteger.ONE).gcd(ee).compareTo(BigInteger.ONE)==0 &&
						key.p.isProbablePrime(10)) break;
				}
				for (;;) {
					key.q = bigRandom(qs, rng);
					if (key.q.subtract(BigInteger.ONE).gcd(ee).compareTo(BigInteger.ONE)==0 &&
						key.q.isProbablePrime(10)) break;
				}
				if (key.p.compareTo(key.q)<=0) {
					var t:BigInteger = key.p;
					key.p = key.q;
					key.q = t;
				}
				var p1:BigInteger = key.p.subtract(BigInteger.ONE);
				var q1:BigInteger = key.q.subtract(BigInteger.ONE);
				var phi:BigInteger = p1.multiply(q1);
				if (phi.gcd(ee).compareTo(BigInteger.ONE)==0) {
					key.n = key.p.multiply(key.q);
					key.d = ee.modInverse(phi);
					key.dmp1 = key.d.mod(p1);
					key.dmq1 = key.d.mod(q1);
					key.coeff = key.q.modInverse(key.p);
					break;
				}
			}
			return key;
		}
		
		protected static function bigRandom(bits:int, rnd:Random):BigInteger {
			if (bits<2) return BigInteger.nbv(1);
			var x:ByteArray = new ByteArray;
			rnd.nextBytes(x, (bits>>3));
			x.position = 0;
			var b:BigInteger = new BigInteger(x);
			b.primify(bits, 1);
			return b;
		}
		
		protected function doPublic(x:BigInteger):BigInteger {
			return x.modPowInt(e, n);
		}
		
		protected function doPrivate2(x:BigInteger):BigInteger {
			if (p==null && q==null) {
				return x.modPow(d,n);
			}
			
			var xp:BigInteger = x.mod(p).modPow(dmp1, p);
			var xq:BigInteger = x.mod(q).modPow(dmq1, q);
			
			while (xp.compareTo(xq)<0) {
				xp = xp.add(p);
			}
			var r:BigInteger = xp.subtract(xq).multiply(coeff).mod(p).multiply(q).add(xq);
			
			return r;
		}
		
		protected function doPrivate(x:BigInteger):BigInteger {
			if (p==null || q==null) {
				return x.modPow(d, n);
			}
			// TODO: re-calculate any missing CRT params
			var xp:BigInteger = x.mod(p).modPow(dmp1, p);
			var xq:BigInteger = x.mod(q).modPow(dmq1, q);
			
			while (xp.compareTo(xq)<0) {
				xp = xp.add(p);
			}
			return xp.subtract(xq).multiply(coeff).mod(p).multiply(q).add(xq);
		}
		
		
	}
}