package core.managers.tasks {
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Task 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				public var func		:Function;
				public var name		:String;
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Task(func:Function, name:String) 
			{
				this.func = func;
				this.name = name;
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function exec():void 
			{
				func();
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}