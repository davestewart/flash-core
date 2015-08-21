package core.media.encoders 
{
	import core.events.MediaEvent;
	import core.interfaces.IVideoEncoder;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoEncoder extends EventDispatcher implements IVideoEncoder 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoEncoder() 
			{
				
			}
			
			/**
			 * Initializes the encoder
			 */
			protected function initialize():void 
			{
				
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Starts the encoding
			 * @return
			 */
			public function start():Boolean 
			{
				dispatch(MediaEvent.RECORDING);
			}
			
			/**
			 * Stops the encoding, and begins the processing stage
			 */
			public function stop():void 
			{
				process();
			}
			
			/**
			 * Resets the encoder to a ready state
			 */
			public function reset():void 
			{
				
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			/**
			 * Starts any processing on the encoded data
			 */
			protected function process():void 
			{
				dispatch(MediaEvent.PROCESSING);
			}
			
			/**
			 * Signals the encoding is complete
			 */
			protected function finish():void 
			{
				dispatch(MediaEvent.FINISHED);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function dispatch(type:String, data:* = null):void 
			{
				dispatchEvent(new MediaEvent(type, data));
			}
		
	}

}