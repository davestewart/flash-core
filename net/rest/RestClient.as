package core.net.rest 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import mx.messaging.messages.AsyncMessage;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	/**
	 * ...
	 * 
	 * This class uses the folowing Flex services:
	 * 
	 *  - HTTPService		http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/rpc/http/HTTPService.html
	 *  - AsycResponder		http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/rpc/AsyncResponder.html
	 * 
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
				
			// request (content type) constants 
				// @see http://en.wikipedia.org/wiki/Internet_media_type
				public static const TYPE_FORM			:String = 'application/x-www-form-urlencoded';
				public static const TYPE_XML			:String = 'application/xml';
				public static const TYPE_JSON			:String = 'application/json';
				
			// response (format) constants
				public static const FORMAT_OBJECT		:String	= 'object';
				public static const FORMAT_ARRAY		:String	= 'array';
				public static const FORMAT_XML			:String	= 'xml';
				public static const FORMAT_E4X			:String	= 'e4x';
				public static const FORMAT_TEXT			:String	= 'text';
				public static const FORMAT_JSON			:String	= 'json';

			// variables
				protected var service					:HTTPService;
				
			// variables
				protected var _contentType				:String;
				protected var _responseType				:String;
				protected var _credentials				:String;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function RestClient(responseType:String = FORMAT_JSON, contentType:String = TYPE_FORM)
			{
				initialize();
				this.contentType	= contentType;
				this.responseType	= responseType;
			}
			
			protected function initialize():void 
			{
				// connection
					service			= new HTTPService();
					
				// settings
					timeout			= 15;
			}


		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Perform a a GET call on a URL
			 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/rpc/AsyncToken.html
			 * @param	url
			 * @return 
			 */
			public function get(url:String, data:* = null):AsyncToken 
			{
				return send(url, data, METHOD_GET);
			}
			
			/**
			 * Perform a POST call on a URL
			 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/rpc/AsyncToken.html
			 * @param	url
			 * @param	values
			 * @return
			 */
			public function post(url:String, data:* = null):AsyncToken 
			{
				return send(url, data, METHOD_POST);
			}
			
			/**
			 * Perform a PUT call on a URL
			 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/rpc/AsyncToken.html
			 * @param	url
			 * @param	values
			 * @return
			 */
			public function put(url:String, data:* = null):AsyncToken 
			{
				return send(url, data, METHOD_PUT);
			}
			
			/**
			 * Perform a DELETE call on a URL
			 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/rpc/AsyncToken.html
			 * @param	url
			 * @param	values
			 * @return
			 */
			public function del(url:String, data:* = null):AsyncToken 
			{
				return send(url, data, METHOD_DELETE);
			}
		
					
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
			public function get contentType():String { return _contentType; }
			public function set contentType(value:String):void
			{
				switch(value)
				{
					case TYPE_FORM:
					case TYPE_JSON:
					case TYPE_XML:
						service.contentType		= value;
						//service.headers.Accept	= value;
						break;
						
					default:
						throw new Error('Invalid content-type "' +value+ '"');
				}
			}
			
			public function get responseType():String { return _responseType; }
			public function set responseType(value:String):void 
			{
				_responseType = value;
				switch (value) 
				{
					case FORMAT_OBJECT:
					case FORMAT_ARRAY:
					case FORMAT_XML:
					case FORMAT_E4X:
					case FORMAT_TEXT:
						service.resultFormat			= _responseType;
						break;
					
					case FORMAT_JSON:
						service.resultFormat			= FORMAT_TEXT;
						break;
					
					default:
						throw new Error('Invalid format "' +value+ '"');
				}
			}
		
			public function get credentials():String { return _credentials }
			public function set credentials(value:String):void
			{
				if(value.length)
				{
					service.request.authenticate	= true; // possibly not needed
					service.headers.Authorization	= 'Basic ' + value;
				}
				else
				{
					this.service.request.authenticate = false;
					delete service.headers.Authorization;;
				}
			}
			
			public function get timeout():int{ return this.service.requestTimeout; }
			public function set timeout(value:int):void
			{
				service.requestTimeout	= value;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			public function send(url:String, data:* = null, method:String = METHOD_GET):AsyncToken
			{
				// values
					var asyncToken		:AsyncToken;
					var responder		:IResponder;
				
				// methods
					service.method		= method;
					
				// data
					if (_responseType == TYPE_JSON)
					{
						var json:String = data ? JSON.stringify(data) : null;
					}
					
				// setup
					switch(method)
					{
						case METHOD_GET:
							service.url			= url;
							responder			= new AsyncResponder(onResult, onFault, asyncToken);
							asyncToken			= service.send();
							asyncToken.addResponder(responder);
							break;
							
						case METHOD_POST:
							service.url			= url;
							responder			= new AsyncResponder(onResult, onFault, asyncToken);
							asyncToken			= service.send(json);
							asyncToken.addResponder(responder);
							break;
							
					}
					
				// return
					return asyncToken;
			}
			
			public function send2(url:String, data:* = null, method:String = METHOD_GET, onResult:Function = null, onFault:Function = null):AsyncToken 
			{
				// debug
					// @see http://stackoverflow.com/questions/6853095/need-to-use-httpservice-rather-than-urlrequest-to-send-data-content-type-is-mes
					// @See http://stackoverflow.com/questions/3641148/how-to-send-put-http-request-in-flex
					
				// variables
					var token			:AsyncToken;
					var responder		:IResponder;
					var vars			:URLVariables;
					
				// data
					if (data)
					{
						// convert data to URLVariables
							vars = getVariables(data);
							
						// if it's a GET route, add the data to the URL
							if (method == METHOD_GET)
							{
								url		+= (url.indexOf('?') > -1 ? '&' : '?') + vars.toString();
								data	= null;
							}
					}
					
				// tidy up overrides
					delete service.headers['X-HTTP-Method-Override'];
					
				// method
					switch(method)
					{
						case METHOD_GET:
								service.method		= METHOD_GET;
							break;
							
						case METHOD_POST:
								service.method		= METHOD_POST;
								if ( ! vars )
								{
									throw new Error('Attempting to call a POST URL with no data');
								}
							break;
						
						case METHOD_PUT:
						case METHOD_DELETE:
								// override service method
								// @see http://stackoverflow.com/questions/3641148/how-to-send-put-http-request-in-flex
								// @see http://www.hanselman.com/blog/HTTPPUTOrDELETENotAllowedUseXHTTPMethodOverrideForYourRESTServiceWithASPNETWebAPI.aspx
								service.method		= METHOD_POST;
								service.headers['X-HTTP-Method-Override'] = method;
							break;
						
						default:
					}
					
				// url

				// send
					service.url		= url;
					token			= service.send(vars);
					
				// debug
					trace()
					trace('url: ' + service.url);
					trace('method: ' + service.method);
					trace('contentType: ' + service.contentType);
					trace('resultFormat: ' + service.resultFormat);
					trace('headers: ' + getVariables(service.headers));
					trace()
					
				// token variables
					token.date		= new Date();
					token.url		= service.url;
					
				// client callback
					responder		= new AsyncResponder(this.onResult, this.onFault, token);
					token.addResponder(responder);
					
				// request callback
					if (onResult !== null)
					{
						responder	= new AsyncResponder(onResult, onFault, token);
						token.addResponder(responder);
					}

				// return
					return token;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onResult(event:ResultEvent,token:Object=null):void
			{
				trace('Reached onResult handler');
				var data:* = event.result;
				if (_responseType === FORMAT_JSON)
				{
					data = JSON.parse(String(data));
				}
				dispatchEvent(new RestEvent(RestEvent.SUCCESS, data, event.statusCode, null, event.token));
			
			}
			
			protected function onFault(event:FaultEvent, token:Object = null):void
			{
				trace('Reached onfault handler');
				switch(event.statusCode)
				{
					
					case 401: // access denied
						dispatchEvent(new RestErrorEvent(RestErrorEvent.ACCESS_DENIED, event, event.statusCode, event.fault.faultString, event.token));
						break;
						
					
					case 201: // item created
					case 422: // already exists
						dispatchEvent(new RestErrorEvent(RestErrorEvent.FAILURE, event, event.statusCode, String(event.message.body), event.token));
						break;
					
					// unknown
					default:
						dispatchEvent(new RestErrorEvent(RestErrorEvent.FAILURE, null, event.statusCode, event.fault.faultString, event.token));
						break;
				}

				trace(event.fault.faultString);
				
			}
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function getVariables(data:*):URLVariables
			{
				if (data is URLVariables)
				{
					return data.toString().length > 0 ? data : null;
				}
				else if (data is Object)
				{
					var hasdata		:Boolean;
					var vars		:URLVariables = new URLVariables();
					for (var name:String in data)
					{
						hasdata = true;
						vars[name] = data[name];
					}
				}
				return hasdata ? vars : null;
			}
			
			
	}

}