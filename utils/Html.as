package core.utils 
{
	import flash.text.StyleSheet;

	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Html 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			/**
			 * Convert html to xml and de-namespace so E4X works without default namespacing
			 * @param	html
			 * @return
			 */
			public static function xmlToHtml(html:String):XML
			{
				// xml
					XML.ignoreWhitespace	= false;
					XML.prettyPrinting		= false;

				// html
					if (html.replace != null)
					{
						html = html.replace(/\s+xmlns(:[^=]+)?=\"[^=]*?\"/g, '')
					}

					return new XML(html);
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
		public static function upgradeStyles(html:String, stylesheet:StyleSheet):String 
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