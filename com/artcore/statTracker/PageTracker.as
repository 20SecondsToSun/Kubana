package com.artcore.statTracker 
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import flash.display.Loader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ...
	 */
	public class PageTracker 
	{			
		public static var instance :PageTracker = new PageTracker();	
		private var tracker:AnalyticsTracker;
		
		private var siteNumber:String = "UA-26967670-1";
	
		public function PageTracker()
		{
			if(instance)
			{
				throw new Error ("We cannot create a new instance. Please use Singleton.getInstance()");
			}
			else
			{				
				tracker= new GATracker( this,siteNumber , "AS3", false ); 			
			}
		}
		public function trackPageview(locationName:String)
		{
			// Goggle
			//tracker.trackPageview(locationName);
			
			// AD River
			//(new Loader()).load(new URLRequest("http://ad.adriver.ru/cgi-bin/rle.cgi?sid=85196&sz=" + locationName + "&bt=21&pz=0&rnd=" + Math.round(Math.random() * 1000000)));
		}
		public static function getInstance():PageTracker
		{
			return instance;
		}
		
	}

}