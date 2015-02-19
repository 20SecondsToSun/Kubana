package com.utils 
{
	import com.utils.events.PhotoStreamReady;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ypopov
	 */
	public class PhotoStream extends EventDispatcher
	{		
		public var photoArr: Array = new Array();
		
		public var photoArrLength:uint = 0;
		
		public var count:uint = 0;
		
		public function PhotoStream() 
		{
			
		}
		
		public function loadphotomass(arr:Array)
		{
			photoArrLength = arr.length;
			
		
			
			for (var j:int =0 ; j < arr.length; j++) 			
			{
				var url = arr[j].url;				
				
				var req:URLRequest = new URLRequest(url);				
				var loader_photo:Loader = new Loader();		
				loader_photo.name = j.toString();
				loader_photo.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadphoto);
				loader_photo.load(req);	
				
			}				
		
		}
		public function onLoadphoto(evt : Event)
		{
			var bm:Bitmap = evt.target.loader.content as Bitmap;	
				bm.smoothing = true;				
				
			var p_obj:Object = new Object();			
				p_obj.id	= Number(evt.target.loader.name);
				p_obj.content =  bm;
				
				photoArr.push(p_obj);
				
				if (photoArr.length == photoArrLength)
				{
				
					dispatchEvent(new PhotoStreamReady(PhotoStreamReady.READY));	
				}
			
		}
		
	}

}