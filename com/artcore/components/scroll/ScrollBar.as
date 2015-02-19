package com.artcore.components.scroll
{
	import com.utils.Scroll.ScrollBarEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ScrollBar extends MovieClip
	{
		private var yOffset:Number;
		private var yMin:Number;
		private var yMax:Number;	
		public function ScrollBar() 
		{				
			if (satge) setControls();
			else addEventListener(Event.ADDED_TO_STAGE, setControls);	
		}		
		
		public function setControls(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, setControls);
			addEventListener(Event.REMOVED_FROM_STAGE, removeControls);	
			
			yMin = 0;
			yMax = track_mc.height - thumb_mc.height;
			thumb_mc.buttonMode = true;
			thumb_mc.addEventListener(MouseEvent.MOUSE_DOWN, thumbDown);	
			
		}
		
		private function removeControls(e:Event):void 
		{
			destroy();
			
		}
		private function thumbDown(event:MouseEvent):void
		{			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, thumbMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, thumbUp);
			yOffset = mouseY - thumb_mc.y;
		}

		private function thumbUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, thumbUp);
		}

		private function thumbMove(event:MouseEvent):void
		{
			thumb_mc.y = mouseY - yOffset;
			
			if (thumb_mc.y <= yMin)
			{				
				thumb_mc.y = yMin;
			}
			if (thumb_mc.y >= yMax)
			{
				thumb_mc.y = yMax;
			}
			
			dispatchEvent(new ScrollBarEvent(thumb_mc.y / yMax));			
			event.updateAfterEvent();
		}
		public function destroy():void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeControls);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, thumbMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, thumbUp);
			thumb_mc.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
		}
	}
}
