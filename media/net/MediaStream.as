package core.media.net 
{
	import core.events.MediaEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	
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
													
			// play properties              		
				protected var _repeat				:Boolean;
				protected var _duration				:Number;
				protected var _position				:Number;
													
			// play state                   		
				protected var _playing				:Boolean;
				protected var _paused				:Boolean;
				protected var _ended				:Boolean;
						
			// variables		
				protected var timer					:Timer;
				
			
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
				// setup timer for progress events
				timer = new Timer(250);
				timer.addEventListener(TimerEvent.TIMER, onUpdate);
				
				// state
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
				play();
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
			
			/// a flag indicating whether to automatically repeat the playing of the media once it has reached the end
			public function get repeat():Boolean { return _repeat; }
			public function set repeat(value:Boolean):void { _repeat = value;
			}
			
			/// gets the duration of the media in seconds, if known. if not kown, returns -1
			public function get duration():Number { return _duration; }
			
			/// gets or sets the position of the media, in seconds. if the media is playing, it will seek and continue to play
			public function get position():Number { return -1 }
			public function set position(seconds:Number):void 
			{
				// override in subclass
			}
			
			/// indicates the media is currently playing
			public function get playing():Boolean { return _playing; }
			
			/// indicates the media is currently paused
			public function get paused():Boolean { return _paused; }
			
			/// indicates the media has played through to the end, but has not yet been rewound
			public function get stopped():Boolean { return ! (_playing || _paused); }
			
			/// indicates the media has played through to the end, but has not yet been rewound
			public function get ended():Boolean { return _ended; }
			
			/// returns the ended state of the media, that is, the media has played through to the end, but has not yet been rewound
			public function get active():Boolean { return _playing || _paused; }
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onUpdate(event:TimerEvent):void 
			{
				dispatch(MediaEvent.UPDATED);
			}
			
			protected function onLoadProgress(event:NetStatusEvent):void 
			{
				dispatch(MediaEvent.PROGRESS, event);
			}
		
			protected function onLoadError(event:NetStatusEvent):void 
			{
				dispatch(MediaEvent.ERROR, event);
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function dispatch(eventName:String, data:* = null):void 
			{
				//trace('>>> media     : ' + eventName);
				
				var event:MediaEvent = new MediaEvent(eventName, data);
				_target.dispatchEvent(event);
				
				_target.dispatchEvent(new MediaEvent(MediaEvent.EVENT, event));
			}
		
			protected function log(message:String, status:String = 'status'):void
			{
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, message, status));
			}
		
	}

}