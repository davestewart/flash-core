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
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function RestService(server:String, reponseType:String = RestClient.TYPE_JSON, contentType:String = RestClient.TYPE_FORM)
			{
				// properties
					this.server		= server;
					
				// objects
					_client			= new RestClient(reponseType, contentType);
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
				// variables
					var data	:Object;
					var param	:String;
					var rx		:RegExp;
					
				// replace by property
					if (typeof params[0] == 'object')
					{
						function replaceFn(input:String, a:String, b:String, index:int, all:String):String
						{
							return a in data
									? data[a]
									: b in data
										? data[b]
										: input;
						}
						data = params[0];
						path = path.replace(/{(\w+)}|:(\w+)\b/g, replaceFn);
					}
					
				// replace by index
					else
					{
						while (params.length)
						{
							param	= params.shift();
							rx		= /{(\w+)}|:(\w+)\b/;
							path	= path.replace(rx, param);
						}
					}
					
				// return the result
					return path;
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