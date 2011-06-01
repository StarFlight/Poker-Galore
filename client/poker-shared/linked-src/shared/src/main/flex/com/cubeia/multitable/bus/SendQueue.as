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

package com.cubeia.multitable.bus
{
	import com.cubeia.multitable.events.SendFailedEvent;
	import com.cubeia.multitable.queue.Queue;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	public class SendQueue extends EventDispatcher
	{
		private var _pool:Array = new Array();
		private var _currentItem:SendQueueItem;
		private var _queue:Queue = new Queue();
		private var _isActive:Boolean = false;
		private var _lc:LocalConnection;
		private var _busName:String;
		
		public function SendQueue(lc:LocalConnection, busName:String)
		{
			_lc = lc;
			_busName = busName;
		}
		
		public function put(tableid:int, functionName:String, ... args):void
		{
			var item:SendQueueItem;
			if(_pool.length == 0) {
				item = new SendQueueItem();
			}
			else {
				item = _pool.pop() as SendQueueItem;
			}
			item.tableid = tableid;
			item.functionName = functionName;
			item.args = args;
			
			_queue.enqueue(item);
			if ( _isActive == false ) {
				startSendPump();
			}
		}

		private function startSendPump():void
		{
			_lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_lc.addEventListener(StatusEvent.STATUS, onStatus);
			_lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_isActive = true;
			sendNext();
		}

		private function stopSendPump():void
		{
			_lc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_lc.removeEventListener(StatusEvent.STATUS, onStatus);
			_lc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_isActive = false;
		}

		private function sendNext():void
		{
			if ( _queue.isEmpty() ) {
				stopSendPump();
				return;
			}

			_currentItem = _queue.dequeue() as SendQueueItem;
			_lc.send(_busName+"-"+_currentItem.tableid.toString(), _currentItem.functionName, _currentItem.args);
		}

		private function onAsyncError(event:AsyncErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);	
		}
		
		private function onStatus(event:StatusEvent):void
		{
			if ( event.level == "error" ) {
				var newqueue:Queue = new Queue();
				while ( _queue.isEmpty() == false ) {
					var item:SendQueueItem = _queue.dequeue() as SendQueueItem;
					if ( item.tableid != _currentItem.tableid ) {
						newqueue.enqueue(item);
					}
					else {
						_pool.push(item);
					}
				}
				_queue = newqueue;
				dispatchEvent(new SendFailedEvent(_currentItem.tableid));
			}
			_pool.push(_currentItem);
			sendNext();
		}

	}
}


class SendQueueItem {
	public var tableid:int;
	public var functionName:String;
	public var args:Array;
}