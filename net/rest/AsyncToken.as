package core.net.rest 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
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
				protected var _data		:*;
				protected var _date		:Date;
				protected var _url		:String;
				protected var _format	:String;
				protected var _method	:String;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function AsyncToken(url:String, method:String, format:String, onSuccess:Function = null, onError:Function = null) 
			{
				// properties
					_url		= url;
					_method		= method;
					_format		= format;
					_date		= new Date();
					
				// handlers
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

			public function get data():* { return _data; }
			
			public function get url():String { return _url; }
			
			public function get format():String { return _format; }
			
			public function get method():String { return _method; }
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			public function onSuccess(event:Event):void
			{
				if (_format !== RestClient.TYPE_TEXT)
				{
					try
					{
						switch(format)
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
						var message:String = 'The REST response could not be parsed. Expected "' + format + '" but got: \n ' + event.target.data;
						trace('\n' + message);
						throw(new Error(message));
					}
				}
				else
				{
					_data = event.target.data;
				}
				dispatchEvent(new RestEvent(RestEvent.SUCCESS, _data, event));
			}
		
			public function onError(event:IOErrorEvent):void
			{
				dispatchEvent(new RestEvent(RestEvent.ERROR, event.target.data, event));
			}
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			override public function toString():String
			{
				return '[object AysncToken url="' +url+ '" method="' +method+ '" format="' +format+ '" date="' +date+ '"]';
			}
			
	}

}