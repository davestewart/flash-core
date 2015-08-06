package core.media.video.flashywrappers 
{
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
		
			public function VideoRecorder(width:int=320, height:int=180, setup:Boolean=true, connection:NetConnection=null) 
			{
				super(width, height, setup, connection);
			}
			
			override protected function initialize():void 
			{
				// super
				super.initialize();
				
				// encoder
				_encoder = new VideoEncoder(this, 12.5, 'mp4');
				encoder.addEventListener(VideoEncoderEvent.LOADING, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.LOADED, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.INITIALIZING, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.READY, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.CAPTURED, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.ENCODING, onEncoderEvent);
				encoder.addEventListener(VideoEncoderEvent.FINISHED, onEncoderEvent);
				
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function getBytes():ByteArray
			{
				return encoder.getVideo();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get encoder():VideoEncoder 
			{
				return _encoder;
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function _record(append:Boolean = false):void
			{
				encoder.start();
			}
			
			override protected function _pause():void
			{
				encoder.pause(); 
			}
			
			override protected function _stop():void
			{
				encoder.stop();
			}
			
			override protected function _onRecordComplete():void
			{
				dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, { code:'NetStream.Unpublish.Success' } ));
			}
		

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onEncoderEvent(event:VideoEncoderEvent):void 
			{
				// debug
				trace('event:', event.type);
				
				// special cases
				switch (event.type) 
				{
					case VideoEncoderEvent.READY:
						// ready - this should be set up when the app loads
						break;
						
					case VideoEncoderEvent.ENCODING:
						trace('encoding!');
						// encoder.getEncodingProgress();
						break;
						
					case VideoEncoderEvent.CAPTURED:
						trace('capturing!');
						//encoder.getCaptureProgress();
						break;
						
					case VideoEncoderEvent.FINISHED:
						_onRecordComplete();
						break;
						
					default:
				}
				
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}