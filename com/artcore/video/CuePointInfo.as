package  com.artcore.video 
{
	/**
	 * ...
	 * @author Ngl
	 */
	public class CuePointInfo
	{
		public var time:Number;
		public var type:String;
		
		public function CuePointInfo(time = 0, type = ""):void
		{
			this.time = time;
			this.type = type;
		}
		
		public function toString():String
		{
			return "[time: "+time+", type: "+type+"]"
		}
	}

}