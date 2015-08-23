package core.media.encoders.base 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.events.VideoEncoderEvent;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoEncoder extends EventDispatcher
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				public static const PHASE_NOT_READY		:String		= 'VideoEncoder.NOT_READY';
				public static const PHASE_READY			:String		= 'VideoEncoder.READY';
				public static const PHASE_INITIALIZING	:String		= 'VideoEncoder.INITIALIZING';
				public static const PHASE_INITIALIZED	:String		= 'VideoEncoder.INITIALIZED';
				public static const PHASE_CAPTURING		:String		= 'VideoEncoder.CAPTURING';
				public static const PHASE_PROCESSING	:String		= 'VideoEncoder.PROCESSING';
				public static const PHASE_FINISHED		:String		= 'VideoEncoder.FINISHED';
			
			// source properties
				protected var _source					:*;
				protected var _target					:*;
				
			// encoding properties
				protected var _phase					:String;
				protected var _frames					:int;
				
			// format properties
				protected var _format					:String;
				
			// objects
				protected var timer						:Timer;
				protected var allowedFormats			:Array;
				
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get source():* { return _source; }
			public function set source(value:*):void 
			{
				_source = value;
			}
			
			public function get target():* { return _target; }
			
			public function get phase():String { return _phase; }
				
			public function get frames():int { return _frames; }
			
			public function get format():String { return _format; }
			public function set format(value:String):void 
			{
				if (allowedFormats.lastIndexOf(value) > -1)
				{
					_format = value;
				}
				else
				{
					throw new Error('Invalid video format "' +value+ '"');
				}
			}
			
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoEncoder() 
			{
				// properties
				_phase			= PHASE_NOT_READY;
				allowedFormats	= ['mp4'];
				
				// timer for processing
				timer			= new Timer(250);
				timer.addEventListener(TimerEvent.TIMER, onProcess);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Sets up the process responsible for capturing video
			 *
			 * @return	Return true or false depending on whether the class has been set up yet
			 */
			public function setup():void 
			{
				// load any libraries or connect to server
				
				// optinally defer to onSetupComplete() to finalize
				setPhase(PHASE_READY);
			}
			
			/**
			 * Initializes the encoder (ensure that any required data has already been set up)
			 */
			public function initialize():void
			{
				// immediately set phase
				setPhase(PHASE_INITIALIZING);
				
				// initialize encoder or stream
				
				// optionally defer to onInitializeComplete() to finalize
				setPhase(PHASE_INITIALIZED);
			}
			
			/**
			 * Starts the capture process
			 * 
			 * @return	Return true if the recording started OK
			 */
			public function start():void 
			{
				// reset variables
				_frames		= 0;
				
				// set phase
				setPhase(PHASE_CAPTURING);
				
				// start capturing or streaming processes
				
				// subclasses may bind to whatever loop necessary and use onFrame() as the handler, which will in turn call capture()
			}
			
			/**
			 * Capture the next frame
			 */
			protected function capture():void 
			{
				// encode the frame if required
				
				// the calling onFrame event will take care of the UPDATE event
			}
			
			/**
			 * Stops the capture process, and begins processing
			 * 
			 * @return	Return true if the recording stopped OK
			 */
			public function stop():void 
			{
				// clean up any capturing or streaming processes
				
				// immediately set phase
				setPhase(PHASE_PROCESSING);
			
				// start the encoding or flushing process. use onProcess() as the handler
				
				// should call finish() when done
				finish();
			}
			
			/**
			 * Finish up after the encoding or publishing process has completed
			 */
			protected function finish():void 
			{
				// clean up after encoding or flushing
				
				// once done, set phase
				setPhase(PHASE_FINISHED);
			}

			/**
			 * Destroys the encoder instance
			 */
			public function destroy():void 
			{
				// kill timer
				timer.removeEventListener(TimerEvent.TIMER, onProcess);

				// remove listeners, set variables to null
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			/**
			 * Signals the encoder has been set up and is ready
			 */
			protected function onSetupComplete():void 
			{
				// optinally finalize after loading / connecting
				
				// once done, set phase
				setPhase(PHASE_READY);
			}
			
			/**
			 * Signals the encoder has been initialized and is ready to capture
			 */
			protected function onInitializeComplete():void 
			{
				// optinally finalize after initializing
				
				// once done, set phase
				setPhase(PHASE_INITIALIZED);
			}
		
			/**
			 * Signals the frames has been updated 
			 * @param	event
			 */
			protected function onFrame(event:Event):void 
			{
				capture();
				_frames++
				dispatch(VideoEncoderEvent.UPDATE, 'capturing');
			}
			
			/**
			 * Signals encoding or streaming has occurred
			 * 
			 * Fired every 0.25 seconds during processing
			 */
			protected function onProcess(event:TimerEvent):void 
			{
				// override in subclass; manage flushing or encoding
				
				// dispatch an update event
				dispatch(VideoEncoderEvent.UPDATE, 'processing');
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			/**
			 * Convenience method to set phase and dispatch an event in one line
			 * 
			 * @param	value
			 */
			protected function setPhase(value:String):void 
			{
				// set phase
				_phase = value;
				
				// dispatch event
				switch(value)
				{
					case PHASE_READY:
						dispatch(VideoEncoderEvent.READY);
						break;
					
					case PHASE_INITIALIZED:
						dispatch(VideoEncoderEvent.INITIALIZED);
						break;
					
					case PHASE_CAPTURING:
						dispatch(VideoEncoderEvent.CAPTURING);
						break;
					
					case PHASE_PROCESSING:
						dispatch(VideoEncoderEvent.PROCESSING);
						break;
					
					case PHASE_FINISHED:
						dispatch(VideoEncoderEvent.FINISHED);
						break;
					
					default:
						
				}
			}
			
			/**
			 * Convenience method to dispatches a VideoEncoderEvent
			 * 
			 * @param	type
			 * @param	data
			 */
			protected function dispatch(type:String, data:* = null):void 
			{
				dispatchEvent(new VideoEncoderEvent(type, data));
			}
			
			/**
			 * Logs messages to the output panel
			 * @param	value
			 */
			protected function log(value:*):void 
			{
				trace(this + ' -> ' + value);
			}
		
			/**
			 * Logs errors to the output panel
			 * @param	value
			 */
			protected function error(value:*):void 
			{
				//log( '<ERROR!>' + value);
				dispatch(VideoEncoderEvent.ERROR, value);
			}
		
			
	}

}