package core.media.streams 
{
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import core.events.MediaEvent;
	import core.media.data.VideoMetadata;
	import core.net.NetStreamClient;
	import core.utils.defer;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoStream extends MediaStream
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// objects                             
				protected var _connection			:NetConnection;             
				protected var _stream				:NetStream;
				
			// video properties                    
				protected var _metadata				:VideoMetadata;
				protected var _bufferTime			:Number;
				
			// seek properties
				protected var _seekpoints			:Array;
				protected var _seekTime				:Number;			// flashplayer has a bug where stream.time is not accurate after a seek, so we cache the intended time
				protected var _onSeek				:Function;			// seeking is asynchronous, so we need a callback to fire once complete
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			/**
			 * VideoStream constructor
			 * 
			 * @param	target		An optional target object to dispatch events from. Defaults to the VideoStream instance
			 */
			public function VideoStream(target:IEventDispatcher = null)
			{
				super(target);
			}
			
			override protected function initialize():void 
			{
				// super
				super.initialize();
				
				// connection
				_connection = new NetConnection();
				_connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				//_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetStatus);
				_connection.connect(null);
				
				// variables
				_duration	= 0;
				_bufferTime	= 0;
			}
			
			/**
			 * Resets the stream, the media state and its properties
			 */
			override public function reset():void // renew:Boolean = false
			{
				// kill old stream
				if (_stream)
				{
					_stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					_stream.dispose();
				}
			
				// create new stream
				_stream					= new NetStream(_connection);
				_stream.client			= new NetStreamClient(onPlayStatus, onMetaData);
				_stream.bufferTime		= _bufferTime;
				//_stream.inBufferSeek	= true;
				_stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				
				// reset values
				_url					= '';
				_metadata				= null;
				_duration				= 0;
				
				// dispatch a ready event
				dispatch(MediaEvent.RESET);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Loads the steam from a URL and optionally plays it once loaded
			 * 
			 * @param	streamName
			 */
			override public function load(url:String, autoplay:Boolean = false):Boolean 
			{
				// super
				super.load(url, autoplay);
				
				// load the url
				_stream.addEventListener(NetStatusEvent.NET_STATUS, onLoadComplete, false, 100);
				_stream.play(url);
				
				// return
				return true;
			}
			
			/**
			 * Plays or resumes the stream, optionally from a particular time in seconds
			 * 
			 * @param	streamName
			 */
			override public function play(seconds:Number = -1):Boolean
			{
				if (_stream)
				{
					// play when loaded
					if ( ! _state.loaded )
					{
						_autoplay = true;
						return true;
					}
					
					// play if not playing
					if ( ! _state.playing )
					{
						// ended
						if (_state.ended && position > 0)
						{
							_seek(0, play);
							return true;
						}
						
						// seek
						if (seconds > -1)
						{							
							_seek(seconds, play);
							return true;
						}
						
						// play
						_stream.resume();
						
						// event
						_state.paused
							? dispatch(MediaEvent.RESUMED)
							: dispatch(MediaEvent.STARTED);
						
						// update state
						_state.playing	= true;
						
						// return
						return true;
					}
				}
				return false;
			}
			
			/**
			 * Replays the video from the first frame
			 * 
			 * @return
			 */
			public function replay():Boolean
			{
				if (_stream)
				{
					if (_state.loading)
					{
						_autoplay = true;
						return true;
					}
					_seek(0, play);
					return true;
				}
				return false;
			}

			/**
			 * Pauses the video at the current position
			 * 
			 * @return
			 */
			override public function pause():Boolean
			{
				if (_stream && _state.playing)
				{
					_stream.pause();
					_state.paused = true;
					return true;
				}
				return false;
			}
			
			/**
			 * Stops the video and returns it to the first frame
			 * 
			 * @return
			 */
			override public function stop():Boolean
			{
				if (_stream && ! _state.stopped)
				{
					_stream.pause();
					_seek(0, function():void {
						_state.stopped = true;
					});
					return true;
				}
				return false;
			}
			
			/**
			 * Rewinds the video
			 * 
			 * @return
			 */
			public function rewind():Boolean
			{
				if (_stream && position !== 0)
				{
					_rewind(function ():void 
					{
						_state.playing
							? _state.playing = true
							: _state.paused
								? _state.paused = true
								: null;
					});
					return true;
				}
				return false;
			}
			
			/**
			 * Closes the video stream
			 * 
			 * @return
			 */
			override public function close():Boolean 
			{
				if (_stream)
				{
					// update stream
					_stream.pause();
					_stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					_stream.dispose();
					
					// update state
					_state.stopped	= true;
					_stream			= null;
					_url			= null;
					dispatch(MediaEvent.CLOSED);
					
					// return
					return true;
				}
				return false;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			/// get the video's source stream object
			public function get stream():NetStream { return _stream; }
		
			/// set or get the position of the video stream
			override public function get position():Number { return isNaN(_seekTime) ? _stream.time : _seekTime; }
			override public function set position(seconds:Number):void
			{
				_seek(seconds);
			}
			
			/// get or set the buffertime of the stream
			public function get bufferTime():Number { return _bufferTime; }
			public function set bufferTime(value:Number):void 
			{
				_bufferTime = value;
			}
			
			/// gets the video's metadata, if loaded
			public function get metadata():VideoMetadata { return _metadata; }

			/// get the width of the video stream, if available via the stream's metadata
			public function get width():int { return _metadata ? _metadata.width : NaN; }
			
			/// get the height of the video stream, if available via the stream's metadata
			public function get height():int { return _metadata ? _metadata.height : NaN; }
			
			/// the video's keyframes
			public function get seekpoints():Array { return _seekpoints; }
						
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			/**
			 * Seeks to a time, and sets up a callback to fire once seeked
			 * 
			 * @param	seconds		The time in seconds to seek to
			 * @param	callback	An optional callback to fire once seeked
			 */
			protected function _seek(seconds:Number, callback:Function = null):void 
			{
				// properties
				_seekTime		= getSeekPoint(seconds);
				_onSeek			= callback;
				_state.seeking	= true;
				
				// code
				_stream.seek(_seekTime);
			}
			
			/**
			 * Rewinds to 0, and sets up a callback to fire once seeked
			 * 
			 * @param	callback	An optional callback to fire once seeked
			 */
			protected function _rewind(callback:Function = null):void 
			{
				_seek(0, function():void{
					dispatch(MediaEvent.REWIND);
					if (callback is Function)
					{
						callback();
					}
				});
			}
			
			/**
			 * Gets a valid seek point, or returns a capped value if no seekpoints
			 * 
			 * @param	seconds
			 */
			protected function getSeekPoint(seconds:Number):Number 
			{
				if (_seekpoints && _seekpoints.length)
				{
					for (var i:int = 0; i < _seekpoints.length; i++) 
					{
						if (_seekpoints[i] >= seconds)
						{
							return _seekpoints[i];
						}
					}
					return _seekpoints[_seekpoints.length - 1]
				}
				else
				{
					return seconds < 0
						? 0
						: seconds > _duration
							? _duration - 1
							: seconds;
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onLoadProgress(event:MediaEvent):void 
			{
				trace('loaded: ' + _stream.bytesLoaded, _stream.bytesTotal);
			}
		
			protected function onLoadComplete(event:NetStatusEvent):void 
			{
				if (event.info.code == 'NetStream.Play.Start')
				{
					_stream.removeEventListener(NetStatusEvent.NET_STATUS, onLoadComplete);
					_state.loaded = true;
					if(_autoplay)
					{
						play();
					}
					else
					{
						//_state.stopped = true;
						_stream.pause();
					}
				}
			}
			
			protected function onNetStatus(event:NetStatusEvent):void 
			{
				// debug
				//trace('>   netstream : ' + event.info.code);
				
				// forward all events (except errors)
				if (event.info.level !== 'error')
				{					
					dispatchEvent(event);
				}
				
				// action
				// @see http://help.adobe.com/en_US/as3/dev/WS901d38e593cd1bac-3d11a09612fffaf8447-8000.html
				switch(event.info.code)
				{
					// error events
						case 'NetStream.Play.StreamNotFound':
						case 'NetStream.Play.Failed':
							_stream = null;
							_url	= null;
							dispatch(MediaEvent.ERROR, event);
							break;
						
					// play events
						case 'NetStream.Play.Start':
							_state.ended = false;
							break;
						
						case 'NetStream.Play.Stop':
							//dispatch(MediaEvent.STOPPED);
							break;
						
						// this gets called when the stream has completed playing (the event is forwarded from the client)
						case 'NetStream.Play.Complete':
							
							// events
							_state.ended = true;
							
							// repeat
							if (_repeat)
							{
								dispatch(MediaEvent.REPEAT);
								_seek(0, function ():void 
								{
									_state.playing = true;
								});
							}
							
							// rewind
							else if (_autorewind)
							{
								_rewind(function():void {
									_stream.pause();
									_state.stopped = true;
									dispatch(MediaEvent.FINISHED);
								});
							}
							
							// end
							else
							{
								dispatch(MediaEvent.FINISHED);
							}
							break;
							
						case 'NetStream.Play.MetaData':
							dispatch(MediaEvent.METADATA, event.info);
							break;
							
						
					// seek events
						case 'NetStream.SeekStart.Notify':
							// the seek method handles
							break;
						
						// fired when a seek has finished
						case 'NetStream.Seek.Notify':
							
							// state
							_state.seeking = false;
							
							// event
							dispatch(MediaEvent.SEEKED);
							
							// fire any callbacks
							if (_onSeek is Function)
							{
								_onSeek();
								_onSeek = null;
							}
							else
							{
								dispatch(MediaEvent.UPDATED);
							}
							
							// defer reset of seekTime
							defer(function():void { _seekTime = NaN; } );
							
							break;
							
						case 'NetStream.Seek.Complete':
							break;
						
						case 'NetStream.Pause.Notify':
						case 'NetStream.Unpause.Notify':
							// events here moved to methods
							break;
						
					// buffer events
					// currently not handled
						case 'NetStream.Buffer.Full':
						case 'NetStream.Buffer.Flush':
						case 'NetStream.Buffer.Empty':

							break;
						
						default:
				}
			}
			
			/**
			 * Called by the NetStream client, playback only
			 * 
			 * @param	data
			 */
			protected function onPlayStatus(event:Object) :void
			{
				stream.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, event));
			}						
			
			/**
			 * Called by the NetStream client
			 * @param	data
			 */
			protected function onMetaData(data:Object) :void
			{
				if (_metadata == null)
				{
					// assign metadata
					_metadata	= new VideoMetadata(data);
					_duration	= _metadata.duration;
					
					// seekpoints
					var seekpoints:Array = data['seekpoints'] || data['seekPoints'];
					if (seekpoints)
					{
						_seekpoints = seekpoints.map(function(o:Object, i:int, a:Array):Number { 
							return o.time;
						} );
					}
				
					// reduce buffertime if longer than the video
					if (_bufferTime > _duration)
					{
						_bufferTime = _duration / 2;
					}
					
					// dispatch metadata event
					dispatch(MediaEvent.METADATA, data);
				}
			}
			
	}

}

