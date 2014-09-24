package core.data.models {
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class AbstractModel 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var __data:Object;
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function AbstractModel(data:* = null) 
			{
				if (data)
				{
					initialize(data);
				}
			}
		
			/**
			 * Initializes the model with incoming data
			 * 
			 * To override 1:1 mapping of properties, for example to create custom classes, create 
			 * public methods prefixed with "set_", e.g. to create custom classes for a "users" property:
			 * 
			 *      public function set_users(data:Array):void
			 * 		{
			 * 			// custom code to parse input data...
			 * 		}
			 * 
			 * @param	data
			 */
			protected function initialize(data:*):void 
			{
				// parse data if it arrives as a JSON string
					__data = data is String ? JSON.parse(data) : data;
					
				// setter function
					var setter:String;
					
				// process data
					for (var name:String in __data)
					{
						setter = 'set_' + name;
						if (setter in this)
						{
							this[setter](__data[name]);
						}
						else if(name in this)
						{
							this[name] = __data[name];
						}
					}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function toJSON():String 
			{
				return JSON.stringify(this);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get _data():Object 
			{
				return __data;
			}
			
					
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			public function toString():String
			{
				return '[object AbstractModel"]';
			}
	}

}