
package com.artcore.components.scroll
{
	import flash.events.Event;
	
	public class ScrollBarEvent extends Event
	{
		public static const VALUE_CHANGED = "valueChanged";
		public var scrollPercent:Number;
		
		public function ScrollBarEvent($scrollPercent:Number)
		{
			super(VALUE_CHANGED);
			scrollPercent = $scrollPercent;
		}
		
	}
}
