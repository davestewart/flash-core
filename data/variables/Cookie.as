package core.data.variables 
{
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	dynamic public class Cookie
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// statics
				static public var instance		:Cookie = new Cookie();
			
			// properties
				protected var _data				:Object;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Cookie() 
			{
				load();
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Get a cookie value
			 * @param	name
			 * @param	reload
			 * @return
			 */
			public function get(name:String, reload:Boolean = false):String
			{
				if (reload)
				{
					load();
				}				
				return _data[name];
			}
			
			/**
			 * Set a cookie value
			 * @param	name
			 * @param	value
			 * @param	days
			 */
			public function set(name:String, value:*, days:int = 365):void
			{
				_data[name] = value;
				if (isValidName(name))
				{
					this[name] = value;
				}
				write(name, value, days);
			}
			
			/**
			 * Delete a cookie value
			 * @param	name
			 */
			public function del(name:String):void 
			{
				delete _data[name];
				if (isValidName(name))
				{
					delete this[name];
				}
				write(name, '', 0);
			}
			
			/**
			 * Load all cookie values
			 */
			public function load():void 
			{
				_data = { };
				if (ExternalInterface.available)
				{
					// variables
						var cookie		:String;
						var rx			:RegExp;
						var matches		:Array;
						var match		:String;
						var pair		:Array;
						var name		:String;
						var value		:String;
						
					// get cookie data
						rx				= /(\w+)=([^;]+)/g;
						cookie			= ExternalInterface.call('eval', 'document.cookie');
						matches			= String(cookie).match(rx);
						
					// get values
						rx = new RegExp(rx.source);
						for each(match in matches)
						{
							pair = match.match(rx);
							if (pair)
							{
								// variables
									name		= pair[1];
									value		= decodeURIComponent(pair[2]);
									
								// assign values
									_data[name] = value;
									if ( isValidName(name) )
									{
										this[name] = value;
									}
							}
						}
				}
			}
		
			/**
			 * Clear all cookies
			 */
			public function clear():void 
			{
				for each(var key:String in keys)
				{
					del(key);
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			/**
			 * Get all cookie keys
			 */
			public function get keys():Array
			{
				var keys:Array = [];
				for (var key:String in _data)
				{
					keys.push(key);
				}
				return keys;
			}
			
			/**
			 * get all cookie values as an Object hash
			 */
			public function get values():Object
			{
				var values:Object = { };
				for (var name:String in _data)
				{
					values[name] = _data[name];
				}
				return values;
			}
			
					
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function write(name:String, value:*, days:int = 365):Boolean 
			{
				if (ExternalInterface.available)
				{
					// build expires string
						var date		:Date		= new Date();
						var seconds		:int		= days * 24 * 60 * 60 * 1000;
						date.setTime(date.getTime() + seconds);
						
					// build the javascript string
						var expires		:String		= 'expires=' + date.toUTCString();
						var cookie		:String		= name + '=' + encodeURIComponent(value) + ';' + expires;
						var javascript	:String		= 'document.cookie="' + cookie + '"';
						
					// set the cookie
						trace(javascript);
						ExternalInterface.call('eval', javascript);
						
					// return
						return true;
				}
				return false;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function isValidName(name:String):Boolean 
			{
				var isValid:Boolean = ! /^(get|set|del|load|clear|keys|values|write|toString)$/.test(name);
				if ( ! isValid )
				{
					trace('Cookie: warning - the name "' +name+ '" is a property/method of the Cookie class, so may not be used as a dynamic setter/getter');
				}
				return isValid;
			}

			public function toString():String
			{
				var values:String = '';
				for (var name:String in _data)
				{
					values += ' ' + name + '="' +_data[name] + '"';
				}
				return '[object Cookie' + values + ']';
			}
	}

}

