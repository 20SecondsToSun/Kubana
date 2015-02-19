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
	public class hSlider extends MovieClip
	{
		public var wheelparam :Number = 15;
		
		public function hSlider() 
		{				
			if (satge) setControls();
			else addEventListener(Event.ADDED_TO_STAGE, setControls);	
		}		
		
		public function setControls(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, setControls);
			addEventListener(Event.REMOVED_FROM_STAGE, removeControls);			
			
			dragger.x = 0;
			dragger.y = bg.y + bg.height - 0.5 * (bg.height);
			
			dragger.buttonMode = true;
			bg.buttonMode = true;
			
			dragger.addEventListener(MouseEvent.MOUSE_DOWN, startDraghandler);
			bg.addEventListener(MouseEvent.CLICK, bgclickhandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraghandler);
			//stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvent);
		}
		public function removeControls(e:Event):void 
		{
			destroy();		
		}
		private function onMouseWheelEvent(event:MouseEvent):void
		{
			
			var endX:Number = event.delta > 0 ? 
							  endX = dragger.x + wheelparam :
							  endX = dragger.x - wheelparam;								  
		
			if (endX >= bg.x + bg.width - dragger.width)
				endX = bg.x + bg.width - dragger.width;
			
			if (endX <= bg.x )
				endX =  bg.x;
				
			showPercent(endX);		
			TweenLite.to(dragger, 0.5, { x:endX/*, onComplete: showPercent*/} );
		}
		public function bgclickhandler(e:MouseEvent):void 
		{
			var endX:Number = mouseX;
			if (endX >= bg.x + bg.width - dragger.width)
				endX = bg.x + bg.width - dragger.width;
			
			if (endX <= bg.x + dragger.width)
				endX =  bg.x;				
			
			showPercent(endX);		
			TweenLite.to(dragger, 0.5, { x:endX/*, onComplete: showPercent*/} );
			try 
			{
				TweenLite.to(bg.msk, 0.5, { width:endX/*, onComplete: showPercent*/} );
			}
			catch (err:Error)
			{
			
			}			
			//bg.msk.width =
		}
		public function startDraghandler(e:MouseEvent):void 
		{
			
			var rect = new Rectangle(bg.x,
									 bg.y + bg.height - 0.5 * (bg.height),
									 bg.width , 0);
			
			dragger.startDrag(false, rect);
			dragger.gotoAndStop(4);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveDraghandler);				
			
		}
		public function resetSlider(pr:Number)
		{
			//dragger.x = 0;
			var endX = pr * bg.width;
			TweenLite.to(dragger, 0.3, { x: endX/*, onComplete: showPercent*/} );
			dragger.y = bg.y + bg.height - 0.5 * (bg.height);
			bg.msk.width = endX;	
		}
		
		public function stopDraghandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveDraghandler);	
			dragger.stopDrag();
			dragger.gotoAndStop(1);		
		}
		public function moveDraghandler(e:MouseEvent):void 
		{			
			showPercent(dragger.x);
		/*	try 
			{
				bg.msk.width = dragger.x;	
			}catch (err:Error)
			{
				
			}*/
			
		}
		public function showPercent(endX:Number):void 
		{			
			var per =   ( endX - bg.x) / ( -bg.x +  bg.width );	
			if (per <= 0) per = 0;
			if (per > 0.999) per = 1;
			dispatchEvent(new PercentEvent(PercentEvent.PERCENT, per));			
		}
		public function destroy():void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeControls);		
			dragger.removeEventListener(MouseEvent.MOUSE_DOWN, startDraghandler);
			bg.removeEventListener(MouseEvent.CLICK, bgclickhandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraghandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveDraghandler);	
			//stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvent);
		}
		
		
		
	}

}