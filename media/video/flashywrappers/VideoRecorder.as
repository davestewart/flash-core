package core.media.video.flashywrappers 
{
	import core.events.MediaEvent;
	import core.media.video.VideoRecorder;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoRecorder extends core.media.video.VideoRecorder 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var _encoder		:VideoEncoder;

				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoRecorder(width:int=320, height:int=180) 
			{
				super(width, height);
			}
			
			override protected function initialize():void 
			{
				// super
				super.initialize();
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function setup():void 
			{
				// camera etc
				super.setup();
				
				// encoder
				if (VideoEncoder.instance)
				{
					_encoder = VideoEncoder.instance;
					encoder.addEventListener(VideoEncoderEvent.READY, onEncoderEvent);
					encoder.addEventListener(VideoEncoderEvent.CAPTURED, onEncoderEvent);
					encoder.addEventListener(VideoEncoderEvent.ENCODING, onEncoderEvent);
					encoder.addEventListener(VideoEncoderEvent.FINISHED, onEncoderEvent);
					encoder.initialize(this)
				}
				else
				{
					throw new Error('Initialize the VideoEncoder class via VideoEncoder.load() before using this component!');
				}
			}
		
			public function getBytes():ByteArray
			{
				return encoder.bytes;
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get encoder():VideoEncoder { return _encoder; }
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function _record(append:Boolean = false):void
			{
				encoder.start();
			}
			
			override protected function _pause():void
			{
				
			}

			override protected function _resume():void 
			{
				
			}
			
			override protected function _stop():void
			{
				encoder.stop();
			}
			
			override protected function _onRecordComplete():void
			{
				dispatchEvent(new MediaEvent(MediaEvent.PROCESSED));
				dispatchEvent(new MediaEvent(MediaEvent.FINISHED));
				//dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, { code:'NetStream.Unpublish.Success' } ));
			}
		

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onEncoderEvent(event:VideoEncoderEvent):void 
			{
				// debug
				var type:String = event.type.replace('VideoEncoderEvent.', '').toLowerCase();
				
				// debug
				//trace('VideoRecorder: encoder event: ' + type);
				
				// special cases
				switch (event.type) 
				{
					case VideoEncoderEvent.READY:
						trace('Video encoder is ready');
						break;
						
					case VideoEncoderEvent.CAPTURED:
						onCapture();
						break;
						
					case VideoEncoderEvent.ENCODING:
						onEncode();
						break;
						
					case VideoEncoderEvent.FINISHED:
						_onRecordComplete();
						break;
						
					default:
				}
				
			}
			
			protected function onCapture():void 
			{
				dispatchEvent(new MediaEvent(MediaEvent.CAPTURED));
			}
			
			protected function onEncode():void 
			{
				dispatchEvent(new MediaEvent(MediaEvent.PROCESSING));
			}
			

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}