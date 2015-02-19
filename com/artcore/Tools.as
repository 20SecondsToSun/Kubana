package com.artcore 
{
	import com.greensock.TweenMax;
	import com.model.vo.SiteInfo;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.external.ExternalInterface;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ypopov
	 */
	public class Tools
	{
		
		public function Tools() 
		{
			
		}
		/*public static function toggleFullScreen():void 
		{
			if (stage.displayState == StageDisplayState.NORMAL)		
				stage.displayState=StageDisplayState.FULL_SCREEN;			
			else							
				stage.displayState=StageDisplayState.NORMAL;
		}*/
		public static function changeColor(obj:DisplayObject,color:uint)
		{
			var newColor:ColorTransform = obj.transform.colorTransform;
			newColor.color = color;
			obj.transform.colorTransform = newColor;
		}
		public static function changeGlattColor(obj:DisplayObject,color:uint)
		{
			TweenMax.to(obj, 0.3, { colorTransform: { tint: color, tintAmount: 1 }} )
		}

		public static function removeAllChild ( aim : MovieClip ): void 
		{			
			var children = new Array();
			var i : int;
			
			for ( i = 0; i < aim.numChildren; i++)			
				children.push(aim.getChildAt(i));			
			
			for ( i=0; i<children.length; i++)			
					children[i].parent.removeChild(children[i]);		
			
		}
		public static function removeAllChildS ( aim : Sprite ): void 
		{			
			var children = new Array();
			var i : int;
			
			for ( i = 0; i < aim.numChildren; i++)			
				children.push(aim.getChildAt(i));	
				
			trace("LENGTH__" + aim.numChildren);
			
			for ( i=0; i<children.length; i++)			
					children[i].parent.removeChild(children[i]);		
			
		}
		public static function clone(source:Object):* 
		{ 
			var myBA:ByteArray = new ByteArray(); 
			myBA.writeObject(source); 
			myBA.position = 0; 
			return(myBA.readObject()); 
		}	
		public static function geturlhttp():String 
		{
			return ExternalInterface.call("window.location.href.toString");
		}
		public static function getLocation():void
		{
			var urlPattern:RegExp = new RegExp("http://(www|).*?\.(com|org|net|ru)","i");
			var found:Object =  urlPattern.exec(geturlhttp());
			
			if (found != null)					
				SiteInfo.getInstance().domain = found[0];			
			
		}			
			
		public static function attachPhoto ( aim : MovieClip, obj:Object, bm:Bitmap): void 
		{				
			removeAllChild(aim);
			
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
			bm.y = 0.5 * (obj.height -  bm.height);
			bm.x = 0.5 * (obj.width  - bm.width);
	
			bm.smoothing = true;
			
			aim.addChild(bm);
			
		}
		public static  function setRegPoint(obj:DisplayObjectContainer, newX:Number, newY:Number):void 
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
		public static  function randomNumber(low:Number=0, high:Number=1):Number
		{
		  return Math.floor(Math.random() * (1+high-low)) + low;
		}
		public static  function traceObject(o:Object):void{
			trace('\n');
		 
			for(var val:* in o){
			trace('   [' + typeof(o[val]) + '] ' + val + ' => ' + o[val]);
			}
		 
			trace('\n');
		}		
		public static  function  getUniqueValues(originalArray:Array):Array
		{
			var lookup:Array=new Array();
			var uniqueArr:Array=new Array();		
	
			
			var num:int;
			for(var idx:int=0;idx < originalArray.length;idx++)
			{
				num=originalArray[idx];
				if(!lookup[num])
				{
					var obj:Object=new Object();
					obj.id=num;
					obj.count=0;
					uniqueArr.push(num);
					lookup[num]=true;
				}
			}
			
			
			//..var un1:Array = new Array();
			//..var sdvig = 5///////////// это парааметр длина массива. передать его надо
			uniqueArr.sort( Array.NUMERIC | Array.DESCENDING);			
			/*for (var i:int = 0; i < uniqueArr.length; i++) 
			{
				var flag = false;
				
				for (var j:int = i+1; j < uniqueArr.length; j++) 
				{					
					if (Math.abs(uniqueArr[i] -uniqueArr[j] )== sdvig )
						flag = true;
					
				}
				if (!flag)	un1.push(uniqueArr[i] );
				
			}	*/		
			
			return(uniqueArr);
		}
		public static  function duplicateDisplayObject( target:DisplayObject, autoAdd:Boolean = false ):DisplayObject
		{
			 var targetClass:Class = Object(target).constructor;
			 var duplicate:Sprite = new targetClass();
			 duplicate.transform = target.transform;
			 duplicate.filters = target.filters;
			 duplicate.cacheAsBitmap = target.cacheAsBitmap;
			 duplicate.opaqueBackground = target.opaqueBackground;
			 if ( target.scale9Grid )
			 {
				  var rect:Rectangle = target.scale9Grid;
				  duplicate.scale9Grid = rect;
			 }

			 if ( autoAdd && target.parent )
			 {
				  target.parent.addChild( duplicate );
			 }
			 return duplicate;
		}
		
		
	}

}