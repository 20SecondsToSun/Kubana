package  com.artcore.video
{
	import com.artcore.video.CuePointEvent;
	import com.artcore.video.AdaptVideoEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Ngl
	 */
	public class VideoAdapt extends EventDispatcher
	{
		// PUBLIC VARIABLES
		public var info:MetaInfo;
		
		// PRIVATE VARIABLES
		
		private var videoURL:String;
		private var _stream:NetStream;
		private var connection:NetConnection;
		
		private var timer:Timer;
		private var playing:Boolean = false;
		
		private var volume = 0.5;	
		
		// PUBLIC FUNCTIONS
		public function VideoAdapt()
		{
			timer = new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, loadProgressListener);
		}
		
		public function init(str_URL:String):void
		{
			trace("INIT VIDEO = " + str_URL);			
			info = null;
			
			videoURL = str_URL;
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);
		}
		
		public function get stream():NetStream
		{
			if (!_stream)
			{
				throw new Error("Потока не существует");
				return null
			}
			return _stream;		
		}	
		
		public function kill()
		{
			connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			//timer.removeEventListener(TimerEvent.TIMER, loadProgressListener);
			timer.stop();
			
			if (_stream)
			{
				_stream.close();
				connection.close()
				playing = false;
			}
		}
		
		// PRIVATE FUNCTIONS
		private function netStatusHandler(event:NetStatusEvent):void
		{
			//trace(event.info.code)
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success": 
				{					
					connectStream();
					dispatchEvent(new AdaptVideoEvent(AdaptVideoEvent.INIT));
					break;
				}
				case "NetStream.Play.StreamNotFound": 
				{
					trace("Unable to locate video: " + videoURL);
					break;
				}
				case "NetStream.Play.Stop": 
				{
					dispatchEvent(new AdaptVideoEvent(AdaptVideoEvent.VIDEO_COMPLETE));
					break;
				}
			}
		}
		
		private function connectStream():void
		{
			_stream = new NetStream(connection);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			var customClient:Object = new Object();
			customClient.onMetaData = on_MetaData;
			customClient.onCuePoint = on_CuePoint;
			_stream.client = customClient;
			
			//timer.addEventListener(TimerEvent.TIMER, loadProgressListener);
			timer.start();
			
			//trace(timer.running);
			//trace(2,videoURL)
			_stream.play(videoURL);
			_stream.bufferTime = 3;
			_stream.pause();
		}
		
		//private function updProgress(e:Event)
		//{
		//_stream.
		//
		//}
		
		public function on_CuePoint(info:Object)
		{
			
			trace("2************************************************** info = " + info.time + " " + info.name)
			dispatchEvent(new CuePointEvent(CuePointEvent.ON_CUE_POINT, new CuePointInfo(info.time, info.name), true));
		}
		
		private function on_MetaData(flvMetaData:Object):void
		{
			info = new MetaInfo();
			info.height = flvMetaData.height;
			info.width = flvMetaData.width;
			info.duration = flvMetaData.duration;
			/*	for (var val in flvMetaData)
			   {
			   trace("flvMetaData."+val+" = "+flvMetaData[val])
			   if (val == "keyframes")
			   {
			   for (var val2 in flvMetaData.keyframes)
			   {
			   trace("flvMetaData.keyframes."+val2+" = "+flvMetaData.keyframes[val2])
			   }
			   }
			 }*/
			//trace("***")
			//trace("flvMetaData.cuePoints = ", flvMetaData.cuePoints);
			info.ar_cue = new Array();
			if (flvMetaData.cuePoints)
			{
				var ar:Array = flvMetaData.cuePoints;
				//var cpInfo:CuePointInfo = new CuePointInfo(obj.time, obj.parameters.type);
				info.ar_cue.push(new CuePointInfo(0, 0));
				for (var i:int = 0; i < ar.length; i++)
				{
					//trace(i + '-----------------------------------------')
					var obj:Object = ar[i]
					for (var val in obj)
					{
						trace("obj." + val + " = " + obj[val])
					}
					var cpInfo:CuePointInfo = new CuePointInfo(obj.time, obj.name);
					info.ar_cue.push(cpInfo);
				}
				
			}
			dispatchEvent(new AdaptVideoEvent(AdaptVideoEvent.METADATA));
		}
		
		private function loadProgressListener(e:TimerEvent)
		{
			//trace("qq")
			_stream.pause();
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _stream.bytesLoaded, _stream.bytesTotal));
			if ((_stream.bytesLoaded == _stream.bytesTotal) && (_stream.bytesTotal > 0))
			{
				
				timer.stop()
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			trace("securityErrorHandler: " + event);
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			// ignore AsyncErrorEvent events.
		}
		public function play(second:Number = 0)
		{
			trace("PLAY")
			_stream.seek(second);
			_stream.resume();
			playing = true;
		}
		
		public function pause()
		{
			_stream.pause();
			playing = false;
		}
		
		public function resume()
		{
			_stream.resume();
			playing = true;
		}
		
		public function isPlaying():Boolean
		{
			return playing;
		}
		
		public function currentSecond():Number
		{
			return _stream.time;
		}
			public function setVolume(vol:Number =1)
		{
			volume = vol;
			var audioTransform: SoundTransform = new SoundTransform(vol);
			_stream.soundTransform = audioTransform;
			
		}
		public function unMute()
		{			
			var audioTransform: SoundTransform = new SoundTransform(volume);
			_stream.soundTransform = audioTransform;
			
		}
		public function mute()
		{			
			var audioTransform: SoundTransform = new SoundTransform(0);
			_stream.soundTransform = audioTransform;			
		}
		public function isMuted():Boolean
		{		
			if (!_stream.soundTransform.volume) return true;
			else return false;
		}
	}

}