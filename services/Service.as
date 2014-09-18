package core.services 
{
	import com.greensock.loading.DataLoader;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Service extends EventDispatcher 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Service(target:flash.events.IEventDispatcher=null) 
			{
				super(target);
				//initialize();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function get(url:String, data:Object, callback:Function):void 
			{
				data.onComplete = callback;
				new DataLoader(url, data);
			}
			
			public function post(url:String, data:Object, callback:Function):void 
			{
				data.onComplete = callback;
				new DataLoader(url, data);
				
			}
			
			public function remove(url:String, data:Object, callback:Function):void 
			{
				data.onComplete = callback;
				new DataLoader(url, data);
			}
			
			public function del(url:String, data:Object, callback:Function):void 
			{
				data.onComplete = callback;
				new DataLoader(url, data);
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