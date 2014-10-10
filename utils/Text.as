package core.utils {
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Text 
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
		 * Creates single-line text field with stylesheet
		 * @param	html
		 * @return
		 */
		public static function createTextField(html:String = null):TextField
		{
			// textfield instance
				var tf:TextField		= new TextField();
				
			// properties
				//tf.autoSize				= TextFieldAutoSize.LEFT;
				//tf.embedFonts				= true;
				
			// global settings
				initTextField(tf);
				
			// upgrade styles
				tf.htmlText			= '<p>' + html + '<p>';
				if (html != null)
				{
					
				}
				
			// return
				return tf;
		}
		
		/**
		 * Create a multiline text field
		 * @param	width
		 * @param	height
		 * @param	html
		 * @return
		 */
		public static function createTextBox(width:int, height:int, html:String = null):TextField
		{
			// textfield instance
				var tf:TextField		= new TextField();
				
			// properties
				tf.width				= width;
				tf.height				= height;
				tf.multiline			= true;
				tf.wordWrap				= true;
				
			// global settings
				initializeText(tf);
				
			// upgrade styles
				if (html != null)
				{
					tf.htmlText			= Styles.upgrade(html);
				}
				
			// return
				return tf;
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

		public static function setSelectionColor(tf:TextField, styleName:String = ':selected'):void
		{
			var style:Object = tf.styleSheet.getStyle(':selected');
			if (style)
			{
				var rgb:Object = Styles.cssToRgb(style.backgroundColor);
				tf.transform.colorTransform = new ColorTransform(1, 1, 1, 1, rgb.r, rgb.g, rgb.b);
			}
		}
		

			
	}

}