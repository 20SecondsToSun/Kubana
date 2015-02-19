/**
 * Hi-ReS! Logger
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php 
 * 
 * How to use:
 * 
 * 	addChild(new Logger());
 * 
 *	Logger.info("Info message");
 * 	Logger.debug("Debug message");
 * 	Logger.warning("This is just a warning!");
 * 	Logger.error("Ok, something crashed");
 * 
 * version log: 
 *
 *	08.11.12		1.3		Mr.doob	& Theo	+ Instance mode
 *											+ Info level added
 *											+ Stack
 *	08.11.04		1.2		Mr.doob			+ Introduced debug, warning and error methods
 *											+ added visible getter/setter
 *	08.11.02		1.1		Mr.doob			+ Changed the LEVEL handling
 *											+ Slightly refactored
 * 	07.10.12		1.0		Mr.doob			+ First version 
 **/
 
package net.hires.debug
{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;	
	import flash.utils.getQualifiedClassName;
	import org.casalib.util.DateUtil;
	import org.casalib.util.NumberUtil;

	public class Logger extends Sprite
	{	
		public static var LEVEL_INFO : int = 0;
		public static var LEVEL_DEBUG : int = 1;
		public static var LEVEL_WARNING : int = 2;
		public static var LEVEL_ERROR : int = 3;
		public static var LEVEL_SILENT : int = 4;
		
		private static var level_searchs : Array = ["INFO", "DEBUG", "WARNING", "ERROR", "SILENT"];
		private static var stack : Array = [[],[]];
		
		private static var monitors : Array = [];
		
		public var global : Boolean;
		public var level : int;
		
		private var bgBox : Sprite;
		private var textBox : TextField;
		
		public var textHeight:int;

		public function Logger(level : int = 0, global : Boolean = true)
		{
			this.level = level;
			this.global = global;
			
			bgBox = new Sprite();
			bgBox.graphics.beginFill(0x000000, .8);
			bgBox.graphics.drawRect(0, 0, 10, 10);
			bgBox.graphics.endFill();
			addChild(bgBox);
			
			textBox = new TextField();
			textBox.defaultTextFormat = new TextFormat( "verdana", 10, 0xFFFFFF );
			textBox.selectable = true;
			addChild(textBox);
				
			clear();
				
			monitors.push(this);
		}
		
		public static function chkInit( refer:Object ):void
		{
			Logger.debug( "<< Construct >> \t" + getQualifiedClassName( refer ) );
		}
		
		public static function chkDestroy( refer:Object ):void
		{
			Logger.debug( "<< Destroy >> \t" + getQualifiedClassName( refer ) );
		}
		
		public static function info( ...msg : * ) : void
		{
			Logger.log(msg, LEVEL_INFO);
		}
		
		public static function debug( ...msg : * ) : void
		{
			Logger.log(msg, LEVEL_DEBUG);
		}

		public static function warning( ...msg : * ) : void
		{
			Logger.log(msg, LEVEL_WARNING);
		}
		
		public static function error( ...msg : * ) : void
		{
			Logger.log(msg, LEVEL_ERROR);
		}

		public static function log( msg : *, level : int = 0 ) : void
		{
			stack.push([msg,level]);
			
			for (var i : int = 0; i < monitors.length; i++)
				if (Logger(monitors[i]).global)
					Logger(monitors[i]).log( msg, level );
		}

		public static function clear() : void
		{
			while(stack.length > 0)
				stack.pop();
		}


		// .. INSTANCE METHODS
		
		public function info( ...msg : * ) : void
		{
			log(msg, LEVEL_INFO);
		}
		
		public function debug( ...msg : * ) : void
		{
			log(msg, LEVEL_DEBUG);
		}

		public function warning( ...msg : * ) : void
		{
			log(msg, LEVEL_WARNING);
		}
		
		public function error( ...msg : * ) : void
		{
			log(msg, LEVEL_ERROR);
		}		
		
		public function log( msg : *, level : int = 0 ) : void
		{
			if (level < this.level)
				return;
			
			var log_trace:String = getTimestamp() + " :: " + level_searchs[level] + " :: " + String(msg);
			var log:String = "[" + level_searchs[level] + "]\t" + String(msg);
			trace( log_trace );
			
			textBox.text = log + "\n" + textBox.text;
			textBox.autoSize = "left";
			
			bgBox.width = textBox.width;
			bgBox.height = textBox.height;
		}
		
		public function clearMsg():void
		{
			textBox.text = "";
		}
		

		public function clear() : void
		{
			textBox.text = getTimestamp() + " :: Hi-ReS! Logger > " + level_searchs[level] + " mode.";
			textBox.autoSize = "left";
			textHeight = textBox.height;
			
			bgBox.width = textBox.width;
			bgBox.height = textBox.height;
		}

 		
		// .. UTILS

		private static function getTimestamp() : String
		{
			var d : Date = new Date();
			return "[" + NumberUtil.addLeadingZero(d.hours) + ":" + NumberUtil.addLeadingZero(d.minutes) + ":" + NumberUtil.addLeadingZero(d.seconds) + "::" + NumberUtil.addLeadingZero(d.milliseconds) + "]";
			
			
		}
		
	}
}
