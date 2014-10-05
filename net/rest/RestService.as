package core.net.rest
{
	import core.utils.Strings;
	import flash.events.EventDispatcher;
	import core.net.rest.RestClient;
	
	/**
	 * Wraps the RestClient, and provides a set of convenience methods to set properties up once, then make simple calls to individual endpoints
	 * @author Dave Stewart
	 */
	public class RestService extends EventDispatcher
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements
				protected var _client		:RestClient;
			
			// properties
				protected var _server		:String;	
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function RestService(server:String, reponseType:String = '', contentType:String = '')
			{
				// properties
					this.server		= server;
					
				// objects
					_client			= new RestClient(reponseType || RestClient.TYPE_JSON, contentType || RestClient.TYPE_FORM);
					_client.addEventListener(RestEvent.SUCCESS, onSuccess);
					_client.addEventListener(RestEvent.ERROR, onError);
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			// public methods should be created on Services subclassing this class
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			/**
			 * Set or get the URL of the server / API, i.e. "http://yourdomain.com/api/"
			 */
			public function get server():String { return _server; }
			public function set server(value:String):void 
			{
				_server = value;
			}
			
			public function get client():RestClient { return _client; }
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: rest methods
		
			protected function get(endpoint:String, data:* = null, onSuccess:Function = null, onError:Function = null):AsyncToken 
			{
				return _client.get(getURL(endpoint, data), data, onSuccess, onError);
			}
			
			protected function post(endpoint:String, data:* = null, onSuccess:Function = null, onError:Function = null):AsyncToken 
			{
				return _client.post(getURL(endpoint, data), data, onSuccess, onError);
			}
			
			protected function put(endpoint:String, data:* = null, onSuccess:Function = null, onError:Function = null):AsyncToken 
			{
				return _client.put(getURL(endpoint, data), data, onSuccess, onError);
			}
			
			protected function del(endpoint:String, data:* = null, onSuccess:Function = null, onError:Function = null):AsyncToken 
			{
				return _client.del(getURL(endpoint, data), data, onSuccess, onError);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: url-building functions
		
			protected function getURL(endpoint:String, params:*):String 
			{
				// variables
					var server	:String		= _server.replace(/\/*$/, '/'); // add trailing slash
					var path	:String		= getPath(endpoint, params).replace(/^\/+/, ''); // trim leading slash
					
				// return
					return server + path;
			}
			
			protected function getPath(path:String, ...params):String 
			{
				return Strings.populate(path, params);
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onSuccess(event:RestEvent):void 
			{
				dispatchEvent(event);
			}
			
			protected function onError(event:RestEvent):void 
			{
				dispatchEvent(event);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			override public function toString():String
			{
				return '[object Service server="' +server+ '" responseType="' +client.responseType+ '" contentType="' +client.contentType+ '"]';
			}
	}

}