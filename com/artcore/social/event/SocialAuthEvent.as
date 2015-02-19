package com.artcore.social.event
{
	import com.data.UserData;
	import flash.events.Event;
	
	
	public class SocialAuthEvent extends Event
	{
		public static const ON_AUTH_COMPLETE:String = "onauthcompletesoc";
		public static const ON_AUTH_FAIL:String = "onauthfailsoc";
		
		public var userData:UserData;
		
		public function SocialAuthEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}