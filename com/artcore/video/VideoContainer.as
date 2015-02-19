package com.artcore.video
{
	import com.greensock.*;
	import com.artcore.components.slider.events.*;
	import com.artcore.video.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.URLRequest;
	import org.osflash.signals.Signal;
	
	public class VideoContainer extends MovieClip
	{
		public var adapter:VideoAdapt;
		private var video:Video;
		
		private static const PATH:String = "videos/organic.flv";
		
		private var lenV = 277;
		private var minusW = 0;
		private var percent;
		
		public static const SKIP_ALL = "SKIP_ALL";
		
		private var videoFinished:Signal= new Signal();
		
		public function VideoContainer()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		
		public function init(e:Event = null)
		{
			
			stage.addEventListener(Event.RESIZE, resizeListener);
			
			adapter = new VideoAdapt();
			adapter.addEventListener(AdaptVideoEvent.VIDEO_COMPLETE, videoCompleteListener);			
			adapter.addEventListener(Event.COMPLETE, loadCompleteListener);
			adapter.addEventListener(ProgressEvent.PROGRESS, progressListener);
			adapter.addEventListener(AdaptVideoEvent.METADATA, metadataVideoListener);
				
			adapter.init(PATH);
			trace(PATH);
			
			preInitButtonControls();
			initButtonControls();
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		public function clear()
		{			
			adapter.removeEventListener(AdaptVideoEvent.VIDEO_COMPLETE, videoCompleteListener);
			adapter.removeEventListener(Event.COMPLETE, loadCompleteListener);
			adapter.removeEventListener(ProgressEvent.PROGRESS, progressListener);
			adapter.removeEventListener(AdaptVideoEvent.METADATA, metadataVideoListener);
			video.attachNetStream(null);
			video.clear();
			adapter.kill();
		
		}
		
		public function skip()
		{
			clear();
			adapter.dispatchEvent(new AdaptVideoEvent(AdaptVideoEvent.VIDEO_COMPLETE))
		
		}		
		private function videoCompleteListener(e:AdaptVideoEvent):void
		{			
			clear();			
		}
		private var swfLoader:Loader;
		private function swfLoadedHandler(e:Event):void 
		{
	
		}
		
		private function skipAll(e:MouseEvent):void 
		{
			clear();
			dispatchEvent(new Event(VideoContainer.SKIP_ALL));
			
		}
		private function progressListener(e:ProgressEvent):void
		{			
			percent = int(Math.floor(100 * e.bytesLoaded / e.bytesTotal));
			
			if (percent > 90 && !video)
			{
				video = new Video();				
				video.deblocking = 2;
				video.attachNetStream(adapter.stream);
				videoContainer.addChild(video);
				resize(0, 0)				
				resizeListener(null);				
			}
			
		}
		
		private function loadCompleteListener(e:Event):void
		{
			var vid:VideoAdapt = VideoAdapt(e.currentTarget)
			trace("loadCompleteListener")
			var meta:MetaInfo = vid.info;
			try
			{
				resize(meta.width, meta.height);
			}
			catch (e:TypeError)
			{
				trace("Ждем метадату")
				adapter.addEventListener(AdaptVideoEvent.METADATA, metadataVideoListener);
				return;
			}
			
			resizeListener(null);
			adapter.play();
		
		}
		
		private function loop(e:Event)
		{
			try
			{
				var progressRatio = percent / 100;
				var fullnessRatio = adapter.currentSecond() / adapter.info.duration;
				(fullnessRatio >= 1)?fullnessRatio = 1:1;
				videoControls.fullness_mc.width = fullnessRatio * lenV - minusW;
				videoControls.progress_mc.width = progressRatio * lenV;				
			}
			catch (err:Error)
			{
				
			}		
		}
		
		/////////////////////////////////////////////////////////// CONTROLS////////////////////////////////////////////////////////////////////////////
		private function preInitButtonControls():void
		{
			videoControls.play_mc.gotoAndStop(2);
			videoControls.bubble.alpha = 0;
			
			//resets the fullness and progress 
			videoControls.fullness_mc.width = 1;
			videoControls.progress_mc.width = 1;
			
			lenV = videoControls.videolen.width;
		
		}
		
		private function initButtonControls():void
		{
			videoControls.play_mc.buttonMode = true;
			videoControls.play_mc.addEventListener(MouseEvent.CLICK, playPausePlayer);
			videoControls.play_mc.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			videoControls.play_mc.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			
			videoControls.mute_mc.buttonMode = true;
			videoControls.mute_mc.addEventListener(MouseEvent.CLICK, muteUnmutePlayer);
			videoControls.mute_mc.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			videoControls.mute_mc.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			
			/*videoControls.getCode.buttonMode = true;
			   videoControls.getCode.addEventListener(MouseEvent.CLICK, getCodeHandler);
			   videoControls.getCode.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			 videoControls.getCode.addEventListener(MouseEvent.MOUSE_OVER, overHandler);*/
			
			/*	videoControls.setQuality.qbtn.buttonMode = true;
			   videoControls.setQuality.qbtn.addEventListener(MouseEvent.CLICK, showQuality);
			   videoControls.setQuality.qbtn.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			 videoControls.setQuality.qbtn.addEventListener(MouseEvent.MOUSE_OVER, overHandler);*/
			
			videoControls.vsl.init();
			videoControls.vsl.addEventListener(PercentEvent.PERCENT, volumeHandler);
			
			videoControls.progress_mc.buttonMode = true;
			videoControls.progress_mc.addEventListener(MouseEvent.CLICK, seekHandler);
			videoControls.progress_mc.addEventListener(MouseEvent.MOUSE_OUT, outHandler1);
			videoControls.progress_mc.addEventListener(MouseEvent.MOUSE_OVER, overHandler1);
			
			videoControls.videolen.buttonMode = true;
			videoControls.videolen.addEventListener(MouseEvent.CLICK, seekHandler);
			videoControls.videolen.addEventListener(MouseEvent.MOUSE_OUT, outHandler1);
			videoControls.videolen.addEventListener(MouseEvent.MOUSE_OVER, overHandler1);
			
			videoControls.fullness_mc.buttonMode = true;
			videoControls.fullness_mc.addEventListener(MouseEvent.CLICK, seekHandler);
			videoControls.fullness_mc.addEventListener(MouseEvent.MOUSE_OUT, outHandler1);
			videoControls.fullness_mc.addEventListener(MouseEvent.MOUSE_OVER, overHandler1);
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function dragBubble(e:MouseEvent)
		{
			
			if (videoControls.mouseX > videoControls.videolen.x && videoControls.mouseX < videoControls.videolen.x + videoControls.videolen.width)
				videoControls.bubble.x = videoControls.mouseX - videoControls.bubble.width * .5;
			
			var curX = videoControls.mouseX - videoControls.videolen.x;
			try
			{
				var poinV = adapter.info.duration * (curX / lenV);
				
				var min = Math.floor(poinV / 60) < 0 ? "0" : Math.floor(poinV / 60).toString();
				var minFormat = Math.floor(poinV / 60) < 10 ? "0" + min : min;
				
				var sec = Math.floor(poinV % 60) < 0 ? "0" : Math.floor(poinV % 60).toString();
				var secFormat = (sec.length == 1) ? "0" + sec : sec;
				
				videoControls.bubble.tm.text = minFormat + ":" + secFormat;
			}
			catch (err:Error)
			{
				
			}
		}
		
		private function seekHandler(e:MouseEvent)
		{
			var curX = videoControls.mouseX - videoControls.videolen.x;
			var poinV = adapter.info.duration * (curX / lenV);
			
			adapter.play(poinV);
			adapter.resume();
			videoControls.play_mc.gotoAndStop(2);
			
			if (videoControls.mouseX < videoControls.progress_mc.x || videoControls.mouseX > videoControls.progress_mc.x + videoControls.progress_mc.width)
			{
				removeEventListener(Event.ENTER_FRAME, loop);
				videoControls.fullness_mc.width = 1;
				videoControls.progress_mc.width = 1;
				
				videoControls.fullness_mc.x = videoControls.mouseX;
				videoControls.progress_mc.x = videoControls.mouseX;
				
				minusW = curX;
				
				addEventListener(Event.ENTER_FRAME, loop);
			}
			else
			{
				TweenLite.to(videoControls.fullness_mc, 0.3, {width: curX});
			}
		
		}
		
		private function overHandler(e:MouseEvent)
		{
			TweenLite.to(e.currentTarget, 0.3, {alpha: 0.8});
		}
		
		private function outHandler(e:MouseEvent)
		{
			TweenLite.to(e.currentTarget, 0.3, {alpha: 1});
		}
		
		private function overHandler1(e:MouseEvent)
		{
			TweenLite.to(videoControls.bubble, 0.3, {alpha: 1});
			addEventListener(MouseEvent.MOUSE_MOVE, dragBubble);
		}
		
		private function outHandler1(e:MouseEvent)
		{
			TweenLite.to(videoControls.bubble, 0.3, {alpha: 0});
			removeEventListener(MouseEvent.MOUSE_MOVE, dragBubble);
		
		}
		
		private function volumeHandler(e:PercentEvent)
		{
			var vol = e.percent;
			videoControls.mute_mc.gotoAndStop(1);
			adapter.setVolume(vol);
		}
		
		private function playPausePlayer(e:MouseEvent)
		{
			if (adapter.isPlaying() == true)
			{
				adapter.pause()
				videoControls.play_mc.gotoAndStop(1);
			}
			else
			{
				adapter.resume();
				videoControls.play_mc.gotoAndStop(2);
			}
		}
		
		private function muteUnmutePlayer(e:MouseEvent)
		{
			if (adapter.isMuted())
			{
				videoControls.mute_mc.gotoAndStop(1);
				adapter.unMute()
			}
			else
			{
				videoControls.mute_mc.gotoAndStop(2);
				adapter.mute()
			}
		}
		
		private function resizeListener(e:Event):void
		{
			if (adapter.info)
			{
				resize(adapter.info.width, adapter.info.height)
			}
			prel.x = .5 * (stage.stageWidth - prel.width);
			prel.y = .5 * (stage.stageHeight - prel.height);
		
		}
		
		private function metadataVideoListener(e:AdaptVideoEvent)
		{
			adapter.removeEventListener(AdaptVideoEvent.METADATA, metadataVideoListener);
			var vid:VideoAdapt = VideoAdapt(e.currentTarget);
			var meta:MetaInfo = vid.info;
			resize(meta.width, meta.height)
			
			adapter.play();
		}
		
		private function resize(_width:Number, _height:Number):void
		{/*			
			var SW =  stage.stageWidth;
			var SH =  stage.stageHeight;
				
			if (video)
			{			
				if (video.videoWidth / video.videoHeight < SW / SH)
				{
					video.width = SW;					
					video.height = video.width * ( 720 / 1280);
				}
				else {
					video.height = SH;				
					video.width = video.height * (1280 /720 );
				}
			
				video.y = Math.floor((SH - video.height) / 2);		
				video.x = Math.floor((SW - video.width) / 2);	
			}
	
			*/
		}
	
	}

}