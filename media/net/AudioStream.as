package core.media.net 
{
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
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
	public class AudioStream extends MediaStream 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// properties
				protected var _sound			:Sound;
				protected var _channel			:SoundChannel;
						
						
			// variables		
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function AudioStream(target:IEventDispatcher=null) 
			{
				super(target);
			}
			
			override protected function initialize():void 
			{
			}
			
			override protected function reset():void 
			{
				// channel
				if (_channel)
				{
					stopChannel();
				}
				
				// remove any listeners
				if (_sound)
				{
					_sound.removeEventListener(Event.COMPLETE, onLoadComplete);
					_sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				}
				
				// reset all variables
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function load(url:String, autoplay:Boolean = true):Boolean 
			{
				// stop any previous sounds
				reset();
				
				// load new sound
				_sound		= new Sound(new URLRequest(url));
				_sound.addEventListener(Event.COMPLETE, onLoadComplete);
				_sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				
				// autoplay
				if (autoplay)
				{
					play();
				}
			}
			
			public function play(seconds:Number = 0):void
			{
				// stop any previous sound from playing
				stopChannel();
				
				// update state
				_playing		= true;
				_paused			= false;
				_ended			= false;
				
				// play the sound and add events
				_channel			= _sound.play(_position || seconds * 1000);
				if (_channel)
				{
					// TODO investiate why play() sometimes returns null
					_channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
					timer.start();
				}
				else
				{
					throw new Error('Cound not play sound');
				}
				
				if (_position == 0)
				{
					// TODO make sure this works, and matches VideoStream
					dispatch(MediaEvent.STARTED);
				}
			}
			
			public function pause():void
			{
				_position	= position; // uses the position getter to get the exact value, depending on whether a sound is loaded
				paused		= true;
				playing		= false;
				stopChannel();
			}
			
			public function resume():void 
			{
				play(_position || 0);
			}
			
			public function stop():void 
			{
				pause();
				_position	= 0;
				_playing	= false;
				_paused		= false;
			}
			
			public function close():void 
			{
				// properties
				_playing		= false;
				_paused			= false;
				_ended			= false;
				
				// stop everything
				stopChannel();
				_sound.close();
			}		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get sound():Sound { return _sound; }
				
			public function get channel():SoundChannel { return _channel; }
			
 			public function get length():Number { return _sound ? _sound.length / 1000 : 0; }
			
			public function get position():Number 
			{ 
				return length == 0 
					? 0 
					: _channel 
						? _channel.position 
						: 0;
			}
			public function set position(value:Number):void
			{
				playing
					? play(value / 1000)
					: _position = value;
				onTimer();
			}
			
			override public function get seconds():Number { return _channel.position / 1000; }
			override public function set seconds(value:Number):void
			{
				_playing
					? play(value)
					: _position = value * 1000;
				onTimer();
			}
			
			public function get progress():Number 
			{
				return _sound.length == 0 || ! (playing || paused)
					? 0 
					: _channel 
						? _channel.position / _sound.length 
						: 0;
			}
			
			public function get volume():Number { return _channel.soundTransform.volume; }
			public function set volume(value:Number):void 
			{
				_channel.soundTransform.volume = volume;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function stopChannel():void 
			{
				timer.stop();
				if (_channel)
				{
					_channel.stop();
					_channel.removeEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
				}
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onPlayheadUpdate(event:TimerEvent = null):void 
			{
				dispatch(MediaEvent.UPDATED);
			}
		
			protected function onLoadProgress(event:ProgressEvent):void
			{
				dispatch(MediaEvent.PROGRESS, event.bytesLoaded / event.bytesTotal);
			}
		 
			protected function onLoadComplete(event:Event):void
			{
				_sound.removeEventListener(Event.COMPLETE, onLoadComplete);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadProgress);
				dispatch(MediaEvent.LOADED);
			}
		
			protected function onLoadError(event:Event):void
			{
				_sound.removeEventListener(Event.COMPLETE, onLoadComplete);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadProgress);
				dispatch(MediaEvent.ERROR, event);
			}
		
			protected function onPlaybackComplete(event:Event):void 
			{
				// events
					dispatch(MediaEvent.COMPLETE);
					
				// state
					_position	= _sound.length / 1000;
					_playing	= false;
					_ended		= true;
					
				// repeat
				if (_repeat)
				{
					play(0);
				}
				else
				{
					stopChannel();
					dispatch(MediaEvent.FINISHED);
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}