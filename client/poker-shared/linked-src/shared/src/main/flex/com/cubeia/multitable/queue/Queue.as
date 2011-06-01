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

package com.cubeia.multitable.queue
{
	public class Queue
	{
		private var firstNode:QueueNode;
		private var lastNode:QueueNode;
			
		public function isEmpty ():Boolean
	    {
	        return firstNode == null;
	    }
	   
	    public function enqueue(object:Object):void 
	    {
	        var node:QueueNode = new QueueNode();
	        node.object = object;
	        node.next = null;
	        if (isEmpty()) {
	            firstNode = node;
	            lastNode = node;
	        } else {
	            lastNode.next = node;
	            lastNode = node;
	        }
	    }
    
	    public function dequeue():Object {
	        if ( isEmpty() ) {
	            return null;
	        }
	        var object:Object = firstNode.object;
	        firstNode = firstNode.next;
	        return object;
	    }
	    
	    public function peek():Object
	    {
	        if ( isEmpty() ) {
	            return null;
	        }
	        return firstNode.object;
	    }
	}
}
		
