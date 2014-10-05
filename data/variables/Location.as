package core.data.variables 
{
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Location
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// statics
				static public var instance:Location = new Location();
			
			// properties
				protected var _data				:Object;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Location() 
			{
				_data = { };
				_data.params = new URLVariables();
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get href():String { return get('href'); }

			public function get protocol():String { return get('protocol'); }

			public function get username():String { return get('username'); }

			public function get password():String { return get('password'); }

			public function get host():String { return get('host'); }

			public function get hostname():String { return get('hostname'); }

			public function get port():String { return get('port'); }

			public function get pathname():String { return get('pathname'); }

			public function get search():String { return get('search'); }

			public function get params():URLVariables { return get('params'); }

			public function get hash():String { return get('hash'); }

			public function get origin():String { return get('origin'); }
			
			public function get available():Boolean { return ExternalInterface.available; }
			
					
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function get(name:String):*
			{
				if (ExternalInterface.available)
				{
					// always re-get the page hash
						if (name === 'hash')
						{
							return ExternalInterface.call('eval', 'window.location.hash').replace('#', '');
						}
						
					// otherwise, if a value has already been cached, return it
						else if (name in _data)
						{
							return _data[name];
						}
						
					// finally, if a value is being requested for the first time, grab it and process it if needs be
						else
						{
							_data[name] = ExternalInterface.call('eval', 'window.location.' + name) || '';
							switch(name)
							{
								case 'origin':
									if (_data[name] == '')
									{
										_data[name] = protocol + ':' + hostname + port;
									}
									break;
								
								case 'protocol':
									_data[name] = _data[name].replace(':', '');
									break;
								
								case 'search':
									_data[name] = _data[name].replace('?', '');
									break;
								
								case 'params':
									_data[name] = new URLVariables((search.match(/\w+=[^&]+/g) || []).join('&')); // filter key=value pairs so URLVariables doesn't error if mal-formed
									break;
							}
						}
				}
				return _data[name];
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			public function toString():String
			{
				return '[object Location href="' +href+ '"]';
			}
	}

}