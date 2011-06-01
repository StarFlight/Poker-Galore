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
	import com.cubeia.poker.table.cards.CardHelper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import flashandmath.as3.cards.PlayingCard;
	
	import mx.controls.Alert;
	import mx.events.CalendarLayoutChangeEvent;
	
	public class VectCardFactory
	{

		[Bindable]
		[Embed(source="/assets/pocket_card.png")]
		public var HiddenCard:Class;

		public static const instance:VectCardFactory = new VectCardFactory();;
		
		public static var cardBitmap:Bitmap;
		
		
		public function getCardImage(wrappedGameCard:WrappedGameCard):Bitmap
		{
			if ( wrappedGameCard.hidden == true ) {
				return getHiddenCard();
			} else {
				return getPrivateCard(wrappedGameCard);
			}
		}
		
		public function VectCardFactory() {
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


		
		public function getHiddenCard():Bitmap {
			CardHelper.initCards();
			return new HiddenCard();
		}
			

		public function getPrivateCard(card:GameCard):Bitmap
		{
			CardHelper.initCards();
			return CardHelper.getPrivateCard(card);
		}


	}
}