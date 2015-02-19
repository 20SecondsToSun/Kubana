package  com.artcore.video
{
	import flash.events.Event;
	import com.artcore.video.CuePointInfo;
	
	/**
	 * ...
	 * @author Ngl
	 */
	public class CuePointEvent extends Event 
	{
		public static const ON_CUE_POINT :String = "CuePointEvent_ON_CUE_POINT";
		
		public var cpiInfo :CuePointInfo;
		
		public function CuePointEvent(type:String, cpiInfo:CuePointInfo, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.cpiInfo	= cpiInfo;
		} 
		
		public override function clone():Event 
		{ 
			return new CuePointEvent(type, cpiInfo, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CuePointEvent", "cpiInfo", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}