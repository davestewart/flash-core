package core.net.rest2 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	dynamic public class AsyncToken extends EventDispatcher 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				public var url		:String;
				public var format	:String;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function AsyncToken(url:String, format:String, onComplete:Function, onError:Function) 
			{
				this.url		= url;
				this.format		= format;
				addEventListener(Event.COMPLETE, onComplete);
				addEventListener(IOErrorEvent, onError);
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			public function onComplete(event:Event):void
			{
				switch(format)
				{
					case RestClient.TYPE_FORM:
						event.target.data = new URLVariables(event.target.data);
						break;
					
					case RestClient.TYPE_JSON:
						try
						{
							event.target.data = JSON.parse(event.target.data);
						}
						catch (error:Error)
						{
							throw error;
						}
						break;
					
					case RestClient.TYPE_XML:
						event.target.data = new XML(event.target.data);
						break;
					
					default:
				}
				dispatchEvent(event);
			}
		
			public function onError(event:IOErrorEvent):void
			{
				dispatchEvent(event);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}