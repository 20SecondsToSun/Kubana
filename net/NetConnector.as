package net 
{
	import com.debug.Console;
	import com.indeeinteractive.framework.net.HTTPConnector;
	import com.indeeinteractive.framework.notifycation.IObserver;
	import com.indeeinteractive.framework.notifycation.Notifycation;
	import com.junkbyte.console.Cc;
	import com.model.vo.User;
	import flash.net.FileReference;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author random()
	 */
	public final class NetConnector extends Object implements IObserver
	{
		private static var _instance:NetConnector;
		
		private var _url:String = "http://sonynex.deluxe-interactive.com/" + 'client/';
		
		private const TEST_CONTROLLER:String = "index.test";
		private const TEST_CONTROLLER2:String = "index.test";
		private const TOP_10:String = "photos.top10";
		private const PHOTOS_LIST:String = "photos.list";
		private const SEND_MAIL:String = "photos.updateemail";
		private const SEND_PHOTO_FR:String = "photos.add";
		private const SEND_VOTE:String = "photos.vote";
		
		
		private var _connector:HTTPConnector;
		private var _callbacks:Object = { };
		private	var staticVars:URLVariables = new URLVariables();
		
		public static var uid:String = "";
		
		public function NetConnector() 
		{
			super();
			_init();
		}
		
		static public function get instance():NetConnector 
		{
			return _instance ||= new NetConnector();
		}
		

		
		private function _init():void 
		{
			_connector = HTTPConnector.instance;
			
			_connector.antiCash = true;
			_connector.fnTrace = Cc.log;
			_connector.url = User.getInstance().domain + '/client/';//_url;			
			
			//_connector.addObserver(TEST_CONTROLLER, this);
		//	_connector.addObserver(TEST_CONTROLLER2, this);
		//	
			_connector.addObserver(TOP_10, this);
			_connector.addObserver(SEND_MAIL, this);
			
			_connector.addObserver(SEND_PHOTO_FR, this);
			_connector.addObserver(PHOTOS_LIST, this);
			_connector.addObserver(SEND_VOTE, this);
		
			
			_connector.traceVerbosity = _connector.TRACE_PARANOIC;
			
		
			staticVars.someGlobal = "inEveryRequest";
			_connector.staticVars = staticVars;
			
			_instance = this;
		}
		
		private function _sendToServer(command:String, data:Object, callback:Function):void 
		{
			_callbacks[command] = callback;
			_connector.sendData(command, data);
		}
		
		public function dataUpdate(notice:Notifycation):void
		{
			
			var error:Object = notice.error;
			var command:String = notice.type;
			var answerToCallback:Object;
			
			if (!error)
			{
				answerToCallback = notice.data;
			}
			else
			{
				answerToCallback = {errorcode:notice.error, errortext:notice.data};
			}
			
			// calling callback for the current command
			if (_callbacks[command])
			{
				_callbacks[command](answerToCallback);
				_callbacks[command] = null;
			}
			answerToCallback = null;
			error = null;
		}
		public function photostop10( callback:Function/*(answer:Object):void*/):void
		{	
			var object:Object = { };			
			_sendToServer(TOP_10, object, callback);			
		}
		public function getGallery( callback:Function/*(answer:Object):void*/):void
		{	
			var object:Object = { };			
			_sendToServer(PHOTOS_LIST, object, callback);			
		}
		
		public function sendMail(data:String,_sid:String, callback:Function/*(answer:Object):void*/):void
		{
			var object:Object = { email :data };			
			
			staticVars.sid = _sid;
			_connector.staticVars = staticVars;
			
			_sendToServer(SEND_MAIL,object,callback);
		}
		public function photoVote(network:String,_id:String,_sid:String, callback:Function/*(answer:Object):void*/):void
		{
			var object:Object = { id:_id, social:network };				
			staticVars.sid = _sid;
			_connector.staticVars = staticVars;	
			//Console.log("data", data, "response", SEND_PHOTO_FR, "sid", _sid);				
		
			_sendToServer(SEND_VOTE,object,callback);
		}
		
		public function sendPhotoFR(data:String,fr:FileReference,_sid:String, callback:Function/*(answer:Object):void*/):void
		{
			var object:Object = { vars:{about :data}, file:fr };				
			staticVars.sid = _sid;
			_connector.staticVars = staticVars;	
			Console.log("data", data, "response", SEND_PHOTO_FR, "sid", _sid);				
		
			_sendToServer(SEND_PHOTO_FR,object,callback);
		}
		public function sendPhotoBA(data:String,fr:ByteArray,_sid:String, callback:Function/*(answer:Object):void*/):void
		{
			var object:Object = { vars:{about :data}, file:fr };			
			staticVars.sid = _sid;
			_connector.staticVars = staticVars;			
			_sendToServer(SEND_PHOTO_FR,object,callback);
		}
		
		/*public function sendTest2(data:String, data2:String, data3:Array, callback:Function/*(answer:Object):void*///):void
		//{
		//	var object:Object = { field_search1:data, field_search2:data2, field_search3:data3 };
		//	_sendToServer(TEST_CONTROLLER,object,callback);
		//}*/
	}

}