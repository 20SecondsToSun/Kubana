package com
{
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.artcore.debug.TextFieldDebug;
	import com.greensock.TweenLite;
	import com.photo_upload.PhotoUpload;
	import com.utils.ServiceFunctions;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.ByteArray;
	import ru.inspirit.net.MultipartURLLoader;
	import vk.APIConnection;
	
	/**
	 * ...
	 * @author ypopov
	 */
	public class Main extends MovieClip
	{
		private var __num:int = 5;
		private var angle = 0;
		private var scalep = 1;
		private var flashVars;
		private var VK:APIConnection;
		private var debugTF;
		private var defaultPosition:Array = [];
		private var defaultScale:Array = [];	
		public var af = 1;
		public var currentClip:MovieClip;
		public var pht:PhotoUpload;
		
		public var lang:String = "RU";
		
		public function Main()
		{
			stage ? init() : addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void
		{			
			t2.mouseEnabled = false;
			controlBlock.visible = false;
			tint.visible = false;
			tabEnabled = false;
			stage.tabChildren = false;
			ru.buttonMode = true;
			lat.buttonMode = true;
			ru.addEventListener(MouseEvent.CLICK, toggleLang);
			lat.addEventListener(MouseEvent.CLICK, toggleLang);
			
			for (var i:int = 1; i <= __num; i++)
			{
				with (this["ava" + i])
				{
					addEventListener(MouseEvent.CLICK, chooSE);
					addEventListener(MouseEvent.MOUSE_OVER, overSE);
					addEventListener(MouseEvent.MOUSE_OUT, outSE);
					txt.visible = false;
					txt.text = "";
					buttonMode = true;
					//scaleX = scaleY = 0.6;
				}
				defaultPosition.push({x: this["ava" + i].x, y: this["ava" + i].y});
				defaultScale.push({scaleX: this["ava" + i].scaleX, scaleY: this["ava" + i].scaleY});
			}			
			//initOne("ava1");	
			
			flashVars = stage.loaderInfo.parameters as Object;
			if (!flashVars.api_id)
			{
				flashVars['api_id'] = 2754643;
				flashVars['viewer_id'] = 1049327;
				flashVars['sid'] = "ab040245200800f41a71d9701253dd9430586d0e9355b4ff9bf640b6f7df2f";
				flashVars['secret'] = "1755d5757e";
				
			}
			VK = new APIConnection(flashVars);
			debugInit();
		}
		
		private function toggleLang(e:MouseEvent):void 
		{
			var cadr:int = 1;
			if (e.currentTarget.name == "ru")
			{
				lang = "RU";
				cadr = 1;
			}
			else
			{
				lang = "LAT";
				cadr = 2;
				
			}
			
			for (var i:int = 1; i <= __num; i++)
			{
				with (this["ava" + i])
				{
					art.gotoAndStop(cadr);
				}
			}
			t1.gotoAndStop(cadr);
			t2.gotoAndStop(cadr);
			
			with (controlBlock)
			{
				upload.gotoAndStop(cadr);
				savebtn.gotoAndStop(cadr);
				movebtn.gotoAndStop(cadr);
				sizebtn.gotoAndStop(cadr);
				rotbtn.gotoAndStop(cadr);	
				rotl.gotoAndStop(cadr);
				rotr.gotoAndStop(cadr);
				pll.gotoAndStop(cadr);
				minr.gotoAndStop(cadr);
				ava.gotoAndStop(cadr);
				writebtn.gotoAndStop(cadr);
			}
		}
		
		public function debugInit():void
		{
			debugTF = new TextFieldDebug();			
			debugTF.getTextField().appendText("sid77=" + flashVars['sid']);
			debugTF.getTextField().appendText("\n");
			debugTF.getTextField().appendText("secret=" + flashVars['secret']);		
			//addChild(debugTF);
		}
		
		public function overSE(e:MouseEvent):void
		{
			var dropShadow:DropShadowFilter = new DropShadowFilter();
			dropShadow.distance = 0;
			dropShadow.angle = 45;
			dropShadow.color = 0x014261;
			dropShadow.alpha = 1;
			dropShadow.blurX = 10;
			dropShadow.blurY = 10;
			dropShadow.strength = 0.4;
			dropShadow.quality = 100;
			dropShadow.inner = false;
			dropShadow.knockout = false;
			dropShadow.hideObject = false;			
			e.currentTarget.filters = new Array(dropShadow);		
		}
		
		public function outSE(e:MouseEvent):void
		{
			e.currentTarget.filters = null;
		}
		
		public function chooSEBACK(e:MouseEvent):void
		{
			bevel.visible = true;
			ru.visible = true;
			lat.visible = true;
			chs.buttonMode = false;
			chs.removeEventListener(MouseEvent.CLICK, chooSEBACK);
			chs.txt.text = ""; // "ВЫБЕРИ АВАТАРКУ";
			t1.visible = t2.visible = true;			
			TweenLite.to(arrow, 0.3, { alpha: 1 } );
			
			for (var i:int = 1; i <= __num; i++)
			{
				with (this["ava" + i])
				{
					scaleX = scaleY = 0.6;					
					addEventListener(MouseEvent.CLICK, chooSE);
					addEventListener(MouseEvent.MOUSE_OVER, overSE);
					addEventListener(MouseEvent.MOUSE_OUT, outSE);
					txt.visible = false;
					buttonMode = true;
					visible = true;
				}
				TweenLite.to(this["ava" + i], 0.3, {x: defaultPosition[i - 1].x, y: defaultPosition[i - 1].y, alpha: 1, scaleX: defaultScale[i - 1].scaleX, scaleY: defaultScale[i - 1].scaleY});
				ServiceFunctions.removeAllChild(this["ava" + i].cont);
			}
			controlBlock.visible = false;
			resetContHolders();
		}
		
		private function resetContHolders():void
		{
			ava1.cont.x = 101;
			ava1.cont.y = 302;
			
			ava2.cont.x = 95;
			ava2.cont.y = 318;
			
			ava3.cont.x = 93;
			ava3.cont.y = 305;
			
			ava4.cont.x = 93;
			ava4.cont.y = 305;
			
			ava5.cont.x = 93;
			ava5.cont.y = 305;
			
			ava6.cont.x = 93;
			ava6.cont.y = 305;
			
			ava7.cont.x = 93;
			ava7.cont.y = 305;
			
			for (var i:int = 1; i <= __num; i++)
				this["ava" + i].cont.rotation = 0;
		}
		
		public function chooSE(e:MouseEvent):void
		{
			initOne(e.currentTarget.name);			
		}
		
		private function initOne(name:String):void
		{
			TweenLite.to(arrow, 0.3, {alpha: 0});
			t1.visible = t2.visible = false;
			chs.buttonMode = true;
			chs.addEventListener(MouseEvent.CLICK, chooSEBACK);
			chs.txt.text = (lang == "RU") ? "ВЕРНУТЬСЯ К ВЫБОРУ" : "ATGRIEZTIES PIE IZVĒLNES";
			bevel.visible = false;
			ru.visible = false;
			lat.visible = false;
			for (var i:int = 1; i <= __num; i++)
			{
				with (this["ava" + i])
				{
					removeEventListener(MouseEvent.CLICK, chooSE);
					removeEventListener(MouseEvent.MOUSE_OVER, overSE);
					removeEventListener(MouseEvent.MOUSE_OUT, outSE);
					txt.visible = true;
					buttonMode = false;
					filters = null;
				}
			}
			for (var j:int = 1; j <= __num; j++)
			{
				with (this["ava" + j])
				{
					txt.text = "";// "Твое Имя";
					txt.maxChars = 15;
					txt.addEventListener(FocusEvent.FOCUS_IN, textInputHandler1);
					txt.addEventListener(FocusEvent.FOCUS_OUT, textOuputHandler1);
				}
			}
			
			for (var k:int = 1; k <= __num; k++)
			{
				if (name == k.toString())
					continue;
				
				TweenLite.to(this["ava" + k], 0.3, { alpha: 0 } );
				this["ava" + k].visible = false;
			}
			
			af = name;
			this[af].scaleX = this[af].scaleY = 1;
			this[af].visible = true;
			controlBlock.visible = true;
			
			TweenLite.to(getChildByName(name), 0.3, { x: 140, y: 70 } );
			
			with (controlBlock)
			{
				upload.buttonMode = true;
				upload.addEventListener(MouseEvent.CLICK, uploadHandler);			
				savebtn.buttonMode = false;
				movebtn.buttonMode = false;
				sizebtn.buttonMode = false;
				rotbtn.buttonMode = false;			
				rotl.buttonMode = false;
				rotr.buttonMode = false;
				pll.buttonMode = false;
				minr.buttonMode = false;
				ava.buttonMode = false;			
				savebtn.alpha = 0.4;
				movebtn.alpha = 0.4;
				sizebtn.alpha = 0.4;
				rotbtn.alpha = 0.4;			
				rotl.alpha = 0.4;
				rotr.alpha = 0.4;
				pll.alpha = 0.4;
				minr.alpha = 0.4;
				ava.alpha = 0.4;
			}
		}
		
		private function textDownhandler(e:KeyboardEvent):void
		{
			trace(e.charCode);
			var p = e.currentTarget.parent as MovieClip;
			if (e.charCode == 13 || e.charCode == 9)
			{
				stage.focus = p.txt2;
			}
		}
		
		private function textOuputHandler(e:FocusEvent):void
		{
			with(e.currentTarget)
				if (text == "")
				{
					if (name == "txt1")	text = "Твое";
					else text = "Имя";
				}
		}
		
		private function textInputHandler(e:FocusEvent):void
		{
			if (e.currentTarget.text == "Твое" || e.currentTarget.text == "Имя")
				e.currentTarget.text = "";
		}
		
		private function textOuputHandler1(e:FocusEvent):void
		{
			if (e.currentTarget.text == "")
				e.currentTarget.text = "Твое Имя";
		}
		
		private function textInputHandler1(e:FocusEvent):void
		{
			if (e.currentTarget.text == "Твое Имя")
				e.currentTarget.text = "";
		}
		
		public function uploadHandler(e:MouseEvent):void
		{
			currentClip = this[af];
			pht = new PhotoUpload(currentClip.cont);
			pht.browsePhoto();
			pht.addEventListener(PhotoUpload.ATTACHED, startChange);
		}
		
		public function startChange(e:Event):void
		{
			resetContHolders();
			
			with (controlBlock)
			{
				savebtn.buttonMode = true;
				savebtn.addEventListener(MouseEvent.CLICK, savePhoto);			
				rotl.buttonMode = true;
				rotr.buttonMode = true;
				pll.buttonMode = true;
				minr.buttonMode = true;
				ava.buttonMode = true;			
				rotl.alpha = 1;
				rotr.alpha = 1;
				pll.alpha = 1;
				minr.alpha = 1;
				ava.alpha = 1;			
				savebtn.alpha = 1;
				movebtn.alpha = 1;
				sizebtn.alpha = 1;
				rotbtn.alpha = 1;			
				rotl.addEventListener(MouseEvent.CLICK, rotlH);
				rotr.addEventListener(MouseEvent.CLICK, rotrH);			
				pll.addEventListener(MouseEvent.CLICK, pllH);
				minr.addEventListener(MouseEvent.CLICK, minrH);
				ava.addEventListener(MouseEvent.CLICK, avaHandler);
			}
			
			currentClip.drag.addEventListener(MouseEvent.MOUSE_DOWN, stratDragPhoto);
		}
		
		private function avaHandler(e:MouseEvent):void
		{
			tint.visible = true;
			
			VK.api('photos.getProfileUploadServer', null, getProfileUploadServer, onApiRequestFail);
			//VK.api('friends.get', { uid:flashVars['viewer_id'], fields:'uid, first_name,last_name, photo' }, getProfileUploadServer, onApiRequestFail);
			//VK.api('photos.getWallUploadServer', {uid:flashVars['viewer_id']}, getProfileUploadServer, onApiRequestFail);		
		}
		
		private function onApiRequestFail(data:Object):void
		{
			debugTF.getTextField().appendText("\n Error: " + data.error_msg + "\n");
			tint.visible = false;
		}
		
		private function getProfileUploadServer(data:Object):void
		{
			
			debugTF.getTextField().appendText("\n");
			debugTF.getTextField().appendText("getProfileUploadServer");
			var bitmap_data:BitmapData = new BitmapData(200, 500); // currentClip.width, currentClip.height);
			bitmap_data.draw(currentClip);
			var byte_arr:ByteArray = PNGEncoder.encode(bitmap_data);
			
			var photoLoader = new MultipartURLLoader();
			photoLoader.addEventListener(Event.COMPLETE, onUploadComplete);
			photoLoader.addFile(byte_arr, "kubana_ava.png", "photo");
			photoLoader.load(data.upload_url);
		}
		
		public function onUploadComplete(event:Event):void
		{
			var response = JSON.decode(event.currentTarget.loader.data);
			VK.api('photos.saveProfilePhoto', {server: response.server, photo: response.photo, hash: response.hash}, onsaveProfilePhoto, onApiRequestFail);
			tint.visible = false;
		}
		
		private function onsaveProfilePhoto():void
		{
			tint.visible = false;
		}
		
		//{ region manipulate with photo
		private function stratDragPhoto(event:MouseEvent):void
		{
			currentClip.drag.removeEventListener(MouseEvent.MOUSE_DOWN, stratDragPhoto);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragPhoto);
			currentClip.addEventListener(MouseEvent.MOUSE_MOVE, stratMove);
		}
		
		private function stratMove(event:MouseEvent):void
		{
			currentClip.cont.startDrag();
		}
		
		private function stopDragPhoto(event:MouseEvent):void
		{
			currentClip.cont.stopDrag();
			currentClip.addEventListener(MouseEvent.MOUSE_DOWN, stratDragPhoto);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragPhoto);
			currentClip.removeEventListener(MouseEvent.MOUSE_MOVE, stratMove);
		}
		
		//} endregion
		
		public function rotlH(e:MouseEvent):void
		{
			angle += 5;
			currentClip.cont.rotation = angle;
		}
		
		public function rotrH(e:MouseEvent):void
		{
			angle -= 5;
			currentClip.cont.rotation = angle;
		}
		
		public function pllH(e:MouseEvent):void
		{
			if (scalep < 2)
				scalep += 0.1;
			
			with (currentClip.cont)
				scaleX = scaleY = scalep;
		}
		
		public function minrH(e:MouseEvent):void
		{
			if (scalep > 0.3)
				scalep -= 0.1;
			
			with (currentClip.cont)
				scaleX = scaleY = scalep;
		}
		
		public function savePhoto(e:MouseEvent):void
		{
			pht.savePhoto(currentClip)
		}
	}
}