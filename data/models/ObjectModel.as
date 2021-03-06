package core.data.models {
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class ObjectModel 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var __data:Object;
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function ObjectModel(data:* = null) 
			{
				if (data)
				{
					initialize(data);
				}
			}
		
			/**
			 * Initializes the model with incoming data
			 * 
			 * To override 1:1 mapping of properties, and create your own structures, add a custom handler
			 * by adding a public function named set_propertyName() where "propertyName" is the key in the 
			 * incoming data that you want to override
			 * 
			 * For example, this method would build a custom Users vector from an Array of Objects:
			 * 
			 *      public function set_users(data:Array):void
			 * 		{
			 * 			users = new Vector.<UserModel>();
			 * 			for each(var user:Object in data)
			 * 			{
			 * 				users.push(new UserModel(user));
			 * 			}
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
				return JSON.stringify(__data);
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
				return '[object AbstractModel]';
			}
	}

}