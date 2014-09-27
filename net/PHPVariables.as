package core.net 
{
	import flash.net.URLVariables;
	
	
	/**
	 * @name		PHPVariables
	 * @type		AS2 Class
	 * version		1.0
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
	public dynamic class PHPVariables extends URLVariables 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function PHPVariables(source:* = null)
			{
				for (var name:String in source)
				{
					this[name] = source[name];
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
				return serialize(this);
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			static public function serialize(input:*, path:String = ''):String
			{
				// variables
					var name	:String;
					var prop	:String;
					var output	:String		= '';
				
				// undefined
					if(input == undefined)
					{
						// fail gracefully
					}
						
				// array
					else if(input is Array)
					{
						output += '[';
						for (var i:int = 0; i < input.length; i++)
						{
							name = path + '[' +i+']';
							output += serialize(input[i], name);
						}
						output += ']';
					}
						
				// object
					else if(typeof input == 'object')
					{
						for(prop in input)
						{
							name = path + (path == '' ? prop : '[' +prop+ ']');
							output += serialize(input[prop], name);
						}
					}
						
				// value
					else
					{
						output = String(input);
					};
					
				// return
					return path + '=' + output;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}