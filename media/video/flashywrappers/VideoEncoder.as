package core.media.video.flashywrappers
{
	
	import com.rainbowcreatures.*;
	import com.rainbowcreatures.swf.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * Wrapper for the FlashyWrappers video encoder
	 * 
	 * @requires	 The FlashyWrappers swc
	 * 
	 * @author Dave Stewart
	 */
	public class VideoEncoder extends EventDispatcher 
	{

		// --------------------------------------------------------------------------------------------------------
		// constants
		
			public static const PHASE_UNLOADED		:String		= 'VideoEncoder.UNLOADED';
			public static const PHASE_LOADED		:String		= 'VideoEncoder.LOADED';
			public static const PHASE_INITIALIZING	:String		= 'VideoEncoder.INITIALIZING';
			public static const PHASE_READY			:String		= 'VideoEncoder.READY';			// note that this is different from the core FW status event! in this case, ready means "ready" not "loaded"
			public static const PHASE_CAPTURING		:String		= 'VideoEncoder.CAPTURING';
			public static const PHASE_ENCODING		:String		= 'VideoEncoder.ENCODING';
			public static const PHASE_FINISHED		:String		= 'VideoEncoder.FINISHED';
		
			
		// --------------------------------------------------------------------------------------------------------
		// variables
		
			// objects
			protected var target			:Sprite;
			protected var encoder			:FWVideoEncoder; 
			protected var data				:ByteArray;
			
			// properties 
			protected var _fps				:int;
			protected var _bitrate			:int;
			protected var _realtime			:Boolean;
			protected var _format			:String;
			
			// variables
			protected var _frames			:int;
			protected var _phase			:String				= PHASE_UNLOADED;
			protected var _timeStart		:Number;

			
		// --------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function VideoEncoder(target:Sprite, fps:int = 25, format:String = 'mp4') 
			{
				// properties
				this.target				= new Sprite();
				
				// encoder properties
				_format					= format;
				_fps					= fps;
				_bitrate				= 1000000;
				_realtime				= false;
				
				// set up encoder
				encoder					= FWVideoEncoder.getInstance(target);
				encoder.addEventListener(StatusEvent.STATUS, onStatus);
				
				// these don't seem to work currently
				//encoder.setDimensions(target.width, target.height);
				//encoder.setFps(25);
				//encoder.setTotalFrames(totalFrames);
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// public functions
		
			public function load(path:String = ''):void
			{
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.LOADING));
				encoder.load(); // custom paths don't seem to load properly
			}
		
			public function initialize():void
			{
				_phase = PHASE_INITIALIZING;
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.INITIALIZING));
				encoder.start(fps, 'audioOff', true, target.width, target.height, bitrate);
				
				// HACK until proper event is dispatched from the encoder
				setTimeout(function():void {
					encoder.dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, 'initialized'));
					}, 500);
			}
		
			public function start():void 
			{
				if (_phase !== PHASE_CAPTURING)
				{					
					_frames	= 0;
					_phase	= PHASE_CAPTURING;
					resume();
				}
				else
				{
					trace('already capturing!');
				}
			}
			
			public function pause():void
			{
				target.removeEventListener(Event.ENTER_FRAME, onCapture);
			}
			
			public function resume():void
			{
				if (_phase === PHASE_CAPTURING)
				{
					target.addEventListener(Event.ENTER_FRAME, onCapture);
				}
			}
			
			public function stop():void
			{
				if (_phase === PHASE_CAPTURING)
				{
					_timeStart	= getTimer();
					pause();
					_phase		= PHASE_ENCODING;
					encoder.finish();
					target.addEventListener(Event.ENTER_FRAME, onEncode);
				}
			}
			
			public function getVideo():ByteArray
			{
				return encoder.getVideo();
			}
			
			public function getEncodingProgress():Number 
			{
				return encoder.getEncodingProgress();
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// accessors
			
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
			
			public function get duration():Number { return (getTimer() - _timeStart) / 1000; }
			
			
		// --------------------------------------------------------------------------------------------------------
		// handlers
		
			protected function onStatus(event:StatusEvent):void 
			{
				// debug
				trace('status: ' + event.code);
				
				// code
				switch(event.code)
				{
					case 'ready':
						_phase = PHASE_LOADED;
						dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.LOADED));
						initialize();
						break;
						
					// need the encoder to dispatch a status event, so we know it's ready!
					case 'initialized':
						_phase = PHASE_READY;
						dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.READY));
						break;
						
					case 'encoded':
						_phase = PHASE_FINISHED;
						dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.FINISHED));
						target.removeEventListener(Event.ENTER_FRAME, onEncode);
						break;
				}
			}
			
			protected function onCapture(event:Event):void 
			{
				_frames++;
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.CAPTURED));
			}
			
			protected function onEncode(event:Event):void 
			{
				dispatchEvent(new VideoEncoderEvent(VideoEncoderEvent.ENCODING));
			}
			
			
	}

}