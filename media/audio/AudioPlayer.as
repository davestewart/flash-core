package core.media.audio 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import core.events.MediaEvent;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class AudioPlayer extends EventDispatcher 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				public static const LOADING		:String	= 'AudioPlayer.LOADING';
				public static const LOADED		:String	= 'AudioPlayer.LOADED';
				public static const BUFFERING	:String	= 'AudioPlayer.BUFFERING';
				public static const PLAYING		:String	= 'AudioPlayer.PLAYING';
				public static const PAUSED		:String	= 'AudioPlayer.PAUSED';
				public static const STOPPED		:String	= 'AudioPlayer.STOPPED';				
				public static const CLOSED		:String	= 'AudioPlayer.CLOSED';				
			
			// properties
				protected var request			:URLRequest;
				protected var channel			:SoundChannel;
				protected var sound				:Sound;
				protected var timer				:Timer;
						
						
			// variables		
				protected var _repeat			:Boolean;
				protected var _position			:Number;
				protected var _state			:String;
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function AudioPlayer(url:String = null, autoplay:Boolean = true, tick:int = 100) 
			{
				// setup timer for progress events
					timer = new Timer(tick);
					timer.addEventListener(TimerEvent.TIMER, onTimer);
					
				// state
					_state = STOPPED;
					
				// load
					if (url)
					{
						load(url, autoplay);
					}
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function load(url:String, autoplay:Boolean = true):void 
			{
				// stop any previous sounds
					if (channel)
					{
						stopChannel();
					}
					
				// load new sound
					request 	= new URLRequest(url);
					sound		= new Sound(request);
					sound.addEventListener(Event.COMPLETE, onSoundLoaded);
					if (autoplay)
					{
						play();
					}
			}
			
			public function play(seconds:Number = 0):void
			{
				// stop any previous sond from playing
					if (channel)
					{
						stopChannel();
					}
					
				// update state
					_state		= PLAYING;
					
				// play the sound and add events
					channel		= sound.play(_position || seconds * 1000);
					channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
					timer.start();
			}
			
			public function pause():void
			{
				_position	= position;
				_state		= PAUSED;
				stopChannel();
			}
			
			public function resume():void 
			{
				play(_position || 0);
			}
			
			public function stop():void 
			{
				pause();
				_state		= STOPPED;
				position	= 0;
			}
			
			public function close():void 
			{
				_state
				stopChannel();
				sound.close();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			// time
			
				public function get length():Number { return sound.length / 1000; }
				
				public function get position():Number 
				{ 
					return length == 0 
						? 0 
						: channel 
							? channel.position 
							: 0;
				}
				public function set position(value:Number):void
				{
					state == PLAYING
						? play(value / 1000)
						: _position = value;
					onTimer();
				}
				
				public function get seconds():Number { return channel.position / 1000; }
				public function set seconds(value:Number):void
				{
					state == PLAYING
						? play(value)
						: _position = value * 1000;
					onTimer();
				}
				
				public function get progress():Number 
				{
					return sound.length == 0 || state == STOPPED
						? 0 
						: channel 
							? channel.position / sound.length 
							: 0;
				}
				
			// behaviour
			
				public function get state():String { return _state; }
				
				public function get paused():Boolean { return _state == PAUSED; }
				
				public function get volume():Number { return channel.soundTransform.volume; }
				public function set volume(value:Number):void 
				{
					channel.soundTransform.volume = volume;
				}
				
				public function get repeat():Boolean { return _repeat; }
				public function set repeat(value:Boolean):void 
				{
					_repeat = value;
				}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function stopChannel():void 
			{
				timer.stop();
				if (channel)
				{
					channel.stop();
					channel.removeEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
				}
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onSoundLoaded(event:Event):void
			{
				dispatchEvent(new MediaEvent(MediaEvent.LOADED));
			}
		
			protected function onTimer(event:TimerEvent = null):void 
			{
				dispatchEvent(new MediaEvent(MediaEvent.PROGRESS));
			}
		
			protected function onPlaybackComplete(event:Event):void 
			{
				// events
					dispatchEvent(new MediaEvent(MediaEvent.COMPLETE));
					
				// state
					_position	= 0;
					_state		= STOPPED;
					
				// repeat
					_repeat
						? play(0)
						: stopChannel();
				}
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}