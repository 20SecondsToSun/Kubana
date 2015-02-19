package com.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ypopov
	 */
	public class ServiceFunctions
	{
		
		public function ServiceFunctions() 
		{
			
		}
		public static  function removeAllChild ( aim : MovieClip ): void 
		{			
			var children = new Array();
			var i : int;
			
			for ( i = 0; i < aim.numChildren; i++)
			{
				children.push(aim.getChildAt(i));
			}
			
			for ( i=0; i<children.length; i++)
			{
					children[i].parent.removeChild(children[i]);
			}
			
		}
		public static  function attachPhoto ( aim : MovieClip, obj:Object, bmd:BitmapData ): void 
		{				
			removeAllChild(aim);
			var bm : Bitmap = new Bitmap(bmd);
			
			var k = bm.height / bm.width;
			var k1 = obj.height / obj.width;			
			
			if ( k1 > k)
			{
				bm.width = obj.width;
				bm.scaleY = bm.scaleX;				
			}
			else
			{
				bm.height = obj.height;
				bm.scaleX = bm.scaleY;				
			}			
			bm.y =   - .5*bm.height ;
			bm.x =   - .5*bm.width  ;
			bm.smoothing = true;
			
			aim.addChild(bm);
			
		}
		public static function setRegPoint(obj:DisplayObjectContainer, newX:Number, newY:Number):void 
		{		
			var bounds:Rectangle = obj.getBounds(obj.parent);
			var currentRegX:Number = obj.x - bounds.left;
			var currentRegY:Number = obj.y - bounds.top;
		
			var xOffset:Number = newX - currentRegX;
			var yOffset:Number = newY - currentRegY;
	
			obj.x += xOffset;
			obj.y += yOffset;
		
	
			for(var i:int = 0; i < obj.numChildren; i++) {
				obj.getChildAt(i).x -= xOffset;
				obj.getChildAt(i).y -= yOffset;
			}
		}
	}

}