package core.net.rest 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	dynamic public class AsyncToken extends EventDispatcher 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// properties
				protected var _data			:*;
				protected var _date			:Date;
				protected var _url			:String;
				protected var _responseType	:String;
				protected var _method		:String;
				protected var _loader		:URLLoader;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function AsyncToken(url:String, method:String, format:String, loader:URLLoader, onSuccess:Function = null, onError:Function = null) 
			{
				// properties
					_date			= new Date();
					_url			= url;
					_method			= method;
					_responseType	= format;
					_loader			= loader;
					
				// internal handlers
					_loader.addEventListener(Event.COMPLETE, this.onSuccess, false, 1);
					_loader.addEventListener(IOErrorEvent.IO_ERROR, this.onError, false, 1);
					
				// external handlers
					if (onSuccess !== null)
					{
						addEventListener(RestEvent.SUCCESS, onSuccess, false, 0, true);
					}
					if (onError !== null)
					{
						addEventListener(RestEvent.ERROR, onError, false, 0, true);
					}
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get date():Date { return _date; }

			public function get loader():URLLoader { return _loader; }
			
			public function get url():String { return _url; }
			
			public function get method():String { return _method; }
			
			public function get data():* { return _data; }
			
			public function get responseType():String { return _responseType; }
			
			public function get format():String
			{
				switch(_responseType)
				{
					case RestClient.TYPE_TEXT:	return 'text';
					case RestClient.TYPE_JSON:	return 'json';
					case RestClient.TYPE_XML:	return 'xml';
				}
				return 'object';
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onSuccess(event:Event):void
			{
				// convert response
					if (_responseType !== RestClient.TYPE_TEXT)
					{
						try
						{
							switch(responseType)
							{
								case RestClient.TYPE_FORM:
									_data = new URLVariables(event.target.data);
									break;
								
								case RestClient.TYPE_JSON:
									_data = JSON.parse(event.target.data);
									break;
								
								case RestClient.TYPE_XML:
									_data = new XML(event.target.data);
									break;
							}
						}
						catch (error:Error)
						{
							var message:String = 'The REST response could not be parsed. Expected "' + responseType + '" but got: \n ' + event.target.data;
							trace('\n' + message);
							throw(new Error(message));
						}
					}
					else
					{
						_data = event.target.data;
					}
					
				// dispatch
					dispatchEvent(new RestEvent(RestEvent.SUCCESS, _data, event));
					
				// cleanup
					cleanup();
			}
			
			protected function onError(event:IOErrorEvent):void
			{
				dispatchEvent(new RestEvent(RestEvent.ERROR, event.target.data, event));
				cleanup();
			}
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function cleanup():void 
			{
				_loader.removeEventListener(Event.COMPLETE, onSuccess);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			}
		
			override public function toString():String
			{
				return '[object AysncToken url="' +url+ '" method="' +method+ '" bytes="' +_loader.bytesTotal+ '" format="' +format+ '" responseType="' +responseType+ '" date="' +date+ '"]';
			}
			
	}

}