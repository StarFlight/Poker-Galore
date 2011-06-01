/* ***********************************************************************
AS3 Class for Flash CS4+ by Doug Ensley of http://www.flashandmath.com/
Last modified: November 20, 2010
************************************************************************ */

package flashandmath.as3.cards {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;	
	import flash.events.Event;
	
	import PlayingCard;
	
	public class CardDeck extends Sprite {
		
		private var arrCards:Vector.<PlayingCard>;
		
		public function CardDeck(arr:Vector.<PlayingCard>) {
			arrCards = new Vector.<PlayingCard>()
			arrCards = arr.concat();
			initialLayerCards();
		}
		
		private function initialLayerCards():void {
			var i:int;
			
			for (i=0; i<arrCards.length; i++) {
				arrCards[i].x = 0;
				arrCards[i].y = 0;
				arrCards[i].z = 0;
				this.addChildAt(arrCards[i],i);
			}
		}
		// Sets the depth level to match the array order for the cards in the deck. This allows us in the public methods that follow below to manipulate just the array of cards.
		private function layerCards():void {
			var i:int;
			
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
			
			for (i=0; i<arrCards.length; i++) {
				this.addChildAt(arrCards[i],i);
			}
		}
		
		// getCardArray allows the user to gain access to all PlayingCard objects in this CardDeck object.
		public function getCardArray():Vector.<PlayingCard> {
			return arrCards.concat();
		}
		
		// getCardAt allows the user to gain access to one particular PlayingCard in this CardDeck object.
		public function getCardAt(i:int):PlayingCard {
			return PlayingCard(arrCards[i]);
		}
		
		// removeCardAt allows the user to remove (and return) a PlayingCard object from this CardDeck object.
		public function removeCardAt(i:int):PlayingCard {
			var pc:PlayingCard = arrCards.splice(i,1)[0];
			layerCards();
			return pc;
		}
		
		// addCardAt allows the user to add a PlayingCard object from this CardDeck object.
		public function addCardAt(pc:PlayingCard, i:int):void {
			arrCards.splice(i,0,pc);
			layerCards();
		}
		
		public function moveCard(from:int,to:int):void {
			var thisPC:PlayingCard = removeCardAt(from);
			addCardAt(thisPC,to);
		}
		
		public function reverseDeck():void {
			arrCards.reverse();
			layerCards();
		}
		
		// getCardIndex returns the index of a particular PlayingCard object in the CardDeck
		public function getCardIndex(pc:PlayingCard):int {			
			return arrCards.indexOf(pc);
		}
		
		// Return the number of cards in this CardDeck
		public function get numCards():int {
			return arrCards.length;
		}
	}
}