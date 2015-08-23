package core.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoEncoderEvent extends Event 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// phase event constants
					
				/// The encoder has not yet loaded or connected
				public static const NOT_READY			:String		= 'VideoEncoderEvent.NOT_READY';

				/// The encoder has finished setup, and is ready to be initialized
				public static const READY				:String		= 'VideoEncoderEvent.READY';

				/// The encoder has been initializedand is ready to record
				public static const INITIALIZED			:String		= 'VideoEncoderEvent.INITIALIZED';

				/// The encoder has started the encoding or streaming process
				public static const CAPTURING			:String		= 'VideoEncoderEvent.CAPTURING';

				/// The encoder has started processing the captured data
				public static const PROCESSING			:String		= 'VideoEncoderEvent.PROCESSING';

				/// The encoder has finished processing any captured data
				public static const FINISHED			:String		= 'VideoEncoderEvent.FINISHED';
				
				
			// data event constants
					
				/// The encoder has captured or processed a frame
				public static const UPDATE				:String		= 'VideoEncoderEvent.UPDATE';

				/// There was an error
				public static const ERROR				:String		= 'VideoEncoderEvent.ERROR';

				
			// properties
					
				public var data							:*;
				
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { instantiation
					
			public function VideoEncoderEvent(type:String, data:* = null, bubbles:Boolean=false, cancelable:Boolean=false) 
			{
				this.data = data;
				super(type, bubbles, cancelable);
			} 
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { public methods
					
			public override function clone():Event 
			{ 
				return new VideoEncoderEvent(type, bubbles, cancelable);
			} 
			
			public override function toString():String 
			{ 
				return formatToString("VideoEncoderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
			}
			
	}
	
}