package core.net 
{
	import flash.net.URLVariables;
	
	/**
	 * @name		PHPVariables
	 * @desc		Send complex datatypes (arrays, objects) to a PHP script, as serialized name/value pairs
	 * @example		
					// Flash
						var data	:Object			= {data:[1,2,{sub_object:{name:'Dave',age:39,gender:'male'}},3,4,5]}
						var vars	:PHPVariables	= new PHPVariables(data);
						var loader	:
										
					// PHP
						Array
						(
							[data] => Array
							(
								[0] => 1
								[1] => 2
								[2] => Array
								(
									[sub_object] => Array
									(
										[gender] => male
										[age] => 39
										[name] => Dave
									)
				
								)
					
								[3] => 3
								[4] => 4
								[5] => 5
							)
						
						)

	 * @author		Dave Stewart
	 * @date		27th Sept 2014
	 * @email		dev@davestewart.io
	 * @web			www.davestewart.io
	 */
	dynamic public class PHPVariables extends URLVariables
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				
				
			// variables
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			dynamic public function PHPVariables(data:*) 
			{
				for (var name:String in data)
				{
					this[name] = data[name];
				}
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function decode(source:String):void 
			{
				super.decode(source);
			}
		
			override public function toString():String
			{
				// serialize
					var data:Object = serialize(this);
					
				// collect values
					var values:Array = [];
					for (var name:String in data)
					{
						values.push(name + '=' + escape(data[name]));
					}
					
				// return
					return values.sort().join('&');
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: static methods
		
			/**
			 * Static serialize method
			 * @param	input
			 * @return	The serialized values as a hash of names/value pairs
			 */
			static public function serialize(input:*, path:String = null, data:Object = null):Object
			{
				// parameters
					data	= data || { };
					path	= path || '';
				
				// variables
					var name:String;
					
				// undefined
					if(input == undefined)
					{
						// fail gracefully
					}
						
				// array
					else if(input is Array)
					{
						for (var i:int = 0; i < input.length; i++)
						{
							name = path + '[' +i+']';
							PHPVariables.serialize(input[i], name, data);
						}
					}
						
				// object
					else if(typeof input == 'object')
					{
						for(var prop:String in input)
						{
							name = path + (path == '' ? prop : '[' +prop+ ']');
							PHPVariables.serialize(input[prop], name, data);
						}
					}
						
				// value
					else
					{
						data[path] = input;
					};
					
				// return
					return data;
			};	
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}