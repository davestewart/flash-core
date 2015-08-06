package core.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class RecorderEvent extends Event 
	{
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// loading
			
				public static const INITIALIZING	:String	= 'RecorderEvent.INITIALIZING';		// Dispatched when the recorder has been instantiated and is setting up any encoders or streams etc
				public static const UNAVAILABLE		:String	= 'RecorderEvent.UNAVAILABLE';		// Dispatched when the recording is unavailable, perhaps due to a camera or connection difficulty
				public static const ERROR			:String	= 'RecorderEvent.ERROR';			// Dispatched if there is an error, perhaps with the encoding process
				public static const READY			:String	= 'RecorderEvent.READY';			// Dispatched when the recorder is ready
				
			// recording
			
				public static const RECORDING		:String	= 'RecorderEvent.RECORDING';		// Dispatched at the start of the recording process
				public static const PAUSED			:String	= 'RecorderEvent.PAUSED';			// Dispatched if the recording process is paused
				public static const STOPPED			:String	= 'RecorderEvent.STOPPED';			// Dispatched when the recording process has stopped (processing would usually start immediately afterwards)
				
			// processing
			
				public static const PROCESSING		:String	= 'RecorderEvent.PROCESSING';		// Dispatched when the recorded stream is processed, uploaded, etc
				public static const FINISHED		:String	= 'RecorderEvent.FINISHED';			// Dispatched when the processing or uploading is complete and the video is ready to play
			
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: methods
		
			public function RecorderEvent(type:String, message:String = '', bubbles:Boolean=false, cancelable:Boolean=false) 
			{ 
				super(type, bubbles, cancelable);
			} 
			
			public override function clone():Event 
			
			{ 
				return new RecorderEvent(type, bubbles, cancelable);
			} 
			
			public override function toString():String 
			{ 
				return formatToString("RecorderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
			}
		
	}
	
} 