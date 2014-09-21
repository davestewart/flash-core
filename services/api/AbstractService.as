package core.services.api {
	import core.net.rest.AsyncToken;
	import core.net.rest.RestService;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class AbstractService extends RestService 
	{
		/*
			RestClient
				RestService
					AbstractService				- sets up a service using XML
						Concrete Service		- 
		 */
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var _config		:XML;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function AbstractService(server:String, config:XML)
			{
				super(server);
				_config = config;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			protected function call(callName:String, data:* = null, onComplete:Function = null, onSuccess:Function = null):AsyncToken 
			{
				// variables
					var call		:XML		= getCallXML(callName);
					var path		:String		= call.attribute('path');
					var method		:String		= call.attribute('method');
					var desc		:String		= call.attribute('desc');
					
				// make the call
					if (/^(get|post|put|delete)$/.test(method))
					{
						return this[method].call(this, path, data, onComplete, onSuccess);
					}
					else
					{
						throw new Error('Unknown method "' +method+ '" calling "' +callName+ '" (' +desc+ ')');
					}					
			}
		
			public function getCallXML(callName:String):XML
			{
				var calls:XMLList = _config.call.(attribute('name') == callName);
				if (calls.length())
				{
					return calls[0];
				}
				throw new Error('Unable to find the service call named "' +callName+ '"');
			}
			
			public function getEndpoint(callName:String):String 
			{
				return getCallXML(callName).@path;
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