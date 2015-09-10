package core.media.streams 
{
	import core.media.data.ID3;
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
				protected var _metadata			:ID3;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			/**
			 * AudioStream constructor
			 * 
			 * @param	target		An optional target object to dispatch events from. Defaults to the AudioStream instance
			 */
			public function AudioStream(target:IEventDispatcher = null)
			{
				super(target);
			}
			
			override public function reset():void 
			{
				// channel
				if (_channel)
				{
					stopChannel();
				}
				
				// remove any listeners
				if (_sound)
				{
					removeListeners();
				}
				
				// reset all variables
				_metadata	= null;
				_position	= 0;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function load(url:String, autoplay:Boolean = false):Boolean 
			{
				// super
				super.load(url, autoplay);
				
				// load new sound
				_sound			= new Sound(new URLRequest(url));
				_sound.addEventListener(Event.COMPLETE, onLoadComplete);
				_sound.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				_sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				_sound.addEventListener(Event.ID3, onMetadata);
				
				// return
				return true;
			}
			
			override public function play(seconds:Number = -1):Boolean
			{
				if (! _state.playing)
				{
					// get the position to start at
					seconds		= seconds > -1 
									? seconds 
									: _state.ended
										? 0
										: _position;
										
					// play the sound
					_play(seconds);
					
					// return
					return true;
				}
				return false;
			}
			
			override public function pause():Boolean
			{
				if (_channel && _state.playing)
				{
					_pause()
					_state.paused	= true;
					
					// return
					return true;
				}
				return false;
			}
			
			override public function resume():Boolean 
			{
				if (_channel && _state.paused)
				{
					_play(_position);
					return true;
				}
				return false;
			}
			
			override public function stop():Boolean 
			{
				if (_channel && _state.active)
				{
					_pause();
					_position		= 0;
					_state.stopped	= true;
					
					// return
					return true;
				}
				return false;
			}
			
			public function rewind():Boolean 
			{
				if(_channel && position !== 0)
				{
					dispatch(MediaEvent.REWIND);
					_state.playing
						? _state.playing = true
						: _state.paused
							? _state.paused = true
							: null;
					
					return true;
				}
				return false;
			}
			
			override public function close():Boolean 
			{
				if (_channel && position !== 0)
				{
					// properties
					stop();
					_sound.close();
					
					// return
					return true;
				}
				return false;
			}		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get sound():Sound { return _sound; }
				
			public function get channel():SoundChannel { return _channel; }
			
 			override public function get duration():Number { return _sound ? _sound.length / 1000 : 0; }
			
			override public function get position():Number 
			{
				return _state.playing 
					? _channel.position / 1000
					: _position;
			}
			override public function set position(value:Number):void
			{
				_state.seeking	= true;
				if (_state.playing)
				{
					_play(value);
				}
				else
				{
					_position = value;
					_state.paused = true;
				}
			}
			
			public function get progress():Number 
			{
				return _sound.length == 0 || _state.stopped
					? 0 
					: _channel 
						? _channel.position / _sound.length 
						: 0;
			}
			
			public function get volume():Number { return _channel.soundTransform.volume; }
			public function set volume(value:Number):void 
			{
				_channel.soundTransform.volume = value;
			}
			
			public function get metadata():ID3 { return _metadata	; }
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function _play(seconds:Number):void 
			{
				// stop any previous sound from playing
				stopChannel();
				
				// play new sound
				_channel = _sound.play(seconds * 1000);
				if (_channel)
				{
					// TODO investiate why play() sometimes returns null
					_channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
				}
				else
				{
					throw new Error('Cound not play sound');
				}
				
				// event
				_state.paused
					? dispatch(MediaEvent.RESUMED)
					: _state.playing
						? null
						: dispatch(MediaEvent.STARTED);
					
				// update state
				_state.playing = true;
			}
			
			protected function _pause():void 
			{
				_position = position; // uses the position getter to get the exact value, depending on whether a sound is loaded
				stopChannel();
			}
		
			protected function stopChannel():void 
			{
				if (_channel)
				{
					_channel.stop();
					_channel.removeEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
				}
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onLoadProgress(event:ProgressEvent):void
			{
				dispatch(MediaEvent.PROGRESS, event.bytesLoaded / event.bytesTotal);
			}
			
			protected function onLoadComplete(event:Event):void
			{
				// remove event listeners
				removeListeners();
				
				// update
				_state.loaded = true;
				_autoplay
					? play()
					: stopChannel();
			}
		
			override protected function onLoadError(event:Event):void
			{
				removeListeners();
				dispatch(MediaEvent.ERROR, event);
			}
		
			protected function onMetadata(event:Event):void 
			{
				if (_metadata == null)
				{
					_metadata = new ID3(Object(_sound.id3));
					dispatch(MediaEvent.METADATA);
				}
			}
			
			protected function onPlaybackComplete(event:Event):void 
			{
				// state
				_position		= _sound.length / 1000;
				_state.ended	= true;
					
				// repeat
				if (_repeat)
				{
					dispatch(MediaEvent.REPEAT);
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
		
			protected function removeListeners():void 
			{
				_sound.removeEventListener(Event.COMPLETE, onLoadComplete);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadProgress);
				_sound.removeEventListener(Event.ID3, onMetadata);
			}
		
	}

}