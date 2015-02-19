package com.utils 
{
	import com.greensock.TweenMax;
	import com.model.vo.User;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ...
	 */
	public class Item extends MovieClip
	{
		
		public var urlThumb:String;
		public var urlImage:String;
		public var votes;
		public var user_id;
		public var photo_id;
		
		public var row;
		public var col;
		
		
		public var orient = "v";
		private var loader:Loader;
		
		public var loaded = false;
		public var imageBD = null;
		
		public function Item() 
		{			
			_add.visible = false;
		}
		public function init(initObj:Object)
		{
			photo_id = initObj.id;
			user_id = initObj.user_id ;
			votes = initObj.votes;
			urlThumb = User.getInstance().domain + "/sphotos/" + initObj.photo;
			urlImage = User.getInstance().domain + "/photos/" + initObj.photo;
			
			TweenMax.to(this, 0.1, { colorTransform: { tint:0x000000, tintAmount:0.3 }} );
			this.addEventListener(MouseEvent.MOUSE_OVER, overItemHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, outItemHandler);
			if (!loaded)
				loadphoto(urlThumb);
			else
				ServiceFunctions.attachPhoto(_img, { width:_img.width, height:_img.height }, imageBD);
		}
		
		private function outItemHandler(e:MouseEvent):void 
		{
			TweenMax.to(this, 0.3, { colorTransform: { tint:0x000000, tintAmount:0.3 }} );
		
		}
		
		private function overItemHandler(e:MouseEvent):void 
		{
			TweenMax.to(this, 0.3, { colorTransform: { tint:0x000000, tintAmount:0 }} );
		
		}
		public function loadphoto(url:String)
		{
			var urlRequest:URLRequest = new URLRequest(url);
			loader = new Loader();
			loader.load(urlRequest);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			_add.visible = true;
			buttonMode = false;
			loaded = false;
			TweenMax.to(this, 0.1, { colorTransform: { tint:0x000000, tintAmount:0 }} );
			this.removeEventListener(MouseEvent.MOUSE_OVER, overItemHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, outItemHandler);
		}
		
		private function imageLoaded(e:Event):void 
		{
			preloader.visible = false;
			buttonMode = true;
			loaded = true;
			var image:Bitmap = (Bitmap)(e.target.content)
				image.smoothing = true;
			imageBD = image;
			ServiceFunctions.attachPhoto(_img, { width:_img.width, height:_img.height }, image);		
			
		}
	}

}