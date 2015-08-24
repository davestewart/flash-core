package core.media.video 
{
	import core.events.MediaEvent;
	import core.events.EncoderEvent;
	import core.interfaces.IEncoder;
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
				protected var _encoder:IEncoder;
				
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
				encoder.addEventListener(EncoderEvent.READY, onEncoderEvent);
				encoder.addEventListener(EncoderEvent.INITIALIZED, onEncoderEvent);
				encoder.addEventListener(EncoderEvent.CAPTURING, onEncoderEvent);
				encoder.addEventListener(EncoderEvent.CAPTURED, onEncoderEvent);
				encoder.addEventListener(EncoderEvent.PROCESSING, onEncoderEvent);
				encoder.addEventListener(EncoderEvent.PROCESSED, onEncoderEvent);
				encoder.addEventListener(EncoderEvent.FINISHED, onEncoderEvent);
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
		
			public function get encoder():IEncoder { return _encoder; }
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onEncoderEvent(event:EncoderEvent):void 
			{
				// forward event
				dispatchEvent(event);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}