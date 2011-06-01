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

package com.cubeia.poker.table.cards
{
	import com.cubeia.games.poker.io.protocol.GameCard;
	
	import com.cubeia.poker.table.model.GenericCard;

	public class CardHelper
	{
		
		import flashandmath.as3.cards.CardLoader;
		import flashandmath.as3.cards.PlayingCard;
		import com.cubeia.games.poker.io.protocol.GameCard;
		import com.cubeia.games.poker.io.protocol.RankEnum;
		import com.cubeia.games.poker.io.protocol.SuitEnum;
		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.geom.Rectangle;
		import flash.geom.Point;
		import mx.controls.Alert;
		
		
		[Bindable]
		private  static var arrCards:Array = [ ];
		

		[Bindable]
		private static var cardLdr:CardLoader;
		
		[Bindable]
		private static var initialized:Boolean = false;
		


	   public static function initCards():void {
		  if (!initialized) {
			  makeCards();
		  }
	   }
	   
	   public static function getPrivateCard(card:GameCard):Bitmap {
		   var idx:int = 0;
		   switch ( card.suit )
		   {
			   case SuitEnum.CLUBS :
				   idx = 0;
				   break;
			   case SuitEnum.SPADES :
				   idx+=26;
				   break;
			   case SuitEnum.HEARTS:
				   idx+=13;
				   break;
			   case SuitEnum.DIAMONDS :
				   idx+=39;
				   break;
		   }
		   
		   switch ( card.rank )
		   {
			   case RankEnum.ACE:
				   idx += 0;
				   break;
			   case RankEnum.KING:
				   idx += 12;
				   break;
			   case RankEnum.QUEEN:
				   idx += 11;
				   break;
			   case RankEnum.JACK:
				   idx += 10;
				   break;
			   case RankEnum.TEN:
				   idx += 9;
				   break;
			   case RankEnum.NINE:
				   idx += 8;
				   break;
			   case RankEnum.EIGHT:
				   idx += 7;
				   break;
			   case RankEnum.SEVEN:
				   idx += 6;
				   break;
			   case RankEnum.SIX:
				   idx += 5;
				   break;
			   case RankEnum.FIVE:
				   idx += 4;
				   break;
			   case RankEnum.FOUR:
				   idx += 3;
				   break;
			   case RankEnum.THREE:
				   idx += 2;
				   break;
			   case RankEnum.TWO:
				   idx += 1;
				   break;
			   default:
				   break;
		   }		
		   
		   var bm:Bitmap = null;
		    var gc:GenericCard = arrCards[idx];
			if (gc != null) {
				bm =  gc.side0Img;
			}

		   return bm;
		   
	   }
	   
	   public static function getBackCard():Bitmap {	 
		   var idx:int = 0;

			// all cards have same back, return first one should be fine		   		   
		   var gc:GenericCard = arrCards[idx];
		   var bm:Bitmap = gc.side1Img;
		   
		   
	   return bm;
	   
	}
	   
		private static function makeCards():void {
			
			var arrVals:Array = ["A","2","3","4","5","6","7","8","9","T","J","Q","K"];
			
			var arrSuits:Array = ["C","H","S","D"];
			
			var arrCardStrings:Array = new Array(52);
			
			var i:int, j:int;
			
			// Fill arrCardStrings with the 52 file names for the card faces
			
			for (i=0; i<4; i++) {
				
				for (j=0; j<13; j++) {
					arrCardStrings[13*i+j] = "cards-75/"+arrVals[j]+arrSuits[i]+"-75.png";
				}
				
			}
			
			/* CardLoader object is constructed with an array of file names of card faces
			and a single file name for the card back. */
			
			cardLdr = new CardLoader(arrCardStrings,"cards-75/redback3-75.png");
			
			cardLdr.addEventListener(CardLoader.CARDS_LOADED, loadComplete);
			
			cardLdr.addEventListener(CardLoader.LOAD_ERROR, loadError);
			
		}		
		
		private static function loadComplete(e:Event):void {
			setupDeck();
			cardLdr.removeEventListener(CardLoader.CARDS_LOADED, loadComplete);
			
			cardLdr.removeEventListener(CardLoader.LOAD_ERROR, loadError);
			initialized = true;
		}
		
		private static function loadError(e:Event):void {
			
			cardLdr.removeEventListener(CardLoader.CARDS_LOADED, loadComplete);
			
			cardLdr.removeEventListener(CardLoader.LOAD_ERROR, loadError);
			
		}
		
		private static function setupDeck():void {
			arrCards = (cardLdr.getCardArray()).concat();
		}	
	}
}