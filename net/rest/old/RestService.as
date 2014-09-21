package core.net.rest.old {
	import mx.rpc.AsyncToken;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class RestService extends RestClient 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var _server		:String;	
				protected var _name			:String;	
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function RestService(server:String, name:String, reponseType:String = FORMAT_JSON, contentType:String = TYPE_JSON)
			{
				_server		= server;
				_name		= name;
				super(reponseType, contentType);
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function get(endpoint:String, data:* = null, onResult:Function = null, onFault:Function = null):AsyncToken 
			{
				return super.get(getURL(endpoint), data);
			}
			
			override public function post(endpoint:String, data:* = null):AsyncToken 
			{
				return super.post(getURL(endpoint), data, onResult, onFault);
			}
			
			override public function put(endpoint:String, data:* = null):AsyncToken 
			{
				return super.put(getURL(endpoint), data, onResult, onFault);
			}
			
			override public function del(endpoint:String, data:* = null):AsyncToken 
			{
				return super.del(getURL(endpoint), data, onResult, onFault);
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get server():String { return _server; }
			public function set server(value:String):void 
			{
				_server = value.replace(/\/+/, '');
			}
			
			public function get name():String { return _name; }
			public function set name(value:String):void 
			{
				_name = value.replace(/^\/+|\/+$/g, '');
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function getURL(endpoint:String):String 
			{
				return _server + _name.replace(/^\/*|\/*$/g, '/') + endpoint;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}