package core.media.video 
{
	import core.events.MediaEvent;
	import core.events.VideoEncoderEvent;
	import core.interfaces.IVideoEncoder;
	import core.media.encoders.base.WebcamEncoder;
	import flash.errors.IllegalOperationError;

	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class WebcamVideoRecorder extends WebcamVideo 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var _encoder:IVideoEncoder;
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function WebcamVideoRecorder(width:int=320, height:int=180) 
			{
				super(width, height);
			}
			
			protected function initializeEncoder():void 
			{
				throw new IllegalOperationError('initialize encoder must be overridden in the subclass to instantiate a concrete VideoEncoder instance');
			}
			
			override protected function initialize():void 
			{
				// super
				initializeEncoder();
				
				// encoder
				encoder.setup();
				encoder.addEventListener(VideoEncoderEvent.READY, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.INITIALIZED, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.CAPTURING, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.CAPTURED, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.PROCESSING, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.PROCESSED, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.FINISHED, onEncoderEvent);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function record():void
			{
				encoder.start();
			}
			
			public function stop():void
			{
				encoder.stop();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get encoder():IVideoEncoder { return _encoder; }
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onEncoderEvent(event:VideoEncoderEvent):void 
			{
				// forward event
				dispatchEvent(event);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}