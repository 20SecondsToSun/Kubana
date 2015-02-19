package  com.artcore.video
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ngl
	 */
	public class AdaptVideoEvent extends Event 
	{
		public static const INIT			:String	= "AdaptVideoEvent init";
		public static const PROGRESS		:String	= "AdaptVideoEvent progress";
		public static const METADATA		:String	= "AdaptVideoEvent metadata";
		public static const VIDEO_COMPLETE	:String	= "AdaptVideoEvent video complete";
		
		public function AdaptVideoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new AdaptVideoEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AdaptVideoEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}