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
				
			// content type constants
				public static const TYPE_FORM			:String = HTTPService.CONTENT_TYPE_FORM;
				public static const TYPE_VARS			:String = 'text/variables';
				public static const TYPE_JSON			:String = 'application/json';
				public static const TYPE_XML			:String = 'application/xml';
				
			// return format constants
				public static const FORMAT_OBJECT		:String	= 'object';
				public static const FORMAT_ARRAY		:String	= 'array';
				public static const FORMAT_XML			:String	= 'xml';
				public static const FORMAT_E4X			:String	= 'e4x';
				public static const FORMAT_TEXT			:String	= 'text';
				public static const FORMAT_JSON			:String	= 'json';

			// variables
				protected var service					:HTTPService;
				protected var loader					:URLLoader;
				protected var request					:URLRequest;
				
			// properties
				protected var _format					:String;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function RestClient(format:String = FORMAT_JSON, contentType:String = TYPE_JSON)
			{
				initialize();
				this.contentType	= contentType;
				this.format			= format;
			}
			
			protected function initialize():void 
			{
				// request
					request			= new URLRequest();
					
				// connection
					service			= new HTTPService();
					service.request.authenticate = false;
					
				// loader
					loader			= new URLLoader();
					loader.addEventListener(Event.COMPLETE, onComplete);
					loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
					
				// settings
					timeout			= 15;
					
				// set the credentials
				
					// This gives a null exception when enabled
					//	loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, handleHttpResponseStatus);
					
				// content type
					
			}


		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Perform a a GET call on a URL
			 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/rpc/AsyncToken.html
			 * @param	url
			 * @return 
			 */
			public function get(url:String, values:* = null):AsyncToken 
			{
				return send(url, null, METHOD_GET);
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
		
			public function get format():String { return _format; }
			public function set format(value:String):void 
			{
				_format = value;
				switch (value) 
				{
					case FORMAT_OBJECT:
						service.resultFormat			= FORMAT_OBJECT;
						loader.dataFormat				= URLLoaderDataFormat.BINARY;		
						break;
					
					case FORMAT_ARRAY:
						service.resultFormat			= FORMAT_ARRAY;
						loader.dataFormat				= URLLoaderDataFormat.BINARY;		
						break;
					
					case FORMAT_XML:
						service.resultFormat			= FORMAT_XML;
						loader.dataFormat				= URLLoaderDataFormat.TEXT;		
						break;
					
					case FORMAT_E4X:
						service.resultFormat			= FORMAT_E4X;
						loader.dataFormat				= URLLoaderDataFormat.TEXT;		
						break;
					
					case FORMAT_TEXT:
						service.resultFormat			= FORMAT_TEXT;
						loader.dataFormat				= URLLoaderDataFormat.TEXT;		
						break;
					
					case FORMAT_JSON:
						service.resultFormat			= FORMAT_TEXT;
						loader.dataFormat				= URLLoaderDataFormat.TEXT;		
						break;
					
					default:
						throw new Error('Invalid format "' +value+ '"');
				}
			}
		
			public function set contentType(value:String):void
			{
				var header:URLRequestHeader; 
				switch(value)
				{
					case TYPE_VARS:
					case TYPE_JSON:
					case TYPE_XML:
						service.contentType		= value;
						request.contentType		= value;
						header					= new URLRequestHeader('Accept', value); 
						request.requestHeaders.push(header);
						break;
						
					default:
						throw new Error('Invalid content-type "' +value+ '"');
				}
			}
			
			public function set credentials(value:String):void
			{
				if(value.length)
				{
					// Set the other headers too
						service.headers = 
						{
							'Accept'			: 'application/json',
							'Authorization'		: 'Basic ' + value
						};
						
					// url header
						var urlheader:URLRequestHeader = new URLRequestHeader('Authorization', 'Basic ' + value);
						request.requestHeaders.push(urlheader);
				}
				
				// this makes the user skip the ssl verify popup
				//this.request.authenticate = false;
				//this.service.request.authenticate = false;
				//URLRequestDefaults.setLoginCredentialsForHost();
			}
			
			public function get timeout():int{ return this.service.requestTimeout; }
			public function set timeout(value:int):void
			{
				service.requestTimeout	= value;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function send(url:String, data:* = null, method:String = METHOD_GET):AsyncToken
			{
				// values
					var asyncToken		:AsyncToken;
					var responder		:IResponder;
				
				// methods
					service.method		= method;
					request.method		= method;
					
				// data
					if (_format == TYPE_JSON)
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
							
						case METHOD_PUT:
							request.url			= url;
							request.data		= unescape(json);
							loader.load(request);
							break;
							
						case METHOD_DELETE:
							request.url			= url;
							request.data		= unescape(json);
							loader.load(request);
							break;
						
					}
					
				// return
					return asyncToken;
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onResult(event:ResultEvent,token:Object=null):void
			{
				trace('Reached onResult handler');
				var data:* = event.result;
				if (_format === FORMAT_JSON)
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
					// access denied
					case 401:
						dispatchEvent(new RestErrorEvent(RestErrorEvent.ACCESS_DENIED, null, event.statusCode, event.fault.faultString, event.token));
						break;
						
					//redirected but still ok, difficult to determine if its ok
					case 302:
						dispatchEvent(new RestEvent(RestEvent.SUCCESS, String(event.fault), event.statusCode, null, event.token));
						// no break!
						
					// item created
					case 201:
						dispatchEvent(new RestEvent(RestEvent.SUCCESS, null, event.statusCode, null, event.token));
						break;
						
					//already exists
					case 422:
						dispatchEvent(new RestErrorEvent(RestErrorEvent.FAILURE, null, event.statusCode, String(event.message.body), event.token));
						break;
					
					// unknown
					default:
						dispatchEvent(new RestErrorEvent(RestErrorEvent.FAILURE, null, event.statusCode, event.fault.faultString, event.token));
						break;
				}

				trace(event.fault.faultString);
				
			}
			
			
			protected function onComplete(event:Event):void
			{
				// loader has completed everything
				trace('The data has successfully loaded');
				dispatchEvent(new RestEvent(RestEvent.SUCCESS, event.target.data, 200, null, null));
			}
			
			
			
			protected function onIOError(event:IOErrorEvent):void
			{
				trace('Reached handleIOError : Load failed: IO error: ' + event.text);
				this.dispatchEvent(new RestErrorEvent(RestErrorEvent.IOERROR, event.target.data, -1));;
			}
			
			//request.requestHeaders.push(new URLRequestHeader({Accept:'application/json'}));
			
			//request.requestHeaders.push(new URLRequestHeader('X-HTTP-Method-Override', URLRequestMethod.PUT));
			
			// Attempt to load some data
			
			protected function onHttpStatus(event:HTTPStatusEvent):void
			{
				trace('HTTP Status: ' + event.status);
				switch(event.status)
				{
					case 200:
						// Ok, everything went well
						trace('200, everything went well with http method');
						this.dispatchEvent(new RestEvent(RestEvent.SUCCESS, null, event.status));
						break;
							
					default:
						this.dispatchEvent(new RestEvent(RestEvent.SUCCESS, null, event.status));
				}
			}
			
			protected function onSecurityError(event:SecurityErrorEvent):void
			{
				trace('Load failed: Security Error: ' + event.text);
			}
			
			protected function onHttpResponseStatus(event:HTTPStatusEvent):void
			{
				trace('Load Response Status: HTTP Status = ' + event.toString());
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		

			
	}

}