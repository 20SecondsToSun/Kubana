package com.utils 
{
	import com.greensock.TweenMax;
	import com.model.vo.User;
	import com.socialApi.Sharer;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	import net.NetConnector;
	/**
	 * ...
	 * @author ...
	 */
	public class PhotoHolder extends MovieClip
	{
		private var shiftX = 7;
		private var shiftY = 7;
		
		private var _width  = 97;
		private var _height = 97;
		
		private var user_id ;
		private var photo_id ;
			
		private var __width = 7 * _width + 6 * shiftX;					
		private var	__height = 4 * _height + 3 * shiftY;	
		
		private var side;
		private var urlImage;
		private var loader:Loader;
		
		
		public function PhotoHolder() 
		{
				
		}	
		public function init(_photo_id:Number, _user_id:Number, votes:Number, _urlImage:String,_side:String ):void
		{
			ServiceFunctions.removeAllChild(pht);
			user_id = _user_id;
			photo_id = _photo_id;
			side = _side;
			urlImage = _urlImage;
			preloader.visible = true;
			
			trace("PHOTO_ID__" + photo_id);
			
			
			
			
			icons.score._score.autoSize = TextFieldAutoSize.CENTER;
			icons.score._score.text = votes.toString();
			loadphoto(urlImage)
			var __width;
			switch ("g") 
			{
				case "g":									
					__width = 7 * _width + 6 * shiftX;	
		
				break;
				case "v":
					__width = 4 * _width + 3* shiftX;	
				break;
				default:
			}
			
			fon.width = __width = 4 * _width + 3* shiftX;
			fon.height = __height;	
			
			//pht.height = __height;
			//pht.width = __width - _width - shiftX;		
			
			icons.fon.width = _width+ shiftX;	
			icons.fon.height = __height;
			icons.y = 0;
			
			icons.x = fon.width //- _width - shiftX;
			
			icons.fb.x =  (_width + shiftX - icons.fb.width) * 0.5;
			icons.vk.x =  (_width + shiftX - icons.vk.width) * 0.5;
			icons.tw.x =  (_width + shiftX - icons.tw.width) * 0.5;			
			
			icons.score.x = 0;
			icons.score.y = icons.fon.y +icons.fon.height - icons.score.height - 20;
			icons.fb.y =  (_height + shiftY-icons.fb.height) * 0.5;
			icons.vk.y = (_height + shiftY-icons.vk.height) * 0.5 +(_height + shiftY);
			icons.tw.y = (_height + shiftY - icons.tw.height) * 0.5 +(_height + shiftY) * 2;
			
			icons.fb.buttonMode = icons.vk.buttonMode = icons.tw.buttonMode = true;			
			icons.fb.addEventListener(MouseEvent.MOUSE_OVER, overSocial);
			icons.fb.addEventListener(MouseEvent.MOUSE_OUT, outSocial);
			icons.vk.addEventListener(MouseEvent.MOUSE_OVER, overSocial);
			icons.vk.addEventListener(MouseEvent.MOUSE_OUT, outSocial);
			icons.tw.addEventListener(MouseEvent.MOUSE_OVER, overSocial);
			icons.tw.addEventListener(MouseEvent.MOUSE_OUT, outSocial);
			
			icons.fb.addEventListener(MouseEvent.CLICK, clickSocial);
			icons.vk.addEventListener(MouseEvent.CLICK, clickSocial);
			icons.tw.addEventListener(MouseEvent.CLICK, clickSocial);
			
			
			preloader.y = (__height - preloader.height) * .5;
			preloader.x = (__width - preloader.width) * .5;
		}
		
		private function clickSocial(e:MouseEvent):void 
		{
			var network = e.currentTarget.name;
			var sharedLink = User.getInstance().domain + "/competition/?photo=" + photo_id;			
			switch (network) 
			{
				case "fb":
					Sharer.shareToFacebookPhoto(sharedLink, 
													   User.getInstance().socialTitle,
													   User.getInstance().socialDescriptionPhoto,
													   urlImage);
				break;
				case "vk":
					Sharer.shareToVkontakteMenu(false, sharedLink, 
													   User.getInstance().socialTitle,
													   User.getInstance().socialDescriptionPhoto,
													   urlImage);
				break;
				case "tw":
					Sharer.shareToTwitterMenu( sharedLink, 
											   User.getInstance().socialDescriptionPhoto);
				break;
				default:
			} 			
			NetConnector.instance.photoVote( network, photo_id, User.getInstance().sid, waitForServerLoad);				
			
		}
		
		private function waitForServerLoad():void 
		{
			
		}
		public function loadphoto(url:String)
		{
			var urlRequest:URLRequest = new URLRequest(url);
			loader = new Loader();
			loader.load(urlRequest);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
		}
		
		private function imageLoaded(e:Event):void 
		{
			preloader.visible = false;			
			var image:Bitmap = (Bitmap)(e.target.content)
				image.smoothing = true;			
			ServiceFunctions.attachPhoto(pht, { width:__height, height:__width - _width - shiftX }, image);
			pht.y = -_height-shiftY;
			
			
		}
		private function outSocial(e:MouseEvent):void 
		{
			TweenMax.to(e.currentTarget, 0.2,{colorTransform: {tint: 0x000000, tintAmount: 1}});
		}
		
		private function overSocial(e:MouseEvent):void 
		{
			TweenMax.to(e.currentTarget, 0.2,{colorTransform: {tint: 0xfe440d, tintAmount: 1}});
		}
	}

}