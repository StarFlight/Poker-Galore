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

package com.cubeia.poker.ui
{
	import com.cubeia.poker.config.PokerConfig;
	import com.cubeia.poker.event.PokerEventDispatcher;
	import com.cubeia.poker.event.StyleChangedEvent;
	
	import mx.core.Application;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;

	public class StyledApplication extends Application
	{
		private static var _currentStyle:String;
		
		public function StyledApplication()
		{
			super();
			loadDefaultStyle();
		}
		
		
		/**
		 * Change current style
		 * propagates globally by default through the message bus
		 */ 
		public static function changeStyle(stylename:String, global:Boolean = true):void
		{
			PokerEventDispatcher.dispatch(new StyleChangedEvent(stylename), global);
		}
		
		private function loadDefaultStyle():void
		{
			// Wait for configuration to load
			if ( PokerConfig.getInstance().configLoaded == false ) {
				trace("Call Later for style invoked");
				callLater(loadDefaultStyle);
				return;
			}
			// add event listener
			PokerEventDispatcher.instance.addEventListener(StyleChangedEvent.STYLE_CHANGED_EVENT, onStyleChanged);
			
			changeStyle(PokerConfig.getInstance().defaultStyleName, false);
		}

		private function onStyleChanged(event:StyleChangedEvent):void {
			var styleManager:IStyleManager2 = StyleManager.getStyleManager(null);
			if ( styleManager != null && _currentStyle != null ) {
				styleManager.unloadStyleDeclarations(_currentStyle);
			}
			_currentStyle = "styles/" + event.styleName +"/poker.swf";
			styleManager.loadStyleDeclarations2(_currentStyle, true);
			trace("Style Manager loaded style: "+_currentStyle);
		}

	}
}