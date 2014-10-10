package core.utils 
{
	import flash.text.StyleSheet;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Styles 
	{
		
		public static function cssToRgb(css:String):Object 
		{
			var matches	:Array = css.match(/(?:#|0x)?([\da-f]{2})([\da-f]{2})([\da-f]{2})/i);
			if (matches.length == 4)
			{
				return { r: parseInt(matches[1], 16), g: parseInt(matches[2], 16), b: parseInt(matches[3], 16) }
			}
			return { r: -1, g: -1, b: -1 };
		}

		/**
		 * Manipulates HTML text designated for text fields in conjunction with a stylesheet
		 * so that unsupported styles such as margin-bottom and text-transform are pseudo-
		 * supported by physically adding / altering the source HTML
		 * 
		 * @param	html
		 * @param	stylesheet
		 * @return
		 */
		public static function upgrade(html:String, stylesheet:StyleSheet):String 
		{
			// variables
				var rx			:RegExp;
				var rxAll		:RegExp;
				var rxOne		:RegExp;
				var style		:Object;
				var styleNames	:Array;
				var styleName	:String;
				var newHTML		:String;
			
			// functions
				function upperCaseContent(match)
				{
					var matches = match.match(rxOne);
					return matches[1] + matches[2].toUpperCase() + matches[3];
				}
				
				//html = html.replace(/(?:<(ol|ul)[^>]*>|<\/(ol|ul)>)/gi, '');
				

			// process styles
				styleNames			= stylesheet.styleNames;
				for (var i:int = 0; i < styleNames.length; i++) 
				{
					// variables
						styleName	= styleNames[i];
						style		= stylesheet.getStyle(styleName);
						
					// top and bottom margins
						for each(var margin:String in ['marginTop', 'marginBottom'])
						{
							var size = style[margin];
							if (size != undefined)
							{
								// style
									var newStyleName:String		= margin + '-' + size;
									stylesheet.setStyle('.' + newStyleName, { fontSize:size, display:'block', color:'#FF0000', leading:0 } );
									
								// html
									newHTML			= '<[MARGIN] class="' +newStyleName+ '"></[MARGIN]>';
									rx				= new RegExp('(<' +styleName + '\\b.+?</' +styleName + '>)', 'ig');
									html			= html.replace(rx, margin == 'marginTop' ? newHTML + '$1' : '$1' + newHTML);
							}
						}
						
					// uppercase
						if (style.textTransform == 'uppercase')
						{
							rxAll			= new RegExp('(<' +styleName + '\\b[^>]*>)(.+?)(</' +styleName + '>)', 'ig');
							rxOne			= new RegExp('(<' +styleName + '\\b[^>]*>)(.+?)(</' +styleName + '>)', 'i');
							html = html.replace(rxAll, upperCaseContent)
						}
					
				}
				
			// replace all preset margins
				html = html.replace(/\[MARGIN\]/g, 'p');
				
			// text
				return html;;
		}			
	}

}