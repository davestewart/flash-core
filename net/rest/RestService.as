package core.net.rest
{
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
				protected var _path			:String;	
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function RestService(server:String, path:String = '', reponseType:String = RestClient.TYPE_JSON, contentType:String = RestClient.TYPE_FORM)
			{
				// properties
					this.server		= server;
					this.path		= path;
					
				// objects
					_client			= new RestClient(reponseType, contentType);
					_client.addEventListener(RestEvent.SUCCESS, onSuccess);
					_client.addEventListener(RestEvent.ERROR, onError);
					
				// initialize
					initialize();
			}
		
			protected function initialize():void 
			{
				
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
			
			/**
			 * Set or get the name of the service, i.e. "users"
			 */
			public function get path():String { return _path; }
			public function set path(value:String):void 
			{
				_path = value;
			}
			
			public function get client():RestClient { return _client; }
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
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
			
			protected function getURL(endpoint:String, data:*):String 
			{
				// replacement function
					function replace(input:String, a:String, b:String, index:int, all:String):String
					{
						return data[a || b] || a || b;
					}
					
				// variables
					var server		:String		= _server;
					var path		:String		= _path;
					var fullpath	:String;
					
				// set up the sever
					server		= server
									.replace(/\/*$/, '/'); // add a trailing slash to the server
					
				// get the name, if there is one
					if (path != '')
					{
						path	= path
									.replace(/^\/+/g, '') // remove any leading slash from the service name
									.replace(/\/*$/g, '/') // add a trailing slash to the service name
					}
						
				// build end point
					fullpath	= (path + endpoint)
									.replace(/\/+/, '/') // replace any double-slashes that might have crept in
									.replace(/{(\w+)}|:(\w+)\b/g, replace); // replace placeholders with values
					
				// return
					return server + fullpath;
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
				return '[object Service server="' +server+ '" path="' +path+ '" responseType="' +client.responseType+ '" contentType="' +client.contentType+ '"]';
			}
	}

}