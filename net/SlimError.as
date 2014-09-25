package core.net {
	import core.data.models.AbstractModel;
	
	/**
	 * Class to parse Slim Framework error output and provide meaningful info 
	 * 
	 * @author Dave Stewart
	 */
	public class SlimError extends AbstractModel
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				public var type			:String;
				public var code			:int;
				public var message		:String;
				public var file			:String;
				public var line			:int;
				public var stack		:String;


			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function SlimError(html:String) 
			{
				super(parse(html));
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function parse(error:String):Object
			{
				// variables
					var rx		:RegExp		= new RegExp('<div><strong>(.+?):</strong>(.+?)</div>', 'g');
					var matches	:Array		= error.match(rx);
					var data	:Object		= { };
					
				// get errors
					rx = new RegExp(rx.source);
					for each(var match:String in matches)
					{
						matches = match.match(rx);
						data[matches[1].toLowerCase()] = matches[2];
					}
					
				// now get the stack
					matches = error.match(/<div>#(.+)/g);
					data.stack = matches.join('\n').replace('</pre></body></html>', '');
					
				// return
					return data;
					
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			override public function toString():String 
			{
				var str:String = '';
				str	+= '\n--------------------------------------------------------------------------------------------';
				str	+= '\n Slim Framework Error';
				str	+= '\n--------------------------------------------------------------------------------------------';
				for (var name:String in this)
				{
					str += '\n' + name + '	: ' + this[name];
				}
				str	+= '\n--------------------------------------------------------------------------------------------';
				return str;
			}
	}

}