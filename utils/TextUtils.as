package core.utils 
{
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class TextUtils 
	{
		public static function fix(target:TextField):void
		{
			// autosize
				var align	:String		= target.getTextFormat().align;
				var bounds	:Rectangle	= target.getBounds(target.parent);
				//trace(bounds);
				target.autoSize	= align;
				
			// debug
				//target.border = true;
				
			// clipped-text
				var fmt:TextFormat = new TextFormat();
				fmt.leading = 2;
				target.setTextFormat(fmt);
		}

			
	}

}