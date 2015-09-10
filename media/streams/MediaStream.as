package core.media.streams 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.events.MediaEvent;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class MediaStream extends EventDispatcher 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// objects
				protected var _target				:IEventDispatcher;             
				
			// stream variables
				protected var _url					:String;
				protected var _state				:StreamState;
				
			// play properties
				protected var _autoplay				:Boolean;
				protected var _autorewind			:Boolean;
				protected var _repeat				:Boolean;
				
			// position properties
				protected var _duration				:Number;
				protected var _position				:Number;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function MediaStream(target:IEventDispatcher = null) 
			{
				// target
				_target = target || this;
				
				// initialize
				initialize();
				reset();
			}
			
			protected function initialize():void 
			{
				// setup states
				_state = new StreamState();
				_state.addEventListener(MediaEvent.STATE_CHANGE, onStateChange);
				_state.addEventListener(MediaEvent.UPDATED, onUpdated);
				
				// properties
				_position	= 0;
			}
			
			public function reset():void 
			{
				// override in subclass
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Loads a media URL
			 * 
			 * @param	url			The URL of the media stream
			 * @param	autoplay	Whether to autoplay the media when loaded
			 */
			public function load(url:String, autoplay:Boolean = true):Boolean
			{
				// reset / setup
				reset();
				
				// properties
				_url			= url;
				_autoplay		= autoplay;
				
				// update state
				_state.loading	= true;
				
				// override in subclass
				return false;
			}
			
			/**
			 * Plays the media stream from the specified time (in seconds)
			 * 
			 * @param	seconds		The optional time to start playing the media stream from. If the value is not supplied, the media will play from its current position
			 */
			public function play(seconds:Number = NaN):Boolean
			{
				// override in subclass
				return false;
			}
			
			/**
			 * Pauses the media stream
			 */
			public function pause():Boolean
			{
				// override in subclass
				return false;
			}
			
			/**
			 * Resumes the media stream
			 */
			public function resume():Boolean
			{
				if (_state.paused)
				{
					play();
				}
				return false;
			}
			
			/**
			 * Stops and rewinds the media stream
			 */
			public function stop():Boolean 
			{
				// override in subclass
				return false;
			}
			
			/**
			 * Closes the media stream
			 */
			public function close():Boolean
			{
				// override in subclass
				return false;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			/// the url of the loaded media
			public function get url():String { return _url; }
			public function set url(value:String):void 
			{
				load(url);
			}
			
			// access to the stream state object
			public function get state():StreamState { return _state; }
						
			/// gets the duration of the media in seconds, if known. if not kown, returns -1
			public function get duration():Number { return _duration; }
			
			/// gets or sets the position of the media, in seconds. if the media is playing, it will seek and continue to play
			public function get position():Number { return -1 }
			public function set position(seconds:Number):void 
			{
				// override in subclass
			}
			
			/// a flag indicating whether to automatically repeat the playing of the media once it has reached the end
			public function get repeat():Boolean { return _repeat; }
			public function set repeat(value:Boolean):void { _repeat = value;
			}
			
			/// set the stream to automatically play when loaded
			public function get autoplay():Boolean { return _autoplay; }
			public function set autoplay(value:Boolean):void 
			{
				_autoplay = value;
			}
			
			/// set the stream to rewind automatically (and thus show the first frame) when the video has completed playing
			public function get autorewind():Boolean { return _autorewind; }
			public function set autorewind(value:Boolean):void 
			{
				_autorewind = value;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onStateChange(event:MediaEvent):void 
			{
				dispatch(MediaEvent.STATE_CHANGE, event.data);
				dispatch(event.data);
			}
			
			protected function onLoadError(event:Event):void 
			{
				dispatch(MediaEvent.ERROR, event);
			}
		
			protected function onUpdated(event:MediaEvent):void 
			{
				dispatch(event.type);
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function dispatch(eventName:String, data:* = null):void 
			{
				// create the event
				var event:MediaEvent = new MediaEvent(eventName, data);
				
				// dispatch the event
				_target.dispatchEvent(event);
				
				// dispatch the EVENT event
				_target.dispatchEvent(new MediaEvent(MediaEvent.EVENT, event));
			}
		
			protected function log(message:String, status:String = 'status'):void
			{
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, message, status));
			}
		
	}

}