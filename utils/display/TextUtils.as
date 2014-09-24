package core.utils.display {
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class TextUtils 
	{
		
		/**
		 *
		 * @param	tf
		 * @param	size
		 * @param	color
		 * @param	font
		 * @return
		 */
		public static function initializeText(tf:TextField = null, size:int = 11, color:Number = 0x000000, fontName:String = 'Arial'):TextFormat
		{
			// text format
				var fmt:TextFormat		= new TextFormat(fontName, size, color);
				fmt.align				= TextFormatAlign.LEFT;
				fmt.color				= color;
				fmt.size				= size;
				
			// if a textfield is passed in, update it
				if (tf != null)
				{
					tf.autoSize				= TextFieldAutoSize.LEFT;
					tf.antiAliasType		= AntiAliasType.ADVANCED;
					tf.thickness			= -50;
					tf.sharpness			= 300;
					tf.embedFonts			= true;
					tf.selectable			= false;
					tf.textColor			= color;
					tf.defaultTextFormat	= fmt;
					tf.setTextFormat(fmt);
				}
				
			// return the textformat for us on other textfields
				return fmt;
		}

		/**
		 * Fixes textfields that have the last line clipped
		 * @param	target
		 */
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