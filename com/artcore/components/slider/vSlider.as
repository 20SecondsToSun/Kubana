package com.artcore.components.slider
{
	
	import com.greensock.TweenLite;
	import com.slider.events.PercentEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ypopov
	 */
	public class vSlider extends MovieClip
	{
		
		public var wheelparam :Number = 15;
		public var sdvig :Number = 17;
		public var curPercent :Number = 1;
		
		//public var name;
		
		public function vSlider() 
		{				
			if (satge) setControls();
			else addEventListener(Event.ADDED_TO_STAGE, setControls);	
		}	
		
	
		public function setControls(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, setControls);
			addEventListener(Event.REMOVED_FROM_STAGE, removeControls);		
			
			curPercent = perc;
			
			dragger.y = bg.y + 0.1 + (bg.height - dragger.height * 0.5) * (1 - curPercent) - dragger.height * 0.1  ;
			msk.y = dragger.y+1;		
			dragger.x = bg.x - 0.5 * (bg.width - dragger.width)-sdvig;
			
			dragger.buttonMode = true;
			bg.buttonMode = true;
			
			dragger.addEventListener(MouseEvent.MOUSE_DOWN, startDraghandler);
			bg.addEventListener(MouseEvent.CLICK, bgclickhandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraghandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvent);
		}
		public function removeControls(e:Event):void 
		{
			destroy();
		}
		public function destroy()
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeControls);		
			dragger.removeEventListener(MouseEvent.MOUSE_DOWN, startDraghandler);
			bg.removeEventListener(MouseEvent.CLICK, bgclickhandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraghandler);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvent);
		}
		private function onMouseWheelEvent(event:MouseEvent):void
		{
			
			var endY:Number = event.delta > 0 ? 
							  endY = dragger.y +wheelparam :
							  endY = dragger.y -wheelparam;	
							  
			
			if (endY >= bg.y + bg.height - dragger.height)
				endY = bg.y + bg.height - dragger.height;
			
			if (endY <= bg.y)
				endY =  bg.y;				
			showPercent(endY);		
			TweenLite.to(dragger, 0.5, { y:endY/*, onComplete: showPercent*/} );
			TweenLite.to(msk, 0.5, { y:endY+1/*, onComplete: showPercent*/} );
		}
		public function bgclickhandler(e:MouseEvent):void 
		{
			var endY:Number = mouseY;
			if (endY >= bg.y + bg.height - dragger.height)
				endY = bg.y + bg.height - dragger.height;
			
			if (endY <= bg.y + dragger.height)
				endY =  bg.y;
				
			showPercent(endY);	
			TweenLite.to(dragger, 0.5, { y:endY/*, onComplete: showPercent*/} );
			TweenLite.to(msk, 0.5, { y:endY+1/*, onComplete: showPercent*/} );
		}
		public function startDraghandler(e:MouseEvent):void 
		{			
			var rect = new Rectangle(bg.x - 0.5 * (bg.width - dragger.width)-sdvig,
									 bg.y,
									 0,bg.height - dragger.height+3 );
			
			dragger.startDrag(false, rect);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveDraghandler);		
			addEventListener(Event.ENTER_FRAME, dr);
			
		}
		public function dr(e:Event):void 
		{
			msk.y = dragger.y+1;
		}
		public function stopDraghandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveDraghandler);	
			dragger.stopDrag();
			removeEventListener(Event.ENTER_FRAME, dr);
		}
		public function moveDraghandler(e:MouseEvent):void 
		{			
			showPercent(dragger.y);
		}
		public function showPercent(endY:Number):void 
		{
			
			var per =   ( endY - bg.y)/( bg.y + (bg.height - dragger.height) );	
			dispatchEvent(new PercentEvent(PercentEvent.PERCENT, per));			
		}		
		
	}

}