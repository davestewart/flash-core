package core.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class EncoderEvent extends Event 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// phase event constants
					
				/// The encoder has not yet loaded or connected
				public static const NOT_READY			:String		= 'EncoderEvent.NOT_READY';

				/// The encoder has finished setup, and is ready to be initialized
				public static const READY				:String		= 'EncoderEvent.READY';

				/// The encoder has been initializedand is ready to record
				public static const INITIALIZED			:String		= 'EncoderEvent.INITIALIZED';

				/// The encoder has started the encoding or streaming process
				public static const CAPTURING			:String		= 'EncoderEvent.CAPTURING';

				/// The encoder has started processing the captured data
				public static const PROCESSING			:String		= 'EncoderEvent.PROCESSING';

				/// The encoder has finished processing any captured data
				public static const FINISHED			:String		= 'EncoderEvent.FINISHED';
				
				
			// data event constants
					
				/// The encoder has captured a frame
				public static const CAPTURED			:String		= 'EncoderEvent.CAPTURED';

				/// The encoder has processed a frame
				public static const PROCESSED			:String		= 'EncoderEvent.PROCESSED';

				/// The encoder has captured or processed a frame
				public static const UPDATE				:String		= 'EncoderEvent.UPDATE';

				/// There was an error
				public static const ERROR				:String		= 'EncoderEvent.ERROR';

				
			// properties
					
				public var data							:*;
				
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { instantiation
					
			public function EncoderEvent(type:String, data:* = null, bubbles:Boolean=false, cancelable:Boolean=false) 
			{
				this.data = data;
				super(type, bubbles, cancelable);
			} 
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { public methods
					
			public override function clone():Event 
			{ 
				return new EncoderEvent(type, bubbles, cancelable);
			} 
			
			public override function toString():String 
			{ 
				return formatToString("EncoderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
			}
			
	}
	
}