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
	public class circleSlider extends MovieClip
	{
		var rX:Number = 50;
		var rY:Number = 50;
		var numItems:Number = 12;
		var zeroSector:Object = sector(0, rX, rY);
		
		private var dragger:Sprite = new Sprite();
		private var myEllipse:Sprite = new Sprite();
		
		public function circleSlider() 
		{				
			if (satge) setControls();
			else addEventListener(Event.ADDED_TO_STAGE, setControls);	
		}		
		private function setControls(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, setControls);	
			addEventListener(Event.REMOVED_FROM_STAGE, removeControls);
			
			drawEllipse();
			drawDragg();
		}
		private function removeControls(e:Event):void 
		{
			destroy();
		}
		public function  destroy():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeControls);
			dragger.removeEventListener(MouseEvent.MOUSE_DOWN, startDraghandler);		
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraghandler);
		}
		
	
		
		private function drawDragg()
		{			
			
			dragger.graphics.lineStyle(10, 0x002277, 100);
			dragger.graphics.lineTo(0, 1);
			
			dragger.x = zeroSector.x;
			dragger.y = zeroSector.y;
			
			dragger.buttonMode = true;
			dragger.addEventListener(MouseEvent.MOUSE_DOWN, startDraghandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraghandler);
			
			addChild(dragger);
		}
		private function drawEllipse()
		{
			
			myEllipse.x = 0;
			myEllipse.y = 0;
			myEllipse.graphics.lineStyle(0, 0xAAAAAA);
			myEllipse.graphics.moveTo(zeroSector.x, zeroSector.y); 

			for (var d:int = 0; d <= 360; d += 5) 
			{
				var _sector:Object = sector(d, rX, rY);
				myEllipse.graphics.lineTo(_sector.x, _sector.y);
			}
			addChild(myEllipse);
		}
		private function sector(degree:Number, radiusX:Number, radiusY:Number):Object
		{
			var xpos:Number = radiusX * Math.cos(degree * Math.PI / 180);
			var ypos:Number = radiusY * Math.sin(degree * Math.PI / 180);			
			
			return {x:xpos, y:ypos};
		}
		private function startDraghandler(e:MouseEvent):void 
		{			
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveDraghandler);		
			
		}
		private function moveDraghandler(e:MouseEvent):void 
		{			
			  objPosition();
		}
	
		private function objPosition():void 
		{ 
			var ratio:Number = rX / rY;

			var anAngle = Math.atan2(mouseX - myEllipse.x, mouseY - myEllipse.y );
			var deg:Number = 90-(Math.atan2(Math.sin(anAngle), Math.cos(anAngle) * ratio)) * (180 / Math.PI);
			
			var _sector:Object = sector(deg, rX, rY);		
			dragger.x = _sector.x;
			dragger.y = _sector.y;
		}
		private function stopDraghandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveDraghandler);	
		
		}
	
		
		
	}

}