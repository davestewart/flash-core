package core.net.rest 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

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
				
			// format constants
				public static const FORMAT_JSON			:String = 'application/json';
		
			// properties
				private var service						:HTTPService;
				private var loader						:URLLoader;
				private var request						:URLRequest;
									
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function RestClient(target:IEventDispatcher = null)
			{
				super(target);
				setup();
			}
			
			protected function setup():void 
			{
				// request
					request					= new URLRequest();
					
				// connection
					service					= new HTTPService();
					service.resultFormat	= 'text';
					service.request.authenticate = false;
					
				// settings
					contentType				= FORMAT_JSON;
					timeout					= 15;
					
				// loader
					loader					= new URLLoader();
					loader.dataFormat		= 'text';
					loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
					loader.addEventListener(Event.COMPLETE, onComplete);
					// set the credentials
				
					// This gives a null exception when enabled
					//	loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, handleHttpResponseStatus);
					
				// content type
					
			}


		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function get(url:String):AsyncToken 
			{
				return send(url, null, METHOD_GET);
			}
			
			public function post(url:String, values:Object = null):AsyncToken 
			{
				return send(url, values, METHOD_POST);
			}
			
			public function put(url:String, values:Object = null):AsyncToken 
			{
				return send(url, values, METHOD_PUT);
			}
			
			public function del(url:String, values:Object = null):AsyncToken 
			{
				return send(url, values, METHOD_DELETE);
			}
		
			public function send(url:String, values:Object = null, method:String = METHOD_GET):AsyncToken
			{
				// values
					var asyncToken		:AsyncToken;
					var iresponder		:IResponder;
					var json			:String = values ? JSON.stringify(values) : null;
				
				// methods
					service.method		= method;
					request.method		= method;
					
				// setup
					switch(method)
					{
						case RestClient.METHOD_GET:
							service.url			= url;
							iresponder			= new AsyncResponder(onResult, onFault, asyncToken);
							asyncToken			= this.service.send();
							asyncToken.addResponder(iresponder);
							break;
							
						case RestClient.METHOD_POST:
							service.url			= url;
							iresponder			= new AsyncResponder(onResult, onFault, asyncToken);
							asyncToken			= this.service.send(json);
							asyncToken.addResponder(iresponder);
							break;
							
						case RestClient.METHOD_PUT:
							request.url			= url;
							request.data		= unescape(json);
							loader.load(request);
							break;
							
						case RestClient.METHOD_DELETE:
							request.url			= url;
							request.data		= unescape(json);
							loader.load(request);
							break;
						
					}
					
				// return
					return asyncToken;
			}
			
					
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function set contentType(type:String):void
			{
				switch(type)
				{
					case RestClient.FORMAT_JSON:
						service.contentType			= RestClient.FORMAT_JSON;
						request.contentType			= RestClient.FORMAT_JSON;
						var header:URLRequestHeader	= new URLRequestHeader('Accept', RestClient.FORMAT_JSON); 
						request.requestHeaders.push(header);
						break;
						
					default:
						throw new Error('Invalid content type "' +type+ '"');
				}
			}
			
			public function set credentials(encoded:String):void
			{
				
				if(encoded)
				{
					// Set the other headers too
						service.headers = 
						{
							'Accept'			: 'application/json',
							'Authorization'		: 'Basic ' + encoded
						};
						
					// url header
						var urlheader:URLRequestHeader = new URLRequestHeader('Authorization', 'Basic ' + encoded);
						request.requestHeaders.push(urlheader);
				}
				
				// this makes the user skip the ssl verify popup
				//this.request.authenticate = false;
				//this.service.request.authenticate = false;
				//URLRequestDefaults.setLoginCredentialsForHost();
			}
			
			public function get timeout():int{ return this.service.requestTimeout; }
			public function set timeout(time:int):void
			{
				service.requestTimeout	= time;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
		

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onResult(event:ResultEvent,token:Object=null):void
			{
				trace('Reached onResult handler');
				dispatchEvent(new RestEvent(RestEvent.SUCCESS, String(event.result), event.statusCode, null, event.token));
			
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
			
			protected function onComplete(event:Event):void
			{
				// loader has completed everything
				trace('The data has successfully loaded');
			}
						
			protected function onIOError(event:IOErrorEvent):void
			{
				trace('Reached handleIOError : Load failed: IO error: ' + event.text);
				this.dispatchEvent(new RestErrorEvent(RestErrorEvent.IOERROR, event.target.data, -1));;
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