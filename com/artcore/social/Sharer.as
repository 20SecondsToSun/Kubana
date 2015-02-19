package com.artcore.social
{
	import com.debug.Console;
	import com.model.vo.User;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	public class Sharer extends MovieClip
	{
		private static var shareUrlFB						:String = "http://www.facebook.com/sharer.php";
		private static var shareUrlTW						:String = "http://twitter.com/home/";
		private static var shareUrlVK						:String = "http://vkontakte.ru/share.php";
		private static var shareUrlOdnoklassniki			:String = "http://www.odnoklassniki.ru/dk?st.cmd=addShare&st.s=1&st._surl=";
		private static var shareUrlGG						:String = "http://www.livejournal.com/update.bml";
		private static var shareUrlMail						:String = "http://connect.mail.ru/share";
		
		private var socialArr = ["facebook", "vkontakte", "twitter", "livejournal"];
		
		public function Sharer()
		{
var r:URLRequest = new URLRequest("javascript:document.getElementById('popup3').style.display='block';  document.getElementById('black1').style.display='block';");
 navigateToURL(r,'_self');
		}
		
		//{ region 		
		
		private static function openWindowPopup(url:String, window:String = "_blank", features:String = "resizable=0,toolbar=0,width=550,height=260"):void
		{
			//navigateToURL(new URLRequest(url), "_blank");
			Console.log("shareurl", url);
			ExternalInterface.call("window.open", url, window, features);
		}
		public static function shareToMail(url:String="",title:String="", description:String = "", imgLink:String="")
		{			
			var	goto= shareUrlMail+"?url="+ encodeURIComponent(User.getInstance().domain) +"&title="+encodeURIComponent(title)+"&description="+encodeURIComponent(description)+"&imageurl="+encodeURIComponent(imgLink)//+"&noparse="+$getInfoFromSite.toString(); 					
			openWindowPopup(goto);	
		}		
		public static function shareToFacebook($url:String = "", $title:String = "", $description:String = "", $imgLink:String = ""):void
		{			
			var goto:String = shareUrlFB + "?&u=" + encodeURIComponent(User.getInstance().domain + "/fbsharer.php?title=" + $title + "&description=" + $description + "&photo=" + $imgLink + "&url=" + $url);			
			openWindowPopup(goto);
		}
		
		public static function shareToOdnoklassniki($url:String = "", $title:String = "", $description:String = "", $imgLink:String = ""):void
		{
			var goto:String = shareUrlOdnoklassniki + encodeURIComponent(User.getInstance().domain + "/fbsharer.php?title=" + $title + "&description=" + $description + "&photo=" + $imgLink + "&url=" + $url);
			openWindowPopup(goto);		
		}
		
		public static function shareToVkontakte($url:String = "", $title:String = "", $description:String = "", $imgLink:String = ""):void		
		{			
			var goto = shareUrlVK + "?url=" + encodeURIComponent($url) + "&title=" + encodeURIComponent($title) + "&description=" + encodeURIComponent($description) + "&image=" + encodeURIComponent($imgLink) + "&noparse=" +"false";// $getInfoFromSite.toString();
			openWindowPopup(goto);
		}
		
		public static function shareToTwitter($url:String, $text:String = ""):void
		{
			var goto:String = shareUrlTW + "?status=" + encodeURIComponent($url) + " " + encodeURIComponent($text);
			openWindowPopup(goto);
		}
	
	}
}