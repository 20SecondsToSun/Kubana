package com.artcore.debug 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author castor_troy
	 */
	public class TextFieldDebug extends Sprite
	{
		public var tf:TextField;
		
		public function TextFieldDebug() 
		{
			tf = new TextField();
			tf.x = 0;
			tf.y = 0;
			tf.width = 587;
			tf.height = 349;
			
			tf.border = true;
			tf.borderColor = 0xDAE2E8;
			tf.background = true;
			tf.backgroundColor = 0xFFFFFF;
			tf.embedFonts = false;
			var format:TextFormat = new TextFormat();
			format.font = "Tahoma";
			format.color = 0x000000;
			format.size = 11;
			tf.defaultTextFormat = format;
			addChild(tf);			
		}
		public function getTextField():TextField
		{
			return tf;
		}
		
	}

}