/* ***********************************************************************
AS3 Class for Flash CS4+ by Doug Ensley of http://www.flashandmath.com/
Last modified: November 20, 2010
************************************************************************ */

package flashandmath.as3.cards {
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.PerspectiveProjection;
	
	/*	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;*/
	
	
	import flash.geom.Vector3D;
	
	public class PlayingCard extends Sprite {
		public static const MOTION_DONE:String = "tweenMotionDone";
		public static const MOTION:String = "tweenMotion";
		
		private var bdFirst:BitmapData;
		private var bdSecond:BitmapData;
		
		private var _isFaceUp:Boolean;
		private var _value:String;
		private var _numValue:int;
		private var _suit:String;
		
		private var picWidth:Number;
		private var picHeight:Number;
		
		private var holder:Sprite;  
		private var side0:Sprite;
		private var side1:Sprite;
		
		private var side0Img:Bitmap;
		private var side1Img:Bitmap;
		
		private var ptFrom:Vector3D;
		private var ptTo:Vector3D;
		private var objTween:Object;
		/*		private var twMove:Tween;*/
		
		private var pp:PerspectiveProjection;
		
		/*
		The constructor of the PlayingCard class takes two BitmapData objects 
		representing the images for the front and the back of the card to be used
		by the class. This will typically be called from the CardDeck class, which 
		first loads all actual image files before constructing the individual cards.
		*/
		
		/**
		 * 
		 * @param bmdFace
		 * @param bmdBack
		 * 
		 */
		public function PlayingCard(bmdFace:BitmapData,bmdBack:BitmapData){	
			ptFrom = new Vector3D(0,0,0);
			ptTo = new Vector3D(0,0,0);
			
			objTween = {t: 0};
			/*			twMove = new Tween(objTween, "t", None.easeIn, 0, 1, 1, true);
			twMove.stop();
			twMove.addEventListener(TweenEvent.MOTION_CHANGE, tweenMover);
			twMove.addEventListener(TweenEvent.MOTION_FINISH, tweenDone);
			*/
			side0Img=new Bitmap(bmdFace);
			side1Img=new Bitmap(bmdBack);
			
			picWidth=side0Img.width;
			picHeight=side0Img.height;
			
			holder=new Sprite();
			this.addChild(holder);
			
			holder.x=picWidth/2;
			holder.y=picHeight/2;
			
			side0=new Sprite();
			holder.addChild(side0);
			
			side0Img.x=-picWidth/2;
			side0Img.y=-picHeight/2;
			
			side0.x=0;
			side0.y=0;
			
			side0.addChild(side0Img);
			
			side1=new Sprite();
			
			holder.addChild(side1);
			
			side1Img.x=-picWidth/2;
			side1Img.y=-picHeight/2;
			
			side1.x=0;
			side1.y=0;
			
			side1.addChild(side1Img);
			
			//In order to appear correctly after a flip, the back side has to be
			//rotated initially.
			
			side1.rotationX = 180;
			_isFaceUp = true;
			
			// We have easy-to-access properties for value and suit so the card can be used in a game,
			// but these values will have to be set at runtime if the programmer wants to use them.
			_value = "";
			_numValue = 0;
			_suit = "";
			
			//Each instance of the PlayingCard class has its own PerspectiveProjection object.
			pp=new PerspectiveProjection();
			pp.fieldOfView=60;
			pp.projectionCenter=new Point(picWidth/2,picHeight/2);
			this.transform.perspectiveProjection=pp;
			
			rotateView(0,"horizontal");	
		}
		
		//End of constructor.
		
		/*		private function tweenMover(twe:TweenEvent):void {
		this.x = ptFrom.x + objTween.t * (ptTo.x - ptFrom.x);
		this.y = ptFrom.y + objTween.t * (ptTo.y - ptFrom.y);
		this.z = ptFrom.z + objTween.t * (ptTo.z - ptFrom.z);
		
		dispatchEvent(new Event(MOTION));
		}
		
		private function tweenDone(twe:TweenEvent):void {
		ptFrom = new Vector3D(0,0,0);
		ptTo = new Vector3D(0,0,0);
		dispatchEvent(new Event(MOTION_DONE));
		}
		*/
		// The tweenMotion method moves the card from coordinages (sx,sy,sz) to coordinates (fx,fy,fz) 
		//  over the course of sec seconds. 
		public function tweenMotion(sx:Number,sy:Number,sz:Number,fx:Number,fy:Number,fz:Number,sec:Number):void {
			ptFrom.x = sx;
			ptFrom.y = sy;
			ptFrom.z = sz;
			
			ptTo.x = fx;
			ptTo.y = fy;
			ptTo.z = fz;
			
			/*			twMove.duration = sec;
			twMove.stop();
			twMove.rewind();
			twMove.start();*/
		}
		
		public function get isFaceUp():Boolean {
			return _isFaceUp;
		}
		
		public function get value():String {
			return _value;
		}
		
		public function set value(v:String):void {
			_value = v;
		}
		
		public function get numValue():int {
			return _numValue;
		}
		
		public function set numValue(v:int):void {
			_numValue = v;
		}
		
		public function get suit():String {
			return _suit;
		}
		
		public function set suit(s:String):void {
			_suit = s;
		}
		
		//The method switchSideUp flips the card immediately -- it is not an animated effect! 
		public function switchSideUp():void {
			if (_isFaceUp) {
				makeFaceDown();				
			}
			else {
				makeFaceUp();
			}
		}
		
		// The following methods, used above, are public so they can be called directly for greater control of the facing of the card.
		public function makeFaceUp():void {
			rotateView(0,"horizontal");
			_isFaceUp = true;
		}
		
		public function makeFaceDown():void {
			rotateView(180,"horizontal");
			_isFaceUp = false;
		}
		
		/* The rotateView method manages the rotation of the card and the correct visibility 
		settings for the two card faces. This avoids depth swapping within the card itself.  
		The value of t is the number of degrees of rotation, where t=0 means the card is face up.
		The spinType (default=vertical) specifies the axis of rotation, always the center of the card. */
		
		public function rotateView(t:Number,spinType:String="vertical"):void {
			var goodT:Number = t - 360*(Math.floor(t/360));
			
			if ( (goodT < 90) || (goodT > 270) ) {
				side0.visible = true;
				side1.visible = false;
			}
			else {
				side0.visible = false;
				side1.visible = true;
			}
			
			if(spinType=="vertical") {
				holder.rotationX = 0;
				holder.rotationY = goodT; } 
			else {
				holder.rotationY = 0;
				holder.rotationX = goodT;
			}
		}
	}
}