package core.net 
{
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	dynamic public class PHPVars extends URLVariables
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				
				
			// variables
				protected var __data:*;
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			dynamic public function PHPVars(data:*) 
			{
				for (var name:String in data)
				{
					if (name !== '__data')
					{
						this[name] = data[name];
					}
				}
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function toString():String
			{
				// reset and serialize
					__data = { };
					serialize(this);
					
				// collect values
					var values:Array = [];
					for (var name:String in __data)
					{
						trace(name, __data[name])
						values.push(name + '=' + escape(__data[name]));
					}
					
				// return
					return values.sort().join('&');
			}
		
			override public function decode(source:String):void 
			{
				super.decode(source);
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function serialize(input:*, path:String = ''):void
			{
				// varaibles
					var name:String;
					
				// undefined
					if(input == undefined)
					{
						// fail gracefully
					}
						
				// array
					else if(input is Array)
					{
						//__data[path + '[]'] = '';
						for (var i:int = 0; i < input.length; i++)
						{
							name = path + '[' +i+']';
							serialize(input[i], name);
						}
					}
						
				// object
					else if(typeof input == 'object')
					{
						for(var prop:String in input)
						{
							name = path + (path == '' ? prop : '[' +prop+ ']');
							serialize(input[prop], name);
						}
					}
						
				// value
					else
					{
						__data[path] = input;
					};
		
			};	
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}