package core.utils.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class ElementUtils 
	{
		
		
		static public function getElementBytes(src:DisplayObject, alpha:Boolean = false, color:int = 0x000000):BitmapData 
		{
			// variables
				var width		:int			= src.width;
				var height		:int			= src.height;
				var rect		:Rectangle		= new Rectangle(0, 0, width, height);
				var pt			:Point			= new Point(0, 0);
			
			// get and copy data
				var srcData		:BitmapData		= new BitmapData(width, height, alpha, color);
				var trgData		:BitmapData		= new BitmapData(width, height);

			// Copy pixels
				srcData.draw(src);
				trgData.copyPixels(srcData, rect, pt);

			// return data
				return trgData;
		}
		
		static public function getElementBitmap(src:DisplayObject, alpha:Boolean = false, color:int = 0x000000):Bitmap
		{
			return new Bitmap(getElementBytes(src, alpha, color));
		}
		
		
			
	}

}