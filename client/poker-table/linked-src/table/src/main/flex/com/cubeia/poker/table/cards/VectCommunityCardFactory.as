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
	import com.cubeia.games.poker.io.protocol.RankEnum;
	import com.cubeia.games.poker.io.protocol.SuitEnum;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.controls.Image;


	public class VectCommunityCardFactory
	{
		
		public static var cardBitmap:Bitmap = null;
		public static var loadDone:Boolean = false;
		public static var instance:VectCommunityCardFactory = new VectCommunityCardFactory();
		
		public function VectCommunityCardFactory()
		{
		}
		

		public static function getStringRepesentation(card:GameCard):String
		{
			var suit:String;
			var rank:String;
			
			switch ( card.suit )
			{
				case SuitEnum.CLUBS :
					suit = "c";
					break;
				case SuitEnum.SPADES :
					suit = "s";
					break;
				case SuitEnum.HEARTS:
					suit = "h";
					break;
				case SuitEnum.DIAMONDS :
					suit = "d";
					break;
			}
			
			switch ( card.rank )
			{
				case RankEnum.ACE:
					rank = "A";
					break;
				case RankEnum.KING:
					rank = "K";
					break;
				case RankEnum.QUEEN:
					rank = "Q";
					break;
				case RankEnum.TEN:
					rank = "T";
					break;
				default:
					rank = (card.rank + 2).toString();
			}
			return rank+suit;
			
		}

		public function getBackCard():Bitmap
		{
			CardHelper.initCards();
			var bm:Bitmap = CardHelper.getBackCard();
			bm.width = 70;
			bm.height = 88;
			return bm;	
		}


		public function getCard(card:GameCard):Bitmap
		{
			CardHelper.initCards();
			var bm:Bitmap = CardHelper.getPrivateCard(card);
			bm.width = 70;
			bm.height = 88;
			return bm;	
		}


	}
}