package com.utils.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ypopov
	 */
	public class PhotoStreamReady extends Event 
	{
		public static const READY:String = "READY"
		
		public function PhotoStreamReady(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PhotoStreamReady(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PhotoStreamReady", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}