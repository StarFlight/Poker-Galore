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

package com.hurlant.crypto.prng
{
	import flash.utils.ByteArray;
	import com.hurlant.util.Memory;
	import flash.system.System;
	import flash.system.Capabilities;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.SWFVersion;
	import flash.display.Stage;
	import flash.utils.getTimer;
	import flash.text.Font;
	
	public class Random
	{
		private var state:IPRNG;
		private var ready:Boolean = false;
		private var pool:ByteArray;
		private var psize:int;
		private var pptr:int;
		private var seeded:Boolean = false;
		
		public function Random(prng:Class = null) {
			if (prng==null) prng = ARC4;
			state = new prng as IPRNG;
			psize= state.getPoolSize();
			pool = new ByteArray;
			pptr = 0;
			while (pptr <psize) {
				var t:uint = 65536*Math.random();
				pool[pptr++] = t >>> 8;
				pool[pptr++] = t&255;
			}
			pptr=0;
			seed();
		}
		
		public function seed(x:int = 0):void {
			if (x==0) {
				x = new Date().getTime();
			}
			pool[pptr++] ^= x & 255;
			pool[pptr++] ^= (x>>8)&255;
			pool[pptr++] ^= (x>>16)&255;
			pool[pptr++] ^= (x>>24)&255;
			pptr %= psize;
			seeded = true;
		}
		
		/**
		 * Gather anything we have that isn't entirely predictable:
		 *  - memory used
		 *  - system capabilities
		 *  - timing stuff
		 *  - installed fonts
		 */
		public function autoSeed():void {
			var b:ByteArray = new ByteArray;
			b.writeUnsignedInt(System.totalMemory);
			b.writeUTF(Capabilities.serverString);
			b.writeUnsignedInt(getTimer());
			b.writeUnsignedInt((new Date).getTime());
			var a:Array = Font.enumerateFonts(true);
			for each (var f:Font in a) {
				b.writeUTF(f.fontName);
				b.writeUTF(f.fontStyle);
				b.writeUTF(f.fontType);
			}
			b.position=0;
			while (b.bytesAvailable>=4) {
				seed(b.readUnsignedInt());
			}
		}
		
		
		public function nextBytes(buffer:ByteArray, length:int):void {
			while (length--) {
				buffer.writeByte(nextByte());
			}
		}
		public function nextByte():int {
			if (!ready) {
				if (!seeded) {
					autoSeed();
				}
				state.init(pool);
				pool.length = 0;
				pptr = 0;
				ready = true;
			}
			return state.next();
		}
		public function dispose():void {
			for (var i:uint=0;i<pool.length;i++) {
				pool[i] = Math.random()*256;
			}
			pool.length=0;
			pool = null;
			state.dispose();
			state = null;
			psize = 0;
			pptr = 0;
			Memory.gc();
		}
		public function toString():String {
			return "random-"+state.toString();
		}
	}
}
