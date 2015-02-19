package com.video 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.media.Video;
	/**
	 * ...
	 * @author ypopov
	 */
	public class MainVideo extends MovieClip
	{
		public var va			:VideoAdapt;
		//public var p  = parent.parent as MovieClip;
		
		public var sizeX = 100;
		public var sizeY = 100;
		
		public var path :String;
		
		public function MainVideo()
		{
			if (stage) initplayer();
			else addEventListener(Event.ADDED_TO_STAGE, initplayer);
			
		}
		public function  initplayer(e:Event = null):void 
		{
			//p.btnplay.buttonMode = true;
			//p.btnplay.addEventListener(MouseEvent.CLICK, startplay);
		}
		public function  initparams(sizeX:uint, sizeY:uint, path:String):void 
		{
			this.sizeX  = sizeX;
			this.sizeY  = sizeY;			
			this.path = path;
		}
		public function startplay():void 
		{
			init();
		}
		public function  init():void 
		{
			va = new VideoAdapt();
			//addChild(va)
			va.init(path);
			va.addEventListener(Event.COMPLETE, loadCompleteListener);
			va.addEventListener(ProgressEvent.PROGRESS, progressListener);
			va.addEventListener(AdaptVideoEvent.VIDEO_COMPLETE, videoCompleteListener);
		}
		private function videoCompleteListener(e:AdaptVideoEvent):void
		{			
			//this.visible = false;
		}
		private function progressListener(e:ProgressEvent):void
		{		
			var percent:int	= int(100 * e.bytesLoaded / e.bytesTotal);
			//trace("percent = "+percent)
		}		
		private function loadCompleteListener(e:Event):void
		{			
			var video = new Video(sizeX, sizeY);	
		//	trace("loadCompleteListener")
			video.deblocking = 2;		
			video.attachNetStream(va.stream);			
			addChild(video);			
		}
	}

}