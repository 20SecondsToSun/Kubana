package com.artcore.components.slider.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ypopov
	 */
	public class PercentEvent extends Event 
	{
		public static var PERCENT = "PERCENT";
		
		public var percent : Number;
		
		public function PercentEvent( type:String,per:Number, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.percent  = per;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new PercentEvent(type, percent, bubbles, cancelable);			
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PercentEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}