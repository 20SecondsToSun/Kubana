package com.artcore.components.slider
{
	
	import com.greensock.TweenLite;
	import com.slider.events.PercentEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ypopov
	 */
	public class funcSlider extends MovieClip
	{
		private var dragger:Sprite = new Sprite();

		public function funcSlider() 
		{						
			if (satge) setControls();
			else addEventListener(Event.ADDED_TO_STAGE, setControls);	
		}		
		private function setControls(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, setControls);	
			addEventListener(Event.REMOVED_FROM_STAGE, removeControls);
			
			drawDragg();
			drawLineFunc();			
		}
		private function removeControls(e:Event):void 
		{
			destroy();
		}
		public function destroy():void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removeControls);
			dragger.removeEventListener(MouseEvent.MOUSE_DOWN, startDraghandler);			
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraghandler);
		}
		
		private function drawDragg()
		{				
			dragger.graphics.lineStyle(10, 0x002277, 100);
			dragger.graphics.lineTo(0, 1);			
			
			dragger.buttonMode = true;
			dragger.addEventListener(MouseEvent.MOUSE_DOWN, startDraghandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraghandler);
			
			addChild(dragger);
		}
		private function drawLineFunc():void 
		{
			this.graphics.lineStyle(2,0xAAAAAA);	
			this.graphics.moveTo(0, lineFunc(0));
			
			for (var i:int = 0; i < 550; i++)
			{
				this.graphics.lineTo(i, lineFunc(i));
			}
		}
		private function lineFunc(xPos:Number):Number 
		{	
			return 200 + 100*Math.sin(0.05*xPos);
		}
		
		private function startDraghandler(e:MouseEvent):void 
		{			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveDraghandler);					
		}
		private function moveDraghandler(e:MouseEvent):void 
		{			
			dragger.x = mouseX;
			dragger.y = lineFunc(mouseX);
		}
	
		private function stopDraghandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveDraghandler);			
		}		
		
	}

}