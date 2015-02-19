package com.utils 
{
	import com.artcore.image.ImageLoader;
	import com.artcore.video.events.CustomEvent;	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ...
	 */
	public class UsersData extends MovieClip
	{
		private var loader:Loader;
		public static const imageLoaded = "IMAGE_LOADED";
		
		public var _uid;
		public var _name;
		public var _photo;
		public var _online;
		public var imageBitmap:Bitmap=null;
		public var _i;
		public var iml
		public function UsersData(uid:Number, __name:String,photo:String, online:int,i:int)
		{
			_i = i;
			
			_uid = uid;				
			_name = __name;			
			_photo = photo;				
			_online = online;			
			
		}
		
		public function loadPhoto()
		{
			iml = new ImageLoader();
			iml.loadImage(_photo);
			iml.addEventListener(CustomEvent.IMAGE_LOADED, imageLoaded);
			
			/*var urlRequest:URLRequest = new URLRequest(_photo);
			loader = new Loader();
			loader.load(urlRequest);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);*/
		}		
		
		private function imageLoaded(e:CustomEvent):void 
		{
			//preloader.visible = false;
			
			imageBitmap = iml.getBitmap();
			imageBitmap.smoothing = true;
			dispatchEvent(new Event("IMAGE_LOADED"));	
				
			//ServiceFunctions.attachPhoto(_img, { width:_img.width, height:_img.height },image);
			
		}
		
	}

}