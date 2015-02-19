package com.artcore.print 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	/**
	 * ...
	 * @author castor_troy
	 */
	public class Print extends MovieClip
	{		
		public function Print() 
		{
			
		}
		public static function startPrint(_prints:Array):void 
		{				
			var _pj:PrintJob = new PrintJob();			
			var sprite:Sprite = new Sprite();		
			var bitmap:Bitmap;
			var bitmapData:BitmapData;					
			_pj.start();
			for (var i:int = 0; i < _prints.length; i++)
			{				
				if (_prints[i] is Bitmap)
				{
					bitmap = new Bitmap(_prints[i].bitmapData);
				} 
				else
				{
					var area:Rectangle = new Rectangle(0, 0, _prints[i].width, _prints[i].height);
					bitmapData = new BitmapData(area.right, area.bottom);
					bitmapData.draw(_prints[i]);
					bitmap = new Bitmap(bitmapData);
				}
				
				sprite = new Sprite();
				sprite.addChild(bitmap);
				
				//sprite.width = 100//_pj.pageWidth;
				//sprite.height = 100//_pj.pageHeight;
				trace("SIZEXY", sprite.width, sprite.height,sprite.name);
				_pj.addPage(sprite);					
			}			
			_pj.send();			
			
		}
		/*public static function pageToPdf(_prints:Array):void 
		{
			var _myPdf:PDF;			
			var sprite:Sprite = new Sprite();			
			var bitmap:Bitmap;
			var bitmapData:BitmapData;		
			var type:String = "A4"//"A3"
			
			_myPdf = new PDF(Orientation.PORTRAIT, Unit.MM, Size.A3);			
			
			for (var i:int = 0; i < _prints.length; i ++)
			{				
				if (tmp[_prints[i]] is Bitmap)
				{
					bitmap = new Bitmap(_prints[i].bitmapData);
				} 
				else 
				{
					var area:Rectangle = Object(_prints[i].getRect(_prints[i]));
					bitmapData = new BitmapData(area.right, area.bottom);
					bitmapData.draw(_prints[i]);
					bitmap = new Bitmap(bitmapData);
				}
				
				sprite.addChild(bitmap);				
				_myPdf.addPage();
				
				if (type == "A3")
				{
					_myPdf.addImage(sprite, 0, 0, 297, 420); 
				} 
				else if (type == "A4")
				{
					_myPdf.addImage(sprite, 0, 0, 210, 297); 
				} 
				else
				{
					_myPdf.addImage(sprite, 0, 0, 148, 210); 
				}							
			} 			
			_myPdf.save("remote", "createpdf.php", "attachment", "MY_PDF_search.pdf");			
		}
		*/
		
	}

}