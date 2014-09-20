package core.net.rest2 
{
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
				public static const METHOD_DELETE		:String = 'DELETE';
				public static const METHOD_PUT			:String = 'PUT';
				
			// types constants @see http://en.wikipedia.org/wiki/Internet_media_type
				public static const TYPE_TEXT			:String	= 'text/plain';
				public static const TYPE_FORM			:String = 'application/x-www-form-urlencoded';
				public static const TYPE_JSON			:String = 'application/json';
				public static const TYPE_XML			:String = 'application/xml';
				
			// properties
				protected var _contentType				:String;
				protected var _responseType				:String;
				protected var _credentials				:String;
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function RestClient(responseType:String = TYPE_TEXT, contentType:String = TYPE_FORM)
			{
				initialize();
				this.contentType	= contentType;
				this.responseType	= responseType;
			}
			
			protected function initialize():void 
			{
				
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Perform a a GET call on a URL
			 * @param	url
			 * @return 
			 */
			public function get(url:String, data:* = null):URLLoader
			{
				return send(url, data, METHOD_GET);
			}
			
			/**
			 * Perform a POST call on a URL
			 * @param	url
			 * @param	values
			 * @return
			 */
			public function post(url:String, data:* = null):URLLoader 
			{
				return send(url, data, METHOD_POST);
			}
			
			/**
			 * Perform a PUT call on a URL
			 * @param	url
			 * @param	values
			 * @return
			 */
			public function put(url:String, data:* = null):URLLoader 
			{
				return send(url, data, METHOD_PUT);
			}
			
			/**
			 * Perform a DELETE call on a URL
			 * @param	url
			 * @param	values
			 * @return
			 */
			public function del(url:String, data:* = null):URLLoader 
			{
				return send(url, data, METHOD_DELETE);
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
			public function send(url:String, data:* = null, method:String = METHOD_GET, onLoadComplete:Function = null, onLoadError:Function = null):URLLoader 
			{
				// variables
					var request			:URLRequest;
					var loader			:URLLoader;
					
				// request
					request				= new URLRequest(url);
					request.data		= getVariables(data);
					request.contentType	= _contentType;

				// send
					switch(method)
					{
						case 'GET':
								request.method = method;
							break;
							
						case 'POST':
								request.method = method;
								if ( ! request.data )
								{
									throw new Error('Attempting to call a POST URL with no data');
								}
							break;
						
						case 'PUT':
						case 'DELETE':
								request.method = 'POST';
								request.requestHeaders.push(new URLRequestHeader('X-HTTP-Method-Override', method));
							break;
						
						default:
					}

				// make the request
					loader = new URLLoader();
					if (onLoadComplete !== null)
					{
						loader.addEventListener(Event.COMPLETE, getHandler(_responseType, onLoadComplete));
					}
					if (onLoadError !== null)
					{
						loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
					}
					loader.load(request);
				
				// return
					return loader;
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
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		

					
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function getHandler(format:String, onComplete:Function):Function 
			{
				return (function (event:Event):void
				{
					switch(format)
					{
						case TYPE_FORM:
							event.target.data = new URLVariables(event.target.data);
							break;
						
						case TYPE_JSON:
							event.target.data = JSON.parse(event.target.data);
							break;
						
						case TYPE_XML:
							event.target.data = new XML(event.target.data);
							break;
						
						default:
					}
					onComplete(event);
				});
			}
		
			protected function getVariables(data:*):URLVariables
			{
				// URL variables
					if (data is URLVariables)
					{
						return data.toString().length > 0 ? data : null;
					}
					
				// plain object
					else
					{
						var hasData		:Boolean;
						var vars		:URLVariables = new URLVariables();
						for (var name:String in data)
						{
							hasData = true;
							vars[name] = data[name];
						}
					}
				
				// return
					return hasData ? vars : null;
			}
			
	}

}