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

package com.hurlant.util.der
{
	import com.hurlant.crypto.rsa.RSAKey;
	import com.hurlant.math.BigInteger;
	import com.hurlant.util.Base64;
	
	import flash.utils.ByteArray;
	
	public class PEM
	{
		private static const RSA_PRIVATE_KEY_HEADER:String = "-----BEGIN RSA PRIVATE KEY-----";
		private static const RSA_PRIVATE_KEY_FOOTER:String = "-----END RSA PRIVATE KEY-----";
		private static const RSA_PUBLIC_KEY_HEADER:String = "-----BEGIN PUBLIC KEY-----";
		private static const RSA_PUBLIC_KEY_FOOTER:String = "-----END PUBLIC KEY-----";
		
		
		private static const OID_RSA_ENCRYPTION:String = "1.2.840.113549.1.1.1";
		
		/**
		 * 
		 * Read a structure encoded according to
		 * ftp://ftp.rsasecurity.com/pub/pkcs/ascii/pkcs-1v2.asc
		 * section 11.1.2
		 * 
		 * @param str
		 * @return 
		 * 
		 */
		public static function readRSAPrivateKey(str:String):RSAKey {
			// 1. we expect a "-----BEGIN RSA PRIVATE KEY-----"
			var i:int = str.indexOf(RSA_PRIVATE_KEY_HEADER);
			if (i==-1) return null;
			i += RSA_PRIVATE_KEY_HEADER.length;
			var j:int = str.indexOf(RSA_PRIVATE_KEY_FOOTER);
			if (j==-1) return null;
			var b64:String = str.substring(i, j);
			// remove any whitespace characters from the string
			var space:RegExp= /\s/mg;
			b64 = b64.replace(space,'');
			// decode
			var der:ByteArray = Base64.decodeToByteArray(b64);
			var obj:* = DER.parse(der);
			if (obj is Array) {
				var arr:Array = obj as Array;
				// arr[0] is Version. should be 0. should be checked. shoulda woulda coulda.
				return new RSAKey(
					arr[1],				// N
					arr[2].valueOf(),	// E
					arr[3],				// D
					arr[4],				// P
					arr[5],				// Q
					arr[6],				// DMP1
					arr[7],				// DMQ1	
					arr[8]);			// IQMP
			} else {
				// dunno
				return null;
			}
		}
		
		
		/**
		 * Read a structure encoded according to some spec somewhere
		 * Also, follows some chunk from
		 * ftp://ftp.rsasecurity.com/pub/pkcs/ascii/pkcs-1v2.asc
		 * section 11.1
		 * 
		 * @param str
		 * @return 
		 * 
		 */
		public static function readRSAPublicKey(str:String):RSAKey {
			var i:int = str.indexOf(RSA_PUBLIC_KEY_HEADER);
			if (i==-1) return null;
			i += RSA_PUBLIC_KEY_HEADER.length;
			var j:int = str.indexOf(RSA_PUBLIC_KEY_FOOTER);
			if (j==-1) return null;
			var b64:String = str.substring(i, j);
			// remove whitesapces.
			b64 = b64.replace(/\s/mg, '');
			// decode
			var der:ByteArray = Base64.decodeToByteArray(b64);
			var obj:* = DER.parse(der);
			if (obj is Array) {
				var arr:Array = obj as Array;
				// arr[0] = [ <some crap that means "rsaEncryption">, null ]; ( apparently, that's an X-509 Algorithm Identifier.
				if (arr[0][0].toString()!=OID_RSA_ENCRYPTION) {
					return null;
				}
				// arr[1] is a ByteArray begging to be parsed as DER
				arr[1].position = 1; // there's a 0x00 byte up front. find out why later. like, read a spec.
				obj = DER.parse(arr[1]);
				if (obj is Array) {
					arr = obj as Array;
					// arr[0] = modulus
					// arr[1] = public expt.
					return new RSAKey(arr[0], arr[1]);
				} else {
					return null;
				}
			} else {
				// dunno
				return null;
			}
		}
		
	}
}