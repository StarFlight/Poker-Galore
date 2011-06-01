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

package com.cubeia.poker.table.chipstack
{
	import flash.display.Bitmap;
	
	import mx.controls.Image;
	import mx.controls.Text;
	
	public class ChipStackFactory
	{
		public static var instance:ChipStackFactory = new ChipStackFactory();
		public static var chipBitmaps:Array;
		public static var chipAmounts:Array = [1,5,25,50,100,500,1000,2500,10000,50000,100000,500000,2500000,10000000,50000000,100000000,500000000];
		
		
		[Embed(source="/assets/chips/chip-1.png")]
		[Bindable]
		private var Chip_1:Class;    
		
		[Embed(source="/assets/chips/chip-5.png")]
		[Bindable]
		private var Chip_5:Class;    
		
		[Embed(source="/assets/chips/chip-25.png")]
		[Bindable]
		private var Chip_25:Class;    
		
		[Embed(source="/assets/chips/chip-50.png")]
		[Bindable]
		private var Chip_50:Class;    
		
		[Embed(source="/assets/chips/chip-100.png")]
		[Bindable]
		private var Chip_100:Class;    
		
		[Embed(source="/assets/chips/chip-500.png")]
		[Bindable]
		private var Chip_500:Class;    
		
		[Embed(source="/assets/chips/chip-1000.png")]
		[Bindable]
		private var Chip_1000:Class;    
		
		[Embed(source="/assets/chips/chip-2500.png")]
		[Bindable]
		private var Chip_2500:Class;    
		
		[Embed(source="/assets/chips/chip-10000.png")]
		[Bindable]
		private var Chip_10000:Class;    
		
		[Embed(source="/assets/chips/chip-50000.png")]
		[Bindable]
		private var Chip_50000:Class;    
		
		[Embed(source="/assets/chips/chip-100000.png")]
		[Bindable]
		private var Chip_100000:Class;    
		
		[Embed(source="/assets/chips/chip-500000.png")]
		[Bindable]
		private var Chip_500000:Class;    
		
		[Embed(source="/assets/chips/chip-2500000.png")]
		[Bindable]
		private var Chip_2500000:Class;    
		
		[Embed(source="/assets/chips/chip-10000000.png")]
		[Bindable]
		private var Chip_10000000:Class;    
		
		[Embed(source="/assets/chips/chip-50000000.png")]
		[Bindable]
		private var Chip_50000000:Class;    
		
		[Embed(source="/assets/chips/chip-100000000.png")]
		[Bindable]
		private var Chip_100000000:Class;    
		
		[Embed(source="/assets/chips/chip-500000000.png")]
		[Bindable]
		private var Chip_500000000:Class;    
		
		[Embed(source="/assets/chips/chip-mask.png")]
		[Bindable]
		private var Chip_Mask:Class;    
		
		
		
		public function ChipStackFactory()
		{
			createChipBitmaps();
		}
		
		
		private function createChipBitmaps():void
		{
			chipBitmaps = new Array();
			var bitmap:Bitmap;
			chipBitmaps[1] 			= new Chip_1();    
			chipBitmaps[5] 			= new Chip_5();    
			chipBitmaps[25] 		= new Chip_25();    
			chipBitmaps[50] 		= new Chip_50();    
			chipBitmaps[100] 		= new Chip_100();    
			chipBitmaps[500] 		= new Chip_500();    
			chipBitmaps[1000] 		= new Chip_1000();    
			chipBitmaps[2500] 		= new Chip_2500();    
			chipBitmaps[10000] 		= new Chip_10000();    
			chipBitmaps[50000] 		= new Chip_50000();    
			chipBitmaps[100000] 	= new Chip_100000();    
			chipBitmaps[500000] 	= new Chip_500000();    
			chipBitmaps[2500000] 	= new Chip_2500000();    
			chipBitmaps[10000000] 	= new Chip_10000000();    
			chipBitmaps[50000000] 	= new Chip_50000000();    
			chipBitmaps[100000000] 	= new Chip_100000000();    
			chipBitmaps[500000000] 	= new Chip_500000000();    
			chipBitmaps[0] 			= new Chip_Mask();    
		}
		public static function getChipImage(amount:int):Image
		{
			var chipTemplate:Bitmap = new Bitmap(chipBitmaps[amount].bitmapData);
			if ( chipTemplate == null )
			{
				return null;
			}
			
			var chipImage:Image = new Image();
			chipImage.addChild(chipTemplate);
			
			return chipImage;
		}
		
		public static function getChipStack(amount:int, maxChips:int = 10):Image
		{
			var maxPiles:int = 4;
			var maxChipsInPile:int = maxChips;
			var pileNumber:int = 0;
			var chipsInPile:int = 0;
			var amountIndex:int = chipAmounts.length - 1;
			var stackImage:Image = new Image();
			
			var currentAmount:int = amount;

			while ( currentAmount > 0 ) {
				if ( currentAmount >= chipAmounts[amountIndex] ) {
					var chipTemplate:Bitmap = new Bitmap(chipBitmaps[chipAmounts[amountIndex]].bitmapData);
					if ( chipTemplate == null ) {
						return null;
					}
					currentAmount -= chipAmounts[amountIndex]
					chipTemplate.x = pileNumber * 22;
					chipTemplate.y = 30 - chipsInPile * 3;
					
					stackImage.addChild(chipTemplate);
					
					chipsInPile ++;
					if ( chipsInPile > maxChipsInPile ) {
						pileNumber ++;
						chipsInPile = 0;
					}			
				} else {
					amountIndex --;
				}
			}
			var t:Text = new Text();
			t.percentHeight = 100;
			t.percentWidth = 100;
			t.setStyle("textAlign", "center");
			t.setStyle("color", 0xffffff);
			t.text = Number(amount/100).toFixed(2);
			stackImage.addChild(t);
			stackImage.toolTip = Number(amount/100).toFixed(2);
			return stackImage;
		}
	}
}