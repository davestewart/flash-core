package core.media.video.flashywrappers
{
	
	import com.rainbowcreatures.*;
	import com.rainbowcreatures.swf.*;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoEncoder extends EventDispatcher 
	{

		// --------------------------------------------------------------------------------------------------------
		// constants
		
			public static const PHASE_UNLOADED		:String		= 'VideoEncoder.UNLOADED';
			public static const PHASE_LOADED		:String		= 'VideoEncoder.LOADED';
			public static const PHASE_READY			:String		= 'VideoEncoder.READY';
			public static const PHASE_CAPTURING		:String		= 'VideoEncoder.CAPTURING';
			public static const PHASE_ENCODING		:String		= 'VideoEncoder.ENCODING';
			public static const PHASE_FINISHED		:String		= 'VideoEncoder.FINISHED';
		
			
		// --------------------------------------------------------------------------------------------------------
		// variables
		
			// statics
			protected static var _instance	:VideoEncoder;
		
			// protected properties
			protected var encoder			:FWVideoEncoder;
			
			// accessor properties
			protected var _target			:DisplayObject;
			protected var _fps				:int;
			protected var _format			:String;
			protected var _realtime			:Boolean;
			protected var _bitrate			:int;
			
			// accessor variables
			protected var _phase			:String				= PHASE_UNLOADED;
			protected var _frames			:int;
			protected var _bytes			:ByteArray;
			
			
		// --------------------------------------------------------------------------------------------------------
		// static instantiation
		
			public static function load(root:Sprite, onLoad:Function, path:String = ''):void
			{
				// function
				function onStatus(event:StatusEvent):void
				{
					if (event.code === 'ready')
					{
						// remove the temp loading listener
						encoder.removeEventListener(StatusEvent.STATUS, onStatus);
						
						// start the encoder for the first time, this gets the 500ms delay done and dusted
						encoder.start();
						
						// create a new VideoEncoder instance
						_instance = new klass(encoder, new Lock);
						
						// fire the callback and return the new VideoEncoder
						onLoad();
					}
				}

				// set a class reference to this class, as for some reason it can't be seen inside the closure
				var klass:Class = VideoEncoder;
				
				// load the actual encoder library
				var encoder:FWVideoEncoder = FWVideoEncoder.getInstance(root);
				encoder.addEventListener(StatusEvent.STATUS, onStatus);
				encoder.load(path);
			}
			
			static public function get instance():VideoEncoder { return _instance; }
			
			
		// --------------------------------------------------------------------------------------------------------
		// singleton constructor
		
			public function VideoEncoder($encoder:FWVideoEncoder, lock:Lock) 
			{
				// set up encoder
				encoder					= $encoder;
				encoder.addEventListener(StatusEvent.STATUS, onStatus);
				
				// default properties
				_fps					= 25;
				_format					= 'mp4';
				_bitrate				= 1000000;
				_realtime				= true;
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// public functions
		
			public function reset():void 
			{
				// throw an error if we've got no target
				if (_target == null)
				{
					throw new ReferenceError('A target Sprite must be specified before initializing');
				}
				
				// re-initialize encoder
				encoder.start(_fps, 'audioOff', _realtime, _target.width, _target.height, _bitrate);
				
				// phase
				_phase = PHASE_READY;
				
				// dispatch
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.READY));
			}
		
			/**
			 * Start recording
			 */
			public function start():void 
			{
				// reiniialize if needs be
				if (phase !== PHASE_READY)
				{
					trace('WARNING! Did not reset VideoEncoder. Resetting... (there may be a delay)');
					reset();
				}
				
				// reset
				_frames = 0;
				
				// start encoding
				onCapture(null);
				target.addEventListener(Event.ENTER_FRAME, onCapture);
			}
			
			/**
			 * Stop recording
			 */
			public function stop():void
			{
				// immediately start encoding
				_phase		= PHASE_ENCODING;
				target.removeEventListener(Event.ENTER_FRAME, onCapture);
				target.addEventListener(Event.ENTER_FRAME, onEncode);
				encoder.finish();
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// accessors
			
			public function get target():DisplayObject { return _target; }
			public function set target(value:DisplayObject):void 
			{
				_target = value;
				reset();
			}
			
			public function get fps():int { return _fps; }
			public function set fps(value:int):void 
			{
				_fps = value;
			}
			
			public function get bitrate():int { return _bitrate; }
			public function set bitrate(value:int):void 
			{
				_bitrate = value;
			}
			
			public function get realtime():Boolean { return _realtime; }
			public function set realtime(value:Boolean):void 
			{
				_realtime = value;
			}
			
			public function get format():String { return _format; }
			public function set format(value:String):void 
			{
				_format = value;
			}
						
			public function get frames():int { return _frames; }
			
			public function get phase():String { return _phase; }
			
			public function get bytes():ByteArray { return _bytes; }
			
			public function get encodingProgress():Number { return encoder.getEncodingProgress(); }
			
			
		// --------------------------------------------------------------------------------------------------------
		// protected functions
			
			protected function finish():void 
			{
				// ensure that a final ENCODING event is dispatched 
				onEncode(null);
				
				// update properties
				_phase	= PHASE_FINISHED;
				_bytes	= new ByteArray();
				_bytes.writeBytes(encoder.getVideo());
				
				// dispatch
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.FINISHED));
				target.removeEventListener(Event.ENTER_FRAME, onEncode);
			}

		// --------------------------------------------------------------------------------------------------------
		// handlers
		
			protected function onStatus(event:StatusEvent):void 
			{
				// debug
				// trace('status: ' + event.code);
				
				// code
				switch(event.code)
				{
					case 'ready':
						reset();
						break;
						
					case 'encoded':
						finish();
						break;
				}
			}
			
			protected function onCapture(event:Event):void 
			{
				_phase = PHASE_CAPTURING;
				encoder.capture(target);
				_frames++
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.CAPTURED));
			}
			
			protected function onEncode(event:Event):void 
			{
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.ENCODING));
			}
			
	}

}

class Lock
{
	
}

