package core.net.rest 
{
	import core.net.PHPVariables;
	import core.utils.Base64;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class RestClient extends EventDispatcher 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// method constants
				public static const METHOD_GET			:String = 'GET';
				public static const METHOD_POST			:String = 'POST';
				public static const METHOD_PUT			:String = 'PUT';
				public static const METHOD_DELETE		:String = 'DELETE';
				
			// types constants @see http://en.wikipedia.org/wiki/Internet_media_type
				public static const TYPE_TEXT			:String	= 'text/plain';
				public static const TYPE_FORM			:String = 'application/x-www-form-urlencoded';
				public static const TYPE_JSON			:String = 'application/json';
				public static const TYPE_XML			:String = 'application/xml';
				
			// properties
				protected var _contentType				:String;
				protected var _responseType				:String;
				protected var _credentials				:String;
				
			// debugging
				public var debug						:Boolean;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function RestClient(responseType:String = TYPE_TEXT, contentType:String = TYPE_FORM)
			{
				this.contentType	= contentType;
				this.responseType	= responseType;
			}
			
			static public function factory(responseType:String = TYPE_TEXT, contentType:String = TYPE_FORM):RestClient 
			{
				return new RestClient(responseType, contentType);
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function authorize(name:String = '', password:String = ''):void
			{
				credentials = name ? Base64.encode(name + ':' + password) : null;
			}
			
			/**
			 * Perform a a GET call on a URL
			 * @param	url
			 * @return 
			 */
			public function get(url:String, data:* = null, onSuccess:Function = null, onError:Function = null):AsyncToken
			{
				return send(url, data, METHOD_GET, onSuccess, onError);
			}
			
			/**
			 * Perform a POST call on a URL
			 * @param	url
			 * @param	data
			 * @param	onSuccess
			 * @param	onError
			 * @return
			 */
			public function post(url:String, data:* = null, onSuccess:Function = null, onError:Function = null):AsyncToken 
			{
				return send(url, data, METHOD_POST, onSuccess, onError);
			}
			
			/**
			 * Perform a PUT call on a URL
			 * @param	url
			 * @param	values
			 * @return
			 */
			public function put(url:String, data:* = null, onSuccess:Function = null, onError:Function = null):AsyncToken 
			{
				return send(url, data, METHOD_PUT, onSuccess, onError);
			}
			
			/**
			 * Perform a DELETE call on a URL
			 * @param	url
			 * @param	values
			 * @return
			 */
			public function del(url:String, data:* = null, onSuccess:Function = null, onError:Function = null):AsyncToken 
			{
				return send(url, data, METHOD_DELETE, onSuccess, onError);
			}
		
			/**
			 * 
			 * @param	url
			 * @param	data
			 * @param	method
			 * @param	onLoadComplete
			 * @param	onLoadError
			 * @return
			 */
			public function send(url:String, values:* = null, method:String = METHOD_GET, onSuccess:Function = null, onError:Function = null):AsyncToken 
			{
				// variables
					var token				:AsyncToken;
					var data				:URLVariables;
					var request				:URLRequest;
					var loader				:URLLoader;
					
				// throw error if a Function is passed as the second argument
					if (values is Function)
					{
						throw new TypeError('The parameter "values" passed to send() cannot be a Function');
					}
					
				// use a methods URLRequest understands
				
					
				// if a URLRequest (i.e. a pre-built multipart-form request) is passed in, use it
					if (values is URLRequest)
					{
						request			= values;
						request.url		= url;
					}
					
				// otherwise, build a new request
					else
					{
						// data
							data					= getVariables(values);
								
						// request
							request					= new URLRequest(url);
							request.contentType		= contentType;
							request.data			= data.toString() == '' ? ' ' : data; // prevents server 404-ing if no data
					}
					
				// add method override headers for PUT and DELETE
					switch(method)
					{
						case METHOD_PUT:
						case METHOD_DELETE:
								request.method = METHOD_POST;
								request.requestHeaders.push(new URLRequestHeader('X-HTTP-Method-Override', method));
							break;
						
						default:
							request.method = method;
					}
					
				// credentials
					if (_credentials)
					{
						request.requestHeaders.push(new URLRequestHeader('Authorization', 'Basic ' + _credentials));
					}

				// set up the loader
					loader					= new URLLoader();
					
				// set up the token
					token					= new AsyncToken(url, method, _responseType, loader, onSuccess, onError);
					
				// add client event handlers
					loader.addEventListener(Event.COMPLETE, this.onSuccess);
					loader.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
					
				// debug
					trace('RestClient: [' + method + '] ' + url);
					
				// load
					loader.load(request);
				
				// return
					return token;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get contentType():String { return _contentType; }
			public function set contentType(value:String):void 
			{
				_contentType = value;
			}
			
			public function get responseType():String { return _responseType; }
			public function set responseType(value:String):void 
			{
				_responseType = value;
			}
			
			public function get credentials():String { return _credentials; }
			public function set credentials(value:String):void 
			{
				_credentials = value;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		

					
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onSuccess(event:Event):void 
			{
				// forward the event
					dispatchEvent(event);
					
				// output data if debugging
					if (debug)
					{
						trace('RestClient.SUCCESS:', event);
						trace('---------------------------------------------------------------------------------------------');
						trace(event.target.data);
						trace('---------------------------------------------------------------------------------------------');
					}
					
				// cleanup
					cleanup(event.target);
				
			}
			
			protected function onError(event:IOErrorEvent):void 
			{
				// forward the event
					//dispatchEvent(event);
					
				// output data if debugging
					if (debug)
					{
						trace('RestClient.ERROR:', event);
						trace('---------------------------------------------------------------------------------------------');
						trace(event.target.data);
						trace('---------------------------------------------------------------------------------------------');
					}
					
				// cleanup
					cleanup(event.target);
			}
			
			protected function cleanup(target:*):void 
			{
				target.addEventListener(Event.COMPLETE, this.onSuccess);
				target.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function getVariables(data:*):URLVariables
			{
				return data is URLVariables ? data : new PHPVariables(data);
			}
			
	}

}