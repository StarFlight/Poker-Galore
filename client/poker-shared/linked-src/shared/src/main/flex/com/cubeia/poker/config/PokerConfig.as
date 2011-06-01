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

package com.cubeia.poker.config
{
	import com.cubeia.poker.event.PokerEventDispatcher;
	import com.cubeia.poker.event.StyleChangedEvent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	
	/**
	 * Configuration parameters for Cubeia Poker
	 * 
	 * This class holds all parsed config parameters from parameter line and server side
	 * config document. Server side will always override local parameters
	 */
	public class PokerConfig
	{
		private static var _instance:PokerConfig = null;
		
		private var configService:URLLoader;
		
		public var configLoaded:Boolean = false;
		
		// auto connect to host
		public var autoConnect:Boolean = true;
		// poker host address
		public var pokerHost:String = "127.0.0.1";
		// poker host port
		public var pokerPort:String = "4123";
		// port of firebase cross domain policy server
		public var crossDomainPort:String = "4122";
		// default style name
		public var defaultStyleName:String = "sunnight";
		// use handshake
		public var useHandshake:Boolean = false;
		// handshake value
		public var handshake:uint = 0;

		// table configuraitions
		private var _tableLayouts:Array = new Array();
		
		[Bindable]
		public static var allowChangeStyle:Boolean = true;
		// default style names
		[Bindable]
		public static var styles:Array;
		
		private var settings:XML;
		/**
		 * Constructor
		 * 
		 * Since we can't have private constructors, it's hard to implement singletons
		 * we throw an error if there is more than one instance
		 */
		public function PokerConfig()
		{
			if ( _instance != null ) {
				throw new Error("PokerConfig should be used as a singleton");
			}
			
			var request:URLRequest = new URLRequest("settings.xml");
			configService = new URLLoader();
			configService.addEventListener(Event.COMPLETE, onConfigLoaded);
			configService.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			try 
			{
				configService.load(request);
			}
			catch (error:ArgumentError)
			{
				trace("An ArgumentError has occurred.");
			}
			catch (error:SecurityError)
			{
				trace("A SecurityError has occurred.");
			}
			
		}
		
		public function getTableConfig(capacity:int):TableConfig {
			for each ( var tableConfig:TableConfig in _tableLayouts ) {
				if ( tableConfig.numberOfSeats == capacity ) {
					return tableConfig;
				}
			}
			return null;
		}
			
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			Alert.show("An IO error has occurred: " + event.text);
		}
		
		public static function getInstance():PokerConfig
		{
			if ( _instance == null ) {
				_instance = new PokerConfig();
			}
			return _instance;
		} 
		
		private function onConfigLoaded(event:Event):void
		{
			var i:int;
			var dx:int = 0; 
			var dy :int = 0;
			
			settings = XML(event.target.data);
			
			pokerHost = settings.host.@name;
			pokerPort = settings.host.@port;
			
			_instance.defaultStyleName = settings.defaultStyle.@name;
			
			var styleList:XMLList = settings.styles.style;
			
			styles = new Array(styleList.length());
			for ( i = 0; i < styleList.length(); i ++ ) {
				styles[i] = styleList[i].@name;
			}
			//FIXME: Hardcoded for now to externalize to config file 
			// but due to problem of data not loaded correctly, temporary patch
			var pt0:Point = new Point(55+dx, 175+dy); 
			var pt1:Point = new Point(12+dx,320+dy);
			var pt2:Point = new Point(55+dx, 480+dy); 
			var pt3:Point = new Point(310+dx, 535+dy);
			var pt4:Point = new Point(620+dx, 535+dy);
			var pt5:Point = new Point(865+dx, 480+dy);
			var pt6:Point = new Point(915+dx, 320+dy);
			var pt7:Point = new Point(865+dx, 175+dy);
			var pt8:Point = new Point(620+dx, 120+dy);
			var pt9:Point = new Point(310+dx, 120+dy);
			
			var ptBt0:Point = new Point(290+dx, 316+dy);  
			var ptBt1:Point = new Point(262+dx,339+dy); 
			var ptBt2:Point = new Point(270+dx,385+dy); 
			var ptBt3:Point = new Point(375+dx,442+dy); 
			var ptBt4:Point = new Point(690+dx,442+dy); 
			var ptBt5:Point = new Point(695+dx,397+dy);  
			var ptBt6:Point = new Point(725+dx,352+dy); 
			var ptBt7:Point = new Point(700+dx,312+dy);  
			var ptBt8:Point = new Point(697+dx,259+dy); 
			var ptBt9:Point = new Point(387+dx,263+dy);  

			var ptCh0:Point = new Point(130+dx,100+dy);  
			var ptCh1:Point = new Point(240+dx, 5+dy); 
			var ptCh2:Point = new Point(175+dx,-70+dy); 
			var ptCh3:Point = new Point(75+dx,-110+dy); 
			var ptCh4:Point = new Point(75+dx,-110+dy); 
			var ptCh5:Point = new Point(-125+dx,-70+dy); 
			var ptCh6:Point = new Point(-105+dx,40+dy); 
			var ptCh7:Point = new Point(-75+dx, 100+dy); 
			var ptCh8:Point = new Point(75+dx, 105+dy); 
			var ptCh9:Point = new Point(75+dx, 105+dy); 			
			
			var ptCard0:Point = new Point(165+dx,100+dy); 
			var ptCard1:Point = new Point(170+dx, 10+dy); 
			var ptCard2:Point = new Point(155+dx,-95+dy); 
			var ptCard3:Point = new Point(0+dx, -110+dy); 
			var ptCard4:Point = new Point(0+dx,-110+dy);  
			var ptCard5:Point = new Point(-135+dx, -95+dy); 
			var ptCard6:Point = new Point(-155+dx,10+dy); 
			var ptCard7:Point = new Point(-135+dx,100+dy); 
			var ptCard8:Point = new Point(0+dx, 127+dy);  
			var ptCard9:Point = new Point(0+dx, 127+dy);  
			
			
			
			var tableTypes:XMLList = settings.Tables.Table;
			for ( i = 0; i < tableTypes.length(); i ++ )
			{
				var numberOfSeats:int = parseInt(tableTypes[i].@seats);
				var tableConfig:TableConfig = new TableConfig(numberOfSeats);
				
				var seatList:XMLList = tableTypes[i].Seat;
				
				for ( var j:int = 0; j < seatList.length(); j ++ )
				{
					var seatConfig:SeatConfig = new SeatConfig();
					seatConfig.index = parseInt(seatList[j].@index);
					switch( j) {
						case 0: seatConfig.position = pt0;
							seatConfig.buttonPosition = ptBt0;
							seatConfig.chipstackPosition = ptCh0;
							seatConfig.pocketCard1Position = ptCard0;
							seatConfig.pocketCard2Position = new Point(ptCard0.x+28,ptCard0.y);
							break;
						case 1: seatConfig.position = pt1;
							seatConfig.buttonPosition = ptBt1;
							seatConfig.chipstackPosition = ptCh1;
							seatConfig.pocketCard1Position = ptCard1;
							seatConfig.pocketCard2Position = new Point(ptCard1.x+28,ptCard1.y);
							break;
						case 2: seatConfig.position = pt2;
							seatConfig.buttonPosition = ptBt2;
							seatConfig.chipstackPosition = ptCh2;
							seatConfig.pocketCard1Position = ptCard2;
							seatConfig.pocketCard2Position = new Point(ptCard2.x+28,ptCard2.y);
							break;
						case 3: seatConfig.position = pt3;
							seatConfig.buttonPosition = ptBt3;
							seatConfig.chipstackPosition = ptCh3;
							seatConfig.pocketCard1Position = ptCard3;
							seatConfig.pocketCard2Position = new Point(ptCard3.x+28,ptCard3.y);
							break;
						case 4: seatConfig.position = pt4;
							seatConfig.buttonPosition = ptBt4;
							seatConfig.chipstackPosition = ptCh4;
							seatConfig.pocketCard1Position = ptCard4;
							seatConfig.pocketCard2Position = new Point(ptCard4.x+28,ptCard4.y);
							break;
						case 5: seatConfig.position = pt5;
							seatConfig.buttonPosition = ptBt5;
							seatConfig.chipstackPosition = ptCh5;
							seatConfig.pocketCard1Position = ptCard5;
							seatConfig.pocketCard2Position = new Point(ptCard5.x+28,ptCard5.y);
							break;
						case 6: seatConfig.position = pt6;
							seatConfig.buttonPosition = ptBt6;
							seatConfig.chipstackPosition = ptCh6;
							seatConfig.pocketCard1Position = ptCard6;
							seatConfig.pocketCard2Position = new Point(ptCard6.x+28,ptCard6.y);
							break;
						case 7: seatConfig.position = pt7;
							seatConfig.buttonPosition = ptBt7;
							seatConfig.chipstackPosition = ptCh7;
							seatConfig.pocketCard1Position = ptCard7;
							seatConfig.pocketCard2Position = new Point(ptCard7.x+28,ptCard7.y);
							break;
						case 8: seatConfig.position = pt8;
							seatConfig.buttonPosition = ptBt8;
							seatConfig.chipstackPosition = ptCh8;
							seatConfig.pocketCard1Position = ptCard8;
							seatConfig.pocketCard2Position = new Point(ptCard8.x+28,ptCard8.y);
							break;
						case 9: seatConfig.position = pt9;
							seatConfig.buttonPosition = ptBt9;
							seatConfig.chipstackPosition = ptCh9;
							seatConfig.pocketCard1Position = ptCard9;
							seatConfig.pocketCard2Position = new Point(ptCard9.x+28,ptCard9.y);
							break;
					}
					tableConfig.addSeatConfig(seatConfig.index, seatConfig);
				}
				_tableLayouts.push(tableConfig);
			}
			configService.removeEventListener(Event.COMPLETE, onConfigLoaded);
			configService.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			configLoaded = true;
		}

	}
}