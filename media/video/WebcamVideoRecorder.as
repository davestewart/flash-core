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
				addEncoderListeners();
				_encoder.setup();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function record():void
			{
				_encoder.start();
			}
			
			public function stop():void
			{
				_encoder.stop();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get encoder():IEncoder { return _encoder; }
			public function set encoder(value:IEncoder):void 
			{
				if (_encoder)
				{
					removeEncoderListeners();
				}
				_encoder = value;
				addEncoderListeners();
			}
			
		
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
		
			protected function addEncoderListeners():void 
			{
				_encoder.addEventListener(EncoderEvent.READY, onEncoderEvent);
				_encoder.addEventListener(EncoderEvent.INITIALIZED, onEncoderEvent);
				_encoder.addEventListener(EncoderEvent.CAPTURING, onEncoderEvent);
				_encoder.addEventListener(EncoderEvent.CAPTURED, onEncoderEvent);
				_encoder.addEventListener(EncoderEvent.PROCESSING, onEncoderEvent);
				_encoder.addEventListener(EncoderEvent.PROCESSED, onEncoderEvent);
				_encoder.addEventListener(EncoderEvent.FINISHED, onEncoderEvent);
			}
		
			protected function removeEncoderListeners():void 
			{
				_encoder.removeEventListener(EncoderEvent.READY, onEncoderEvent);
				_encoder.removeEventListener(EncoderEvent.INITIALIZED, onEncoderEvent);
				_encoder.removeEventListener(EncoderEvent.CAPTURING, onEncoderEvent);
				_encoder.removeEventListener(EncoderEvent.CAPTURED, onEncoderEvent);
				_encoder.removeEventListener(EncoderEvent.PROCESSING, onEncoderEvent);
				_encoder.removeEventListener(EncoderEvent.PROCESSED, onEncoderEvent);
				_encoder.removeEventListener(EncoderEvent.FINISHED, onEncoderEvent);
			}
		
	}

}