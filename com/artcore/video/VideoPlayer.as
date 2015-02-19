﻿package com.artcore.video
{
	// IMPORTS
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.artcore.video.events.CustomEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	

	public class VideoPlayer extends Sprite
	{		
		// VARIABLES
		private var _videoLoaded:Boolean = false;
		private var _videoPlaying = false;
		private var _volumeActive:Boolean = false;
		private var _progressActive:Boolean = false;
		private var _previousVolume:Number;
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _videoTimer:Timer;
		private var _videoObject:Object;
		private var _clientObject:Object;
		private var _videoSetup:Object;
//		private var _info:Information;
		private var _ready:Boolean = true;
		private var _added:Boolean = false;
		//private var _preloader:Sprite = new Sprite();//PleaseWeit();						// preloader animaton		
		
		public function VideoPlayer(obj:Object=null)
		{
			super();
			
			_videoSetup = new Object();
			if (obj) _videoSetup = obj;
			else 
			{			
				_videoSetup.bufferTime = 3;
				_videoSetup.smoothing = true;			
				_videoSetup.width = 0;
				_videoSetup.height = 0;
				_videoSetup.duration = 0;
				_videoSetup.maxWidth = 500;
				_videoSetup.maxHeight = 500;
				_videoSetup.autoAdjust = 0;
				_videoSetup.volume = 1;
				_videoSetup.src = "videos/organic.flv";
			}			
			_preloader.alpha = 0;	
			
			// we check the autoAdjust property
			this.addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove, false, 0, true);
			setupVideoPlayer();
			
		}
		
		private function added(e:Event):void {
			//when player added to stage we call the setup funciton
			if(this.alpha != 1){
				if(_preloader.x == 0 || _preloader.y == 0){
					this.dispatchEvent(new CustomEvent(CustomEvent.ADJUST_VIDEO));
				}
																		// set prelaoder alpha, x and y
				var obj:Object = _preloader.getChildByName("tekst");							// link obj to the preloaders text, then to txt and title
				
				if(obj.getChildByName("txt") != null){
					obj = obj.getChildByName("txt");
					obj = obj.getChildByName("title");
					//obj.text = _videoSetup.preloading;														// then assign to it the "LOADING XML" title
					this.parent.addChild(_preloader);
					TweenMax.to(_preloader, 1, {alpha:1, ease:Expo.easeOut});
				}
			}
			this.adjustPlayer();
			stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
		}
		public function setPreloaderXY(w:Number, h:Number):void{
			if(_preloader){
				_preloader.x = w / 2;
				_preloader.y = h / 2;
			}
			if(_preloader.x == 0 || _preloader.y == 0){
				this.dispatchEvent(new CustomEvent(CustomEvent.ADJUST_VIDEO));
			}
		}
		public function hidePreloader():void {
			if(_preloader && this.parent.contains(_preloader)){
				TweenMax.to(_preloader, 1, {alpha:0, ease:Expo.easeOut, onComplete:removeLoader, onCompleteParams:[_preloader]});
			}
		}
		private function removeLoader(obj:Sprite):void{
			if(obj && this.parent.contains(obj)){
				this.parent.removeChild(obj);
				obj = null;
			}
		}
		private function onRemove(e:Event):void {
			stage.removeEventListener(Event.RESIZE, onResize);
			removeLoader(_preloader);
			if(_videoPlaying)
				playClick(null);
		}
		private function setupVideoPlayer():void {
			// we setup the basic properties of the player, we add the event lsitners to he buttons setup netConnection and netStream and also add the controls
			controlPanel.scrubVideo.playPosition.width = 1;
			controlPanel.scrubVideo.buffer.width = 1;
			
			controlPanel.scrubVideo.buffer.mouseChildren = controlPanel.scrubVideo.buffer.mouseEnabled = false;
			controlPanel.scrubVideo.playPosition.mouseChildren = controlPanel.scrubVideo.playPosition.mouseEnabled = false;
			
			controlPanel.scrubVideo.track.mouseChildren = false;
			controlPanel.scrubVideo.track.buttonMode = true; 
			controlPanel.scrubVideo.thumb.buttonMode = controlPanel.stopVideo.buttonMode = controlPanel.playVideo.buttonMode = true;
			controlPanel.scrubVideo.thumb.mouseChildren = controlPanel.stopVideo.mouseChildren = controlPanel.playVideo.mouseChildren = false;
			
			controlPanel.stopVideo.addEventListener(MouseEvent.CLICK, stopClick, false, 0, true);
			controlPanel.stopVideo.addEventListener(MouseEvent.ROLL_OVER, bOver, false, 0, true);
			controlPanel.stopVideo.addEventListener(MouseEvent.ROLL_OUT, bOut, false, 0, true);
			controlPanel.playVideo.addEventListener(MouseEvent.CLICK, playClick, false, 0, true);
			controlPanel.playVideo.addEventListener(MouseEvent.ROLL_OVER, bOver, false, 0, true);
			controlPanel.playVideo.addEventListener(MouseEvent.ROLL_OUT, bOut, false, 0, true);
			
			videoButton.buttonMode = true;
			videoButton.doubleClickEnabled = true;
			videoButton.addEventListener(MouseEvent.DOUBLE_CLICK, videoClick, false, 0, true);
			videoButton.addEventListener(MouseEvent.ROLL_OUT, videoOut, false, 0, true);
			videoButton.addEventListener(MouseEvent.ROLL_OVER, videoOver, false, 0, true);
		
			_videoTimer = new Timer(10);
			_videoTimer.addEventListener(TimerEvent.TIMER, updateVideo, false, 0, true);
			
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, netStatus, false, 0, true);
			_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, doAsyncError, false, 0, true);
			_nc.addEventListener(IOErrorEvent.IO_ERROR, doIOError, false, 0, true);

			_nc.connect(null);
			
			_ns = new NetStream(_nc);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, netStatus, false, 0, true);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, doAsyncError, false, 0, true);
			_ns.addEventListener(IOErrorEvent.IO_ERROR, doIOError, false, 0, true);
			_clientObject = new Object();
			_clientObject.onMetaData = doMetaData;
			_ns.client = _clientObject;
			_ns.bufferTime = _videoSetup.bufferTime;

			videoDisplay.attachNetStream(_ns);
			videoDisplay.smoothing = _videoSetup.smoothing;
			
			if(_videoSetup.duration != undefined && _videoSetup.width != undefined && _videoSetup.height != undefined && _videoSetup.duration != 0 && _videoSetup.width != 0 && _videoSetup.height != 0){
				_videoObject = new Object();
				_videoObject.duration = _videoSetup.duration;
				_videoObject.width = _videoSetup.width;
				_videoObject.height = _videoSetup.height;
			//	trace(_videoObject.duration);
			//	trace(_videoObject.width);
			//	trace(_videoObject.height);
				
			}
			
			controlPanel.volumeVideo.volumeControl.thumb.y = 84 - (84 * 0);                                                                 
			var st = new SoundTransform((84 - controlPanel.volumeVideo.volumeControl.thumb.y) / 84);
			_ns.soundTransform	= st;
			controlPanel.volumeVideo.volumeControl.fill.height = 84 - controlPanel.volumeVideo.volumeControl.thumb.y;
			adjustPlayer();
			playClick(null);
			
			var timer:Timer = new Timer(2000,1);
			timer.addEventListener(TimerEvent.TIMER, timerTick, false, 0, true);
			timer.start();
	
		}
		private function doMetaData(infoObject:Object):void {
			_videoObject = infoObject;
			_ready = true;
			this.dispatchEvent(new CustomEvent(CustomEvent.VIDEO_READY));
			trace(_videoObject.duration);
			trace(_videoObject.width);
			trace(_videoObject.height);
			adjustPlayer();
		}
		private function doAsyncError(e:AsyncErrorEvent):void {
			trace("async video error");
		}
		private function doIOError(e:IOErrorEvent):void {
			trace("IO video error");
		}
		private function videoClick(e:MouseEvent):void {
			this.dispatchEvent(new CustomEvent(CustomEvent.VIDEO_CLICK));
		
		}
		private function videoOver(e:MouseEvent):void {
			/*_info = new Information(_videoSetup.rollOver);
			_info.alpha = 0;
			
			_info.x = (bg.width - _info.width) * 0.5;
			_info.y = (bg.height - _info.height) * 0.5;
			
			this.addChild(_info);
			
			TweenMax.to(_info, 1, {alpha:1, ease:Expo.easeOut});*/
		}
		private function videoOut(e:MouseEvent):void {
			//if(_info)
			//	TweenMax.to(_info, 1, {alpha:0, ease:Expo.easeOut, onComplete:removeObject, onCompleteParams:[_info]});
		}
		private function removeObject(obj:DisplayObject):void {
			if(obj != null && this.contains(obj)){
				this.removeChild(obj);
			}
		}
		private function timerTick(e:TimerEvent):void {
			if(_ready){
				this._videoPlaying = true;
				controlPanel.volumeVideo.volumeControl.thumb.y = 84 - (84 * _videoSetup.volume);       
				controlPanel.volumeVideo.volumeControl.fill.height = 84 - (84 * _videoSetup.volume); 
				var st = new SoundTransform(_videoSetup.volume);
				_ns.soundTransform	= st;
				_ns.seek(0);
				playClick(null);
			} else {
				_ns.play(_videoSetup.src);
				e.target.reset()
				e.target.start();
			}
		}		
		private function activateAditionalFunctions():void {
			// here we active the scroll bar (volume and the progress bar) to work properly 
			controlPanel.scrubVideo.thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbClick, false, 0, true);
			controlPanel.scrubVideo.track.addEventListener(MouseEvent.CLICK, trackClick, false, 0, true);
		
			if(stage != null)
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);

			controlPanel.volumeVideo.bg.buttonMode = true;
			controlPanel.volumeVideo.bg.addEventListener(MouseEvent.ROLL_OVER, volumeOver, false, 0, true);
			controlPanel.volumeVideo.bg.addEventListener(MouseEvent.ROLL_OUT, volumeOut, false, 0, true);
			
			controlPanel.volumeVideo.volumeControl.thumb.buttonMode = true;
			controlPanel.volumeVideo.volumeControl.thumb.mouseChildren = false;
			controlPanel.volumeVideo.volumeControl.maska.mouseEnabled = false;
			controlPanel.volumeVideo.volumeControl.thumb.addEventListener(MouseEvent.MOUSE_DOWN, volumeThumbClick, false, 0, true);

		}
		private function volumeOver(e:MouseEvent):void {
			// event handler volume over
			TweenMax.to(controlPanel.volumeVideo.volumeControl.maska, 1, {height:100, ease:Expo.easeOut});
		}
		private function volumeOut(e:MouseEvent):void {
			// event handler volume out
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove, false, 0, true);
			
		}
		private function onMove(e:MouseEvent):void {
			// when mouse move while over the panel
			if(this.mouseX <= controlPanel.width && this.mouseX > controlPanel.width - controlPanel.volumeVideo.width){	
				this.alpha = 1;
			} else {		
				TweenMax.to(controlPanel.volumeVideo.volumeControl.maska, 0.5, {height:1, delay:1, ease:Expo.easeOut});
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			}
			
			e.updateAfterEvent();
		}
		private function trackClick(e:MouseEvent):void {
			// track the position of the click on the scroll panel
			_progressActive = true;
			var _x:Number = mouseX - controlPanel.scrubVideo.x;
			if(_x > controlPanel.scrubVideo.track.width)
				_x = controlPanel.scrubVideo.track.width + 6;
			
			TweenMax.to(controlPanel.scrubVideo.thumb, 0.5, {x:_x, ease:Expo.easeOut, onComplete:mouseUp});
		}
		private function mouseUp(e:MouseEvent = null):void {
			// when mouse released we have to stop fallowing mouse
			controlPanel.scrubVideo.thumb.stopDrag();
			controlPanel.volumeVideo.volumeControl.thumb.stopDrag();
			_volumeActive = _progressActive = false;
		}
		private function volumeThumbClick(e:MouseEvent):void {
			// event handler volume thumbnail clicked
			_volumeActive = true;
			controlPanel.volumeVideo.volumeControl.thumb.startDrag(false, new Rectangle(15, 84, 0, -controlPanel.volumeVideo.volumeControl.track.height)); 
		}
		private function thumbClick(e:MouseEvent):void {
			// event handler video thumbnail clicked
			_progressActive = true;
			controlPanel.scrubVideo.thumb.startDrag(false, new Rectangle(6, 15, controlPanel.scrubVideo.track.width, 0));
		}
		private function updateVideo(e:TimerEvent):void {
			// on each new frame update the video
			if(_videoObject) {
				if(_progressActive)
					_ns.seek((controlPanel.scrubVideo.thumb.x - 6) * _videoObject.duration / controlPanel.scrubVideo.track.width);
				else
					controlPanel.scrubVideo.thumb.x = 6 + (_ns.time * controlPanel.scrubVideo.track.width/ _videoObject.duration);	
			}
			
			if(_volumeActive) {
				var st = new SoundTransform((84 - controlPanel.volumeVideo.volumeControl.thumb.y) / 84);
				_ns.soundTransform	= st;

				controlPanel.volumeVideo.volumeControl.fill.height = 84 - controlPanel.volumeVideo.volumeControl.thumb.y;
			}

			if(_videoObject)
				controlPanel.timeVideo.title.text = setupTime(_ns.time) + " / " + setupTime(_videoObject.duration);
			else
				controlPanel.timeVideo.title.text = setupTime(_ns.time);
			controlPanel.scrubVideo.playPosition.width = controlPanel.scrubVideo.thumb.x - 6;
			controlPanel.scrubVideo.buffer.width = _ns.bytesLoaded * controlPanel.scrubVideo.track.width / _ns.bytesTotal;
		}

		public function playClick(e:MouseEvent):void {
			// event handler play button click, if video playing then pouse otherwise play video
			if(!_videoPlaying){
				if(!_videoLoaded){
					_ns.play(_videoSetup.src);
					_videoLoaded = true;
				} else {
					_ns.resume();
				}
				
				_videoPlaying = true;
				TweenMax.to(controlPanel.playVideo.pauseIcon, 1, {alpha:1, ease:Expo.easeOut});
				TweenMax.to(controlPanel.playVideo.playIcon, 1, {alpha:0, ease:Expo.easeOut});
			} else {
				_videoPlaying = false;
				_ns.pause();
				TweenMax.to(controlPanel.playVideo.pauseIcon, 1, {alpha:0, ease:Expo.easeOut});
				TweenMax.to(controlPanel.playVideo.playIcon, 1, {alpha:1, ease:Expo.easeOut});

			}
				
				videoDisplay.visible = true;
		} 
		public function pouse():void {
			// pouse video, this function is called when the page is changed
			if(_videoPlaying){
				_videoPlaying = false;
				_ns.pause();
				TweenMax.to(controlPanel.playVideo.pauseIcon, 1, {alpha:0, ease:Expo.easeOut});
				TweenMax.to(controlPanel.playVideo.playIcon, 1, {alpha:1, ease:Expo.easeOut});
			}
		}
		public function adjustPlayer():void {
			// when the width or height is changed we have to adjust the video players dimentions  
			var vw:int;
			var vh:int;
			var multiply:Number;
			if(_videoObject){
				if(_videoSetup.autoAdjust){
					vw = _videoSetup.maxWidth;
					vh = _videoSetup.maxHeight;
					
					if(_videoObject.width < _videoSetup.maxWidth)
						vw = _videoObject.width;
					
					if(_videoObject.height < _videoSetup.maxHeight)
						vh = _videoObject.height;
						
					if(videoDisplay.width >= videoDisplay.height) {
						multiply = vw / videoDisplay.width;
						vh = videoDisplay.height * multiply;
					} else {
						multiply = vh / videoDisplay.height;
						vw = videoDisplay.width * multiply;
					}
					
				} else {
					vw = _videoSetup.maxWidth;
					vh = _videoSetup.maxHeight;
					
					if(_videoObject.width >= _videoObject.height) {
						multiply = vw / _videoObject.width;
						vh = _videoObject.height * multiply;
						
						if(vh > _videoSetup.maxHeight){
							vh = _videoSetup.maxHeight;
							multiply = vh / _videoObject.height;
							vw = _videoObject.width * multiply;
						}
						
						if(vw > _videoSetup.maxWidth){
							vw = _videoSetup.maxWidth;
							multiply = vw / _videoObject.width;
							vh = _videoObject.height * multiply;
						}
						
					} else {
						multiply = vh / _videoObject.height;
						vw = _videoObject.width * multiply;
						
						if(vw > _videoSetup.maxWidth){
							vw = _videoSetup.maxWidth;
							multiply = vw / _videoObject.width;
							vh = _videoObject.height * multiply;
						}
					}
				}
			} else {
				vw = _videoSetup.maxWidth;
				vh = _videoSetup.maxHeight;				
				
				multiply = vw / videoDisplay.width;
				vh = videoDisplay.height * multiply;
					
				if(vh > _videoSetup.maxHeight){
					vh = _videoSetup.maxHeight;
					multiply = vh / videoDisplay.height;
					vw = videoDisplay.width * multiply;
				}
					
				if(vw > _videoSetup.maxWidth){
					vw = _videoSetup.maxWidth;
					multiply = vw / videoDisplay.width;
					vh = videoDisplay.height * multiply;
				}
			}
			
				videoDisplay.x = 5;
				videoDisplay.y = 5;
				videoDisplay.width = vw;
				videoDisplay.height = vh;	
				videoButton.width = vw;
				videoButton.height = vh;	
				
				bg.width = vw + 10;
				bg.height = vh + 10;
				controlPanel.volumeVideo.x = vw + 10 - controlPanel.volumeVideo.width;
				controlPanel.volumeVideo.y = vh + 12;
				controlPanel.timeVideo.x = vw + 10 - controlPanel.volumeVideo.width - controlPanel.timeVideo.width - 2;
				controlPanel.timeVideo.y = vh + 12;
				controlPanel.scrubVideo.y = vh + 12;
				controlPanel.playVideo.y = vh + 12;
				controlPanel.stopVideo.y = vh + 12;
				controlPanel.scrubVideo.bg.width = vw + 10 - controlPanel.volumeVideo.width - controlPanel.timeVideo.width - 2 - controlPanel.scrubVideo.x - 2;
				controlPanel.scrubVideo.track.width = vw + 10 - controlPanel.volumeVideo.width - controlPanel.timeVideo.width - 17 - controlPanel.scrubVideo.x - 2;
				/*if(_info != null){
					_info.x = (bg.width - _info.width) * 0.5;
					_info.y = (bg.height - _info.height) * 0.5;
				}*/
				dispatchEvent(new CustomEvent(CustomEvent.ADJUST_VIDEO, true, false));
				if(_videoPlaying && _ready) 
					adjustCompleted();
		}
		private function adjustCompleted():void {
			// when the adjust is completed we set the scrubers to be at the begening
			_videoTimer.start();
			controlPanel.scrubVideo.buffer.visible = true;
			activateAditionalFunctions();
			controlPanel.volumeVideo.volumeControl.fill.height = 84 - controlPanel.volumeVideo.volumeControl.thumb.y;
			dispatchEvent(new CustomEvent(CustomEvent.ADJUST_VIDEO, true, false));
		}
		private function onResize(e:Event):void {			
			dispatchEvent(new CustomEvent(CustomEvent.ADJUST_VIDEO, true, false));
		}
		private function netStatus(e:NetStatusEvent):void {
			// here we check if the net status changed
			if(e.info.code == "NetStream.Play.StreamNotFound")
				trace("Error, sream not found");
			if(e.info.code == "NetStream.Play.Stop"){
				stopClick(null);	
				trace("video finished");
			}
		}
		public function stopClick(e:MouseEvent):void {
			// stop click handler, simply stop the video
			_ns.pause();
			_ns.seek(0);
			_videoPlaying = false;
			TweenMax.to(controlPanel.playVideo.pauseIcon, 1, {alpha:0, ease:Expo.easeOut});
			TweenMax.to(controlPanel.playVideo.playIcon, 1, {alpha:1, ease:Expo.easeOut});
		}
		private function bOver(e:MouseEvent):void {
			// roll over event handler			
			TweenMax.to(e.target, 1, {alpha:0.8, ease:Expo.easeOut});
		}
		private function bOut(e:MouseEvent):void {
			// roll out event handler
			TweenMax.to(e.target, 1, {alpha:1, ease:Expo.easeOut});
		}		
		public function get src():String{
			return _videoSetup.src;
		}
		public function get videoHeight():Number{
			return _videoObject.height;
		}
		public function get videoWidth():Number{
			return _videoObject.width;
		}
		public function get videoDuration():Number{
			return _videoObject.duration;
		}
		public function get playing():Boolean {
			return _videoPlaying;
		}
		public function get ready():Boolean{
			return _ready;
		}
		public function set onStage(tmp:Boolean):void {
			_added = tmp;
		}
		public function get onStage():Boolean {
			return _added;
		}
		public function setMax(width:int, height:int):void {
			// here we can set the maximum width and height
			_videoSetup.maxWidth = width;
			_videoSetup.maxHeight = height;
			adjustPlayer();
		}
		private function setupTime(time:int):String {
			// here we setup the timer time 
			var seconds:int = Math.round(time);
			var minutes:int = 0;
			if(seconds > 0){
				while (seconds > 59){
					minutes++;
					seconds -= 60;
				}
				var str:String = "";
				if(minutes < 10)
					str = "0" + minutes + ":";
				else 
					str = minutes + ":";	
					
				if(seconds < 10)
					str += "0" + seconds;
				else 
					str += seconds;
					
				return str;			
			} else {
				return "00:00";
			}
		}
	}
}