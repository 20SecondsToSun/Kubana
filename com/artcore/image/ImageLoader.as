package com.artcore.image 
{
	import com.artcore.video.events.CustomEvent;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author castor troy
	 */
	public class ImageLoader  extends Sprite 
	{
		// VARIABLES
		private var bitmapdataArray:Array = [];
		private var loader:Loader;
		private var counter:uint = 0;
		private var totalLength:uint=0;
		
		public function ImageLoader()
		{
		}		
		public function loadImages(imagesURL:Array)
		{
			
			totalLength = imagesURL.length;
			counter = 0;
			for (var i:int = 0; i <totalLength ; i++) 
			{			
				var urlRequest:URLRequest = new URLRequest(imagesURL[i]);
				loader = new Loader();
				loader.load(urlRequest);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
			
			
		}
		public function loadImage(imagesURL:String)
		{
		
			var urlRequest:URLRequest = new URLRequest(imagesURL);
			loader = new Loader();
			loader.load(urlRequest);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded1);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		
			
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			
		}
		private function imageLoaded1(e:Event):void 
		{				
			var image:Bitmap = (Bitmap)(e.target.content)
				image.smoothing = true;				
			bitmapdataArray.push(image);			
			dispatchEvent(new CustomEvent(CustomEvent.IMAGE_LOADED, true, false));
			
		}
		private function imageLoaded(e:Event):void 
		{			
			counter++;
			var image:Bitmap = (Bitmap)(e.target.content)
				image.smoothing = true;
				
			bitmapdataArray.push(image);
			
			if (counter == totalLength)
			{
				dispatchEvent(new CustomEvent(CustomEvent.IMAGE_LOADED, true, false));
			}
		}
		public function getBitmaps():Array{
			return bitmapdataArray;
		}
		public function getBitmap():Bitmap{
			return bitmapdataArray[0];
		}
		
	}
	
}