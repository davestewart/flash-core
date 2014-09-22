package core.services.api 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import app.services.*
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class AbstractApi extends EventDispatcher 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// properties
				protected var _env				:String;
				protected var _config			:XML;
				protected var _server			:XML;
				
			// services, should be added in the subclass, i.e.
			
				// public var users:UsersService;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function AbstractApi() 
			{
				// do not insantiate this class directly!
			}
		
			public function initialize(config:XML, env:String = 'dev'):Boolean
			{
				// debug
					trace('initializing API...');
					
				// properties
					_config			= config;
					_env			= env;
					_server			= getServerXML(env);
					
				// return
					return true;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			public function getServerXML(serverName:String):XML 
			{
				var nodes:XMLList = _config.servers.server.(attribute('name') == serverName);
				if (nodes.length())
				{
					return nodes[0];
				}
				throw new Error('Unable to find the server named "' +serverName+ '"');
			}
		
			public function getServiceXML(serviceName:String):XML 
			{
				var nodes:XMLList = _config.services.service.(attribute('name') == serviceName);
				if (nodes.length())
				{
					return nodes[0];
				}
				throw new Error('Unable to find the service named "' +serviceName+ '"');
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}