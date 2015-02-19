
package com.artcore.components.scroll
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.greensock.TweenLite;
	
	public class Scroller extends MovieClip
	{		
		public function Scroller()
		{
			scrollBar_mc.addEventListener(ScrollBarEvent.VALUE_CHANGED, scrollBarMoved);
		}
		
		private function scrollBarMoved(event:ScrollBarEvent):void
		{
			var newX:Number = -event.scrollPercent * (content_mc.width - mask_mc.width);
			TweenLite.to(content_mc, 1, { x:newX } );
		}
	}
}
