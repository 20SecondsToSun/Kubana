package com.utils 
{
	import com.artcore.image.ImageLoader;
	import com.artcore.Tools;
	import com.artcore.video.events.CustomEvent;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author castor_troy
	 */
	public class FriendHolder extends MovieClip
	{
		public var uid;
		public var uname;
		public var photo;
		public var online;
		private var iml;
		public var checked:Boolean = false;
		public var FrEl:Object;
		public static var ATTACH = "ATTACH";
		public function FriendHolder(_FrEl:Object,i:Number)		
		{
			trace("==", i);
			FrEl = _FrEl;
			
			_name.autoSize = TextFieldAutoSize.LEFT;
			_name.text = FrEl._name;
			uid = FrEl._uid;
			isselect.gotoAndStop(1);
			
			if (FrEl._online) Tools.changeColor(isonline, 0x9ac502);
			
			checker.buttonMode = true;
			//checker.addEventListener(MouseEvent.CLICK, checkHandler);
			
			//if (FrEl.imageBitmap)
		//		Tools.attachPhoto(img, { width:img.width, height:img.height }, FrEl.imageBitmap);
			//else
			//{
				//loadAvatar();
				
				//FrEl.addEventListener(UsersData.imageLoaded, progressCheck);
				//FrEl.loadPhoto();
					
		//	}
		}
		private function loadAvatar():void 
		{
			var urlRequest = new URLRequest(FrEl._photo);
			var loader = new Loader();
				loader.load(urlRequest);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, progressCheck);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function ioErrorHandler(e:Event):void 
		{
			dispatchEvent(new CustomEvent(CustomEvent.IMAGE_LOADED, true, false));
		}
		
		private function progressCheck(e:Event):void 
		{
			var image:Bitmap = (Bitmap)(e.target.content)
				image.smoothing = true;	
			Tools.attachPhoto(img, { width:img.width, height:img.height }, image);
			dispatchEvent(new CustomEvent(CustomEvent.IMAGE_LOADED, true, false));
		}
		
		private function checkHandler(e:MouseEvent):void 
		{
			checked= !checked;			
			if (checked)
				isselect.gotoAndStop(2);
			else
				isselect.gotoAndStop(1);
		}
		
		
	}

}