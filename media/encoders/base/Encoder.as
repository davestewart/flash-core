package core.media.encoders.base 
{
	import core.interfaces.IEncoder;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.events.EncoderEvent;
	
	/**
	 * Base encoding class
	 * 
	 * Sets up encoding event lifecycle, with: 
	 * 
	 * 	- core properties
	 * 	- public api
	 * 	- internal api
	 * 	- event handlers
	 *  - utilities
	 * 
	 * @author Dave Stewart
	 */
	public class Encoder extends EventDispatcher implements IEncoder
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// lifecycle constants
				public static const PHASE_NOT_READY		:String		= 'Encoder.NOT_READY';
				public static const PHASE_READY			:String		= 'Encoder.READY';
				public static const PHASE_INITIALIZING	:String		= 'Encoder.INITIALIZING';
				public static const PHASE_INITIALIZED	:String		= 'Encoder.INITIALIZED';
				public static const PHASE_CAPTURING		:String		= 'Encoder.CAPTURING';
				public static const PHASE_PROCESSING	:String		= 'Encoder.PROCESSING';
				public static const PHASE_FINISHED		:String		= 'Encoder.FINISHED';
			
			// source properties
				protected var _input					:*;
				protected var _source					:*;
				
			// encoding properties
				protected var _phase					:String;
				protected var _length					:int;
				
			// objects
				protected var timer						:Timer;
				
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			/**
			 * the publicly-settable / gettable input of the encoder
			 */
			public function get input():* { return _input; }
			public function set input(value:*):void 
			{
				_input = value;
			}
			
			/**
			 * the final source to be encoded (it may be a only one component of the input)
			 */
			public function get source():* { return _source; }
			
			/**
			 * the current encoding phase
			 */
			public function get phase():String { return _phase; }
				
			/**
			 * the current length of captured data (this is an arbitrary unit; sublclasses should provide getters)
			 */
			public function get length():int { return _length; }
			
			/**
			 * The progress percentage (0.0 - 0.1) of encoding process
			 */
			public function get progress():Number { return 0; }
			
			/**
			 * The result of the encoding (this is untyped; sublclasses may provide typed getters)
			 */
			public function get output():* { return null; }
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Encoder() 
			{
				// properties
				_phase			= PHASE_NOT_READY;
				
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
				_length		= 0;
				
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
			protected function onCapture(event:Event):void 
			{
				// capture
				capture();
				
				// update frames
				_length++
				
				// dispatch events
				dispatch(EncoderEvent.CAPTURED, _length);
				dispatch(EncoderEvent.UPDATE, 'capturing');
			}
			
			/**
			 * Signals encoding or streaming has occurred
			 * 
			 * Fired every 0.25 seconds during processing
			 */
			protected function onProcess(event:TimerEvent):void 
			{
				// override in subclass; manage flushing or encoding
				
				// dispatch events
				dispatch(EncoderEvent.PROCESSED, progress);
				dispatch(EncoderEvent.UPDATE, 'processing');
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
						dispatch(EncoderEvent.READY);
						break;
					
					case PHASE_INITIALIZED:
						dispatch(EncoderEvent.INITIALIZED);
						break;
					
					case PHASE_CAPTURING:
						dispatch(EncoderEvent.CAPTURING);
						break;
					
					case PHASE_PROCESSING:
						dispatch(EncoderEvent.PROCESSING);
						break;
					
					case PHASE_FINISHED:
						dispatch(EncoderEvent.FINISHED);
						break;
					
					default:
						
				}
			}
			
			/**
			 * Convenience method to dispatches an EncoderEvent
			 * 
			 * @param	type
			 * @param	data
			 */
			protected function dispatch(type:String, data:* = null):void 
			{
				dispatchEvent(new EncoderEvent(type, data));
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
				dispatch(EncoderEvent.ERROR, value);
			}
		
			
	}

}