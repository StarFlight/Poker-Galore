/* ***********************************************************************
AS3 Class for Flash CS4+ by Doug Ensley of http://www.flashandmath.com/
Last modified: November 20, 2010

ImageLoader class by Barbara Kaskosz of Flash and Math
************************************************************************ */

package flashandmath.as3.cards {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;	
	import flash.events.Event;
	import mx.controls.Alert;
	
	//We will use our custom class, ImageLoader to load a list of bitmaps at runtime.
	import flashandmath.as3.cards.ImageLoader;
	import com.cubeia.poker.table.model.GenericCard;
	
	public class CardLoader extends Sprite {
		private var imgLoader:ImageLoader;
		private var arrCards:Array;
		
		public static const CARDS_LOADED:String = "imgsLoaded";
		public static const LOAD_ERROR:String = "loadError";
		
		public function CardLoader(arrImages:Array, stBackFile:String) {
			arrCards = new Array();
			imgLoader = new ImageLoader();
			imgLoader.addEventListener(ImageLoader.LOAD_ERROR,errorLoading);
			imgLoader.addEventListener(ImageLoader.IMGS_LOADED,allLoaded);
			imgLoader.loadImgs(arrImages.concat([ stBackFile ]));
		}
		
		private function errorLoading(e:Event):void {
			dispatchEvent(new Event(CardLoader.LOAD_ERROR));
		}
		
		private function allLoaded(e:Event):void {
			makeCards();
		}
		
		private function makeCards():void {
			var arrImages:Array = imgLoader.bitmapsArray;
			var n:int = arrImages.length - 1;
			var i:int;
			for (i=0; i<n; i++) {
				arrCards[i] = new GenericCard(arrImages[i].bitmapData,arrImages[n].bitmapData); //new Bitmap(arrImages[i].bitmapData);
			}
			for (i=0; i<arrCards.length; i++) {
				arrCards[i].x = 15*i;
				arrCards[i].y = 0;
				this.addChildAt(arrCards[i],i);
			}
			
			dispatchEvent(new Event(CardLoader.CARDS_LOADED));
		}
		
		// getCardArray allows the user to gain access to all PlayingCard objects in this CardDeck object.
		public function getCardArray():Array {
			return arrCards;
		}
		
		// getCardAt allows the user to gain access to one particular PlayingCard in this CardDeck object.
		public function getCardAt(i:int):Bitmap {
			return arrCards[i]; //PlayingCard(arrCards[i]);
		}
		
		// getCardIndex returns the index of a particular PlayingCard object in the CardDeck
		public function getCardIndex(bm:Bitmap):int {			
			return arrCards.indexOf(bm);
		}
		
		// Return the number of cards in this CardDeck
		public function numCards():int {
			return arrCards.length;
		}
	}
}
