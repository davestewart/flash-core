package core.media.streams 
{
	import core.events.MediaEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Single class to manage all state variables for a stream
	 * 
	 * Also handles dispatching PROGRESS and UPDATE events
	 * 
	 * @author Dave Stewart
	 */
	public class StreamState extends EventDispatcher
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// loading states
				protected var _loading			:Boolean;
				protected var _loaded			:Boolean;
				
			// intermediate states
				protected var _buffering		:Boolean;
				protected var _seeking			:Boolean;
				
			// play states
				protected var _playing			:Boolean;
				protected var _paused			:Boolean;
				protected var _stopped			:Boolean;
				protected var _ended			:Boolean;
				
				protected var timer				:Timer;
			// timer
			
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function StreamState():void 
			{
				timer = new Timer(100);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: loading states
		
			// indicates the media is currently in a loading state
			public function get loading():Boolean { return _loading; }
			public function set loading(value:Boolean):void 
			{
				_loading = value;
				if (value)
				{
					_loaded		= false;
					_playing	= false;
					_paused		= false;
					_ended		= false;
					_stopped	= true;
					dispatch(MediaEvent.LOADING);
				}
			}
			
			// indicates the media is currently in a loading state
			public function get loaded():Boolean { return _loaded; }
			public function set loaded(value:Boolean):void 
			{
				_loaded	= value;
				if (value)
				{
					_loading	= false;
					dispatch(MediaEvent.LOADED);
				}
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: intermediate states
		
			// indicates the media is currently in a buffering state
			public function get buffering():Boolean { return _buffering; }
			public function set buffering(value:Boolean):void 
			{
				_buffering = value;
				value && dispatch(MediaEvent.BUFFERING);
			}
			
			/// indicates the media is currently seeking (the stream can be playing or paused whilst seeking)
			public function get seeking():Boolean { return _seeking; }
			public function set seeking(value:Boolean):void 
			{
				_seeking = value;
				value && dispatch(MediaEvent.SEEKING);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: play states
		
			/// indicates the media is currently playing
			public function get playing():Boolean { return _playing; }
			public function set playing(value:Boolean):void 
			{
				_playing = value;
				if (value)
				{
					_paused		= false;
					_stopped	= false;
					_ended		= false;
					_seeking	= false;
					dispatch(MediaEvent.PLAYING);
					startTimer();
				}
			}
			
			/// indicates the media is currently paused
			public function get paused():Boolean { return _paused; }
			public function set paused(value:Boolean):void 
			{
				_paused = value;
				if (value)
				{
					_playing	= false;
					_stopped	= false;
					_ended		= false;
					_seeking	= false;
					dispatch(MediaEvent.PAUSED);
					stopTimer();
				}
			}
			
			/// indicates the media has played through to the end, and is now paused
			public function get ended():Boolean { return _ended; }
			public function set ended(value:Boolean):void 
			{
				_ended = value;
				if (value)
				{
					_playing	= false;
					_paused		= false;
					_stopped	= false;
					_seeking	= false;
					dispatch(MediaEvent.ENDED);
					stopTimer();
				}
			}
			
			/// indicates the media has been stopped (and also rewound)
			public function get stopped():Boolean { return _stopped; }
			public function set stopped(value:Boolean):void 
			{
				_stopped = value;
				if (value)
				{
					_playing	= false;
					_paused		= false;
					_ended		= false;
					_seeking	= false;
					dispatch(MediaEvent.STOPPED);
					stopTimer();
				}
			}
		
			// indicates the media is either playing or paused
			public function get active():Boolean
			{
				return _playing || _paused;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function dispatch(state:String):void 
			{
				dispatchEvent(new MediaEvent(MediaEvent.STATE_CHANGE, state));
			}
			
			protected function startTimer():void 
			{
				timer.start();
				onTimer(null);
			}
			
			protected function stopTimer():void 
			{
				timer.stop();
				onTimer(null);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onTimer(event:TimerEvent):void 
			{
				if ( ! _seeking )
				{
					dispatchEvent(new MediaEvent(MediaEvent.UPDATED));
				}
			}
	
		
		
	}

}