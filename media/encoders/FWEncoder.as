package core.media.encoders 
{
	import com.rainbowcreatures.swf.FWVideoEncoder;
	import core.events.VideoEncoderEvent;
	import core.media.camera.Webcam;
	import core.media.encoders.base.WebcamEncoder;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class FWEncoder extends WebcamEncoder
	{
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// static
				protected static var  _encoder	:FWVideoEncoder
		
			// encoder properties
				protected var _settings			:Settings;
				protected var _realtime			:Boolean;
				protected var _bitrate			:int;
				
			// source properties
				protected var _clip				:DisplayObject;
				protected var _rect				:Rectangle;
				
			// region properties
				protected var _matrix			:Matrix;
				protected var _bitmap			:BitmapData;
				
				
		// --------------------------------------------------------------------------------------------------------
		// static instantiation
		
			public static function load(root:Sprite, onLoad:Function, path:String = ''):void
			{
				// function
				function onStatus(event:StatusEvent):void
				{
					if (event.code === 'ready')
					{
						encoder.removeEventListener(StatusEvent.STATUS, onStatus);
						_encoder = encoder;
						onLoad();
					}
				}

				// load the actual encoder library
				var encoder:FWVideoEncoder = FWVideoEncoder.getInstance(root);
				encoder.addEventListener(StatusEvent.STATUS, onStatus);
				encoder.load(path);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function FWEncoder() 
			{
				// super
				super();
				
				// chekc that encoder has loaded
				if ( ! _encoder )
				{
					throw new Error('The FWVideoEcoder has not loaded. Run FWEncoder.load() to load it');
				}
				
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Loads the SWF from disk
			 */
			override public function setup():void 
			{
				if (phase === PHASE_NOT_READY)
				{
					// bomb if encoder is not loaded
					if (! _encoder )
					{
						throw new Error('This class should be loaded via FWEncoder.load() before instantiating instances');
					}
					
					// properties
					allowedFormats	= ['mp4', 'ogg'];
					_format			= 'mp4';
					
					// default properties
					_format					= 'mp4';
					_realtime				= true;
					_bitrate				= 1000000;
					
					// set up listeners
					encoder.addEventListener(StatusEvent.STATUS, onEncoderStatus);

					// call setup straight away, as there's no setup to do (we're loading the plugin in advance)
					super.setup();
				}
			}
			
			/**
			 * Starts the encoder with the current properties
			 */
			override public function initialize():void 
			{
				// phase
				setPhase(PHASE_INITIALIZING);
				
				// set rect if it doesn't exist
				if ( ! _rect )
				{
					_rect = new Rectangle(0, 0, _target.width, _target.height);
				}
								
				// variables
				var width	:Number		= _rect.width;
				var height	:Number		= _rect.height;
				var fps		:int		= _target is Camera 
											? _camera.fps 
											: _clip.stage.frameRate;
				var audio	:String		= _microphone 
											? 'audio' 
											: 'audioOff';
				
				// start
				_encoder.start(fps, audio, _realtime, width, height);
			}
			
			/**
			 * Sets up the timer to capture frames 
			 */
			override public function start():void 
			{
				// reiniialize if needs be
				if (phase !== PHASE_INITIALIZED)
				{
					// function
					function onInitialize(event:VideoEncoderEvent):void
					{
						// remove listener
						removeEventListener(VideoEncoderEvent.INITIALIZED, onInitialize);
						
						// warn if there was a significant delay
						time = getTimer() - time;
						if (time > 200)
						{
							log('WARNING! Encoding was delayed by ' + time+ 'ms');
						}
						
						// start
						start();
					}
					
					// variables
					var time:int = getTimer();
					
					// warn
					log('WARNING! initialize() was not called before start()');

					// initialize
					addEventListener(VideoEncoderEvent.INITIALIZED, onInitialize);
					initialize();
					return;
				}
				
				// set up for capture
				if (_target is Camera)
				{
					_target.addEventListener(Event.VIDEO_FRAME, onFrame);
				}
				else
				{
					_target.addEventListener(Event.ENTER_FRAME, onFrame);
				}
				
				// phase
				super.start();
			}
			
			/**
			 * Captures a single frame
			 */
			override protected function capture():void 
			{
				// capture
				if (_target is Camera)
				{
					//trace('capturing camera');
					var frame:ByteArray = new ByteArray();
					_camera.copyToByteArray(_rect, frame);
					_encoder.addVideoFrame(frame);
				}
				else
				{
					if (_bitmap)
					{
						//trace('capturing bitmap');
						_bitmap.draw(_target, _matrix);
						_encoder.addVideoFrame(_bitmap.getPixels(new Rectangle(0, 0, _bitmap.width, _bitmap.height)));
					}
					else
					{
						//trace('capturing display object');
						_encoder.capture(_target);
					}
				}
			}

			/**
			 * stops capturing of the source, and finishes encoding the data
			 */
			override public function stop():void 
			{
				// remove all event listeners
				if (_target is Camera)
				{
					_target.removeEventListener(Event.VIDEO_FRAME, onFrame);
				}
				else
				{
					_target.removeEventListener(Event.ENTER_FRAME, onFrame);
				}
				
				// set phase
				setPhase(PHASE_PROCESSING);

				// finish encoding and monitor 
				encoder.finish();
				timer.start();
			}
			
			/**
			 * Cleans up after encoding is finished
			 */
			override protected function finish():void 
			{
				timer.stop();
				setPhase(PHASE_FINISHED);
			}
		
			/**
			 * Destroys the encoder instance
			 */
			override public function destroy():void 
			{
				super.destroy();
				encoder.removeEventListener(StatusEvent.STATUS, onEncoderStatus);
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			/**
			 * Assigns the source object
			 * 
			 * @param	source	A Camera, Webcam or DisplayObject
			 */
			override public function set source(value:*):void 
			{
				if ( (value is Camera) || (value is Webcam) )
				{
					super.source = value;
				}
				else if(value is DisplayObject)
				{
					_clip		= value;
					_target		= value;
				}
				else
				{
					throw new TypeError('The assigned source must be a DisplayObject, flash.media.Camera or core.media.camera.WebCam');
				}
			}
			
			/**
			 * Gets or sets the rectangle used when capturing Camera frames
			 * 
			 * @bug Note that there seems to be a bug in Adobe's code to grab the correct rectangle
			 * @see http://stackoverflow.com/questions/32142566/cannot-seem-to-copy-a-rectangle-more-than-0-in-y-using-camera-copytobytearray
			 */
			public function get rect():Rectangle { return _rect; }
			public function set rect(value:Rectangle):void 
			{
				_rect = value;
				if (_rect == null)
				{
					_bitmap	= null;
					_matrix = null;
				}
				else
				{
					_bitmap	= new BitmapData(value.width, value.height);
					_matrix	= new Matrix(1, 0, 0, 1, -rect.x, -rect.y);
				}
			}
			
			public function get realtime():Boolean { return _realtime; }
			public function set realtime(value:Boolean):void 
			{
				_realtime = value;
			}
			
			public function get bitrate():int { return _bitrate; }
			public function set bitrate(value:int):void 
			{
				_bitrate = value;
			}
			
			/**
			 * Returns the encoded video's bytes
			 */
			public function get bytes():ByteArray { return _encoder.getVideo(); }
			
			/**
			 * Get the encoding process
			 */
			public function get progress():Number { return encoder.getEncodingProgress();  }
			
			/**
			 * Get the actual FW encoder
			 */
			public function get encoder():FWVideoEncoder { return _encoder; }
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onEncoderStatus(event:StatusEvent):void 
			{
				// debug
				// trace('status: ' + event.code);
				
				// code
				switch(event.code)
				{
					case 'started':
						onInitializeComplete();
						break;
						
					case 'encoded':
						finish();
						break;
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}

class Settings
{
	public var fps					:int			 = 25;
	public var realtime				:Boolean		 = true;
	public var recordAudio			:String			 = "audioOff";
	public var bitrate				:int			 = 1000000;
	public var audio_sample_rate	:int			 = 44100;
	public var audio_bit_rate		:int			 = 64000;
	public var keyframe_freq		:Number			 = 0;

	public function Settings():void 
	{

	}
}


