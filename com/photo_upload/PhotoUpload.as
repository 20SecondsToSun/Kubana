package com.photo_upload 
{
	import com.adobe.images.JPGEncoder;
	import com.utils.ServiceFunctions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author ypopov
	 */
	public class PhotoUpload extends MovieClip
	{
		private var file		  :FileReference = new FileReference();
		private var loadertostage :Loader;		
		private var JPEG_quality  :Number = 100;
		private var JPEG_name 	  :String = "kubana_vkontakte";		
		
		private var container:MovieClip ;
		
		public static const ATTACHED:String =  "ATTACHED";
		
		public static var pht:PhotoUpload ;
		static public function getInstance() :PhotoUpload
		{
			return pht;
		}
		 public function PhotoUpload(mc:MovieClip) 
		{
			container = mc;
			//if (stage) init();
			//else addEventListener(Event.ADDED_TO_STAGE, init);					
		}
		private function init(e:Event = null)
		{			
			//upload_btn.buttonMode = true;
			//upload_btn.addEventListener(MouseEvent.CLICK, browsePhoto);
			
			//save_photo.buttonMode = true;
			//save_photo.addEventListener(MouseEvent.CLICK, savePhoto);			
		}
		//{ region save photo
		public function savePhoto(mc :MovieClip)
		{			
			createJPG(mc, JPEG_quality ,JPEG_name);			
		}	
		private function createJPG(mc:MovieClip, n:Number, fileName:String) 
		{ 
			var jpgSource:BitmapData = new BitmapData (200, 500);
				jpgSource.draw(mc);
			var jpgEncoder:JPGEncoder = new JPGEncoder(n);
			var jpgStream:ByteArray = jpgEncoder.encode(jpgSource);
			
			var file:FileReference = new FileReference();
				file.save(jpgStream, JPEG_name+ ".jpg");
		 
		/*	var header:URLRequestHeader = new URLRequestHeader ("Content-type", "application/octet-stream");
		 
			//Make sure to use the correct path to jpg_encoder_download.php
			var jpgURLRequest:URLRequest = new URLRequest ("http://test.korol-i-shut.ru/artcr/jpg_encoder_download.php?name=" + fileName + ".jpg");
				jpgURLRequest.requestHeaders.push(header);
				jpgURLRequest.method = URLRequestMethod.POST;
				jpgURLRequest.data = jpgStream;
		 
			var loader:URLLoader = new URLLoader();
			navigateToURL(jpgURLRequest, "_blank");*/
		}

		//} endregion
		public function browsePhoto(e:MouseEvent = null)
		{
			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, completeHandler);
			
			file.browse([new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png")]);
			
			file.addEventListener(Event.COMPLETE, fileCompleteListener);
			file.addEventListener(Event.SELECT, selectListener);			
		}
		private function fileCompleteListener(e:Event):void
		{			
			var bArr:ByteArray = ByteArray(e.target.data);		
			loadertostage = new Loader();
			loadertostage.loadBytes(bArr);
			loadertostage.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteListener);
		}
		private function loaderCompleteListener(e:Event)
		{
			loadertostage.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteListener);
			
			//container.x = container.y = 0;
			
			var bm:Bitmap = Bitmap(e.target.content);			
			var obj:Object = { width:container.hc.width, height:container.hc.height };		
			ServiceFunctions.attachPhoto(container, obj, bm.bitmapData);	
			
			
			
			dispatchEvent (new Event(PhotoUpload.ATTACHED));
			//container.hc.buttonMode = true;
			container.hc.addEventListener(MouseEvent.MOUSE_DOWN, stratDragPhoto);					
		}
		//{ region manipulate with photo
		private function stratDragPhoto(event:MouseEvent):void 
		{
			trace("DOWN");
			container.hc.removeEventListener(MouseEvent.MOUSE_DOWN, stratDragPhoto);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragPhoto);
			container.hc.addEventListener(MouseEvent.MOUSE_MOVE, stratMove);
		}
		private function stratMove(event:MouseEvent):void 
		{
			container.hc.startDrag();
		}
		private function stopDragPhoto(event:MouseEvent):void 
		{
			container.hc.stopDrag();
			
			container.hc.addEventListener(MouseEvent.MOUSE_DOWN, stratDragPhoto);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragPhoto);
			container.hc.removeEventListener(MouseEvent.MOUSE_MOVE, stratMove);		
		}
		//} endregion
		private function selectListener(event:Event):void 
		{
			var file:FileReference = FileReference(event.target);			
			file.load();
		}
		private function completeHandler(e:DataEvent):void
		{
			trace("completeHandler: " + e);
		}
		private function selectHandler(event:Event):void 
		{			
			var file:FileReference = FileReference(event.target);		
		}		
		private function ioErrorHandler(event:IOErrorEvent):void 
		{
			trace("ioErrorHandler: " + event);
		}
		private function progressHandler(event:ProgressEvent):void 
		{
			var file:FileReference = FileReference(event.target);
			trace("progressHandler: name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
	}

}