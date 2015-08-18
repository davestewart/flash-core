package core.media.video.flashywrappers 
{
	import core.events.MediaEvent;
	import core.media.video.VideoRecorder;
	import flash.display.Sprite;
	import flash.media.Video;
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
				protected var _container	:Sprite;
				protected var _output		:Video;

				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoRecorder(width:int = 320, height:int = 180)
			{
				super(width, height);
			}
			
			override protected function build():void 
			{
				// super
				super.build();
				
				// different video instance
				_container	= new Sprite();
				_output		= new Video();
				_container.addChild(_output);
				//addChild(_container);
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function start():Boolean 
			{
				if ( ! _encoder )
				{
					// encoder
					if (VideoEncoder.instance)
					{
						_encoder = VideoEncoder.instance;
						encoder.addEventListener(VideoEncoderEvent.READY, onEncoderEvent);
						encoder.addEventListener(VideoEncoderEvent.CAPTURED, onEncoderEvent);
						encoder.addEventListener(VideoEncoderEvent.ENCODING, onEncoderEvent);
						encoder.addEventListener(VideoEncoderEvent.FINISHED, onEncoderEvent);
						encoder.target = _container;
					}
					else
					{
						throw new Error('Initialize the VideoEncoder class via VideoEncoder.load() before using this component!');
					}
					
					// camera
					super.start();
					return true;
				}
				else
				{
					trace('FW VideoRecorder already started!');
					return false;
				}
			}
		
			public function reset():void
			{
				_encoder.reset();
			}
			
			override public function setOutputMode(width:Number, height:Number):void 
			{
				_output.width	= width;
				_output.height	= height;
				reset();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get encoder():VideoEncoder { return _encoder; }
			
			public function get bytes():ByteArray
			{
				return encoder.bytes;
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function _record(append:Boolean = false):void
			{
				encoder.start();
			}
			
			override protected function _stop():void
			{
				encoder.stop();
			}
			
			override protected function _onRecordComplete():void
			{
				dispatchEvent(new MediaEvent(MediaEvent.PROCESSED));
				dispatchEvent(new MediaEvent(MediaEvent.FINISHED));
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
						onReady();
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
			
			protected function onReady():void 
			{
				trace('Video encoder is ready');
				_output.attachCamera(webcam.camera);
				dispatchEvent(new MediaEvent(MediaEvent.READY));
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