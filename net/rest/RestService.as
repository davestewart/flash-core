package core.net.rest 
{
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
				protected var _service		:String;	
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function RestService(server:String, service:String, format:String = FORMAT_JSON, contentType:String = TYPE_JSON)
			{
				_server		= server;
				_service	= service;
				super(format, contentType);
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function get(endpoint:String):AsyncToken 
			{
				return super.get(getURL(endpoint));
			}
			
			override public function post(endpoint:String, values:Object = null):AsyncToken 
			{
				return super.post(getURL(endpoint), values);
			}
			
			override public function put(endpoint:String, values:Object = null):AsyncToken 
			{
				return super.put(getURL(endpoint), values);
			}
			
			override public function del(endpoint:String, values:Object = null):AsyncToken 
			{
				return super.del(getURL(endpoint), values);
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get server():String { return _server; }
			public function set server(value:String):void 
			{
				_server = value.replace(/\/+/, '');
			}
			
			public function get service():String { return _service; }
			public function set service(value:String):void 
			{
				_service = value.replace(/^\/+|\/+$/g, '');
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function getURL(endpoint:String):String 
			{
				return _server + _service.replace(/^\/*|\/*$/g, '/') + endpoint;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}