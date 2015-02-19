package com.utils 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author castor_troy
	 */
	public class IButton 
	{
		
		public function IButton() 
		{
			
		}
		public static function enableButtons(buttons:Array,mc:MovieClip)
		{
			var menumc:MovieClip = mc;
			for (var i:int = 0; i < buttons.length; i++) 
			{				
				(menumc.getChildByName(buttons[i]) as MovieClip).buttonMode = true;				
				(menumc.getChildByName(buttons[i]) as MovieClip).addEventListener(MouseEvent.MOUSE_OUT, outHandler);
				(menumcg.etChildByName(buttons[i]) as MovieClip).addEventListener(MouseEvent.MOUSE_OVER, overHandler);
				(menumc.getChildByName(buttons[i]) as MovieClip).addEventListener(MouseEvent.CLICK, clickHandler);				
			}		
		}
		public static function disableButtons(buttons:Array,mc:MovieClip)
		{
			var menumc:MovieClip = mc;
			for (var i:int = 0; i < buttons.length; i++) 
			{				
				(menumc.getChildByName(buttons[i]) as MovieClip).buttonMode = false;				
				(menumc.getChildByName(buttons[i]) as MovieClip).removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
				(menumc.getChildByName(buttons[i]) as MovieClip).removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
				(menumc.getChildByName(buttons[i]) as MovieClip).removeEventListener(MouseEvent.CLICK, clickHandler);				
			}		
		}		
		private static function overHandler( e:MouseEvent = null):void 
		{			
			e.currentTarget.beginbtn.gotoAndPlay("s1");
		}
		private static function outHandler( e:MouseEvent = null):void 
		{				
			e.currentTarget.beginbtn.gotoAndPlay("s2");
		}	
	}

}