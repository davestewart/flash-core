package core.media.net 
{
	import core.media.data.VideoMetadata;
	import core.net.NetStreamClient;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import core.events.MediaEvent;

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
				                                   
			// play properties                     
				protected var _autorewind			:Boolean;
			
			// video properties                    
				protected var _bufferTime			:Number;
				protected var _metadata				:VideoMetadata;

			// variables                           
				                                   
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
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
				_duration	= -1;
				_bufferTime	= 2;
			}
		
			override public function reset():void // renew:Boolean = false
			{
				// kill old stream
				if (_stream)
				{
					_stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					_stream.dispose();
				}
			
				// create new stream
				_stream				= new NetStream(_connection);
				_stream.client		= new NetStreamClient(onPlayStatus, onMetaData);
				_stream.bufferTime	= _bufferTime;
				_stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				
				// reset values
				_url				= '';
				_metadata			= null;
				_duration			= 0;
				
				// dispatch a ready event
				dispatch(MediaEvent.RESET);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Load the steam and pause it immediately upon loading
			 * 
			 * @param	streamName
			 */
			override public function load(url:String, autoplay:Boolean = false):Boolean 
			{
				// don't load the same stream twice
				if (url === _url)
				{
					// but if autoplay is set, and it's already loaded, play it
					if (autoplay)
					{
						return play();
					}
					return false;
				}
				
				// setup
				reset();
				
				// callback
				function onLoad(event:NetStatusEvent):void 
				{
					if (event.info.code == 'NetStream.Play.Start')
					{
						event.stopImmediatePropagation();
						_stream.removeEventListener(NetStatusEvent.NET_STATUS, onLoad);
						dispatch(MediaEvent.LOADED)
						if( ! autoplay )
						{
							_stream.pause();
						}
						else
						{
							play();
						}
					}
				}
				
				// set name
				_url = url;
				
				// bind to the initial playback event
				_stream.addEventListener(NetStatusEvent.NET_STATUS, onLoad, false, 100);
				
				// play the url
				dispatch(MediaEvent.OPENED);
				_stream.play(url);
				
				// return
				return true;
			}
			
			/**
			 * Play the stream
			 * 
			 * @param	streamName
			 */
			override public function play(seconds:Number = NaN):Boolean
			{
				if (_stream)
				{
					if ( ! _playing )
					{
						// ended
						if (_ended)
						{
							seconds = 0;
						}
						
						// seek
						if ( ! isNaN(seconds) )
						{							
							_stream.seek(seconds);
						}
						
						// stopped (at beginning)
						if (stopped)
						{
							dispatch(MediaEvent.STARTED); // PLAYING will also fire, but driven by the NetStream. Or will it?
						}
						
						// paused (anywhere)
						else
						{
							dispatch(MediaEvent.RESUMED);
						}
						
						// play
						_stream.resume();
						
						// reset flags
						_playing	= true;
						_paused		= false;
						_ended		= false;
						
						// event
						dispatch(MediaEvent.PLAYING);
						dispatch(MediaEvent.UPDATED);
						timer.start();
						return true;
					}
				}
				return false;
			}
			
			public function replay():Boolean
			{
				if (_stream)
				{
					_rewind();
					// TODO do we need to add a listener here in case there is a delay after seeking?
					return play();
				}
				return false;
			}

			override public function pause():Boolean
			{
				if (_stream && (! _paused) && ( ! _ended) )
				{
					_paused		= true;
					_playing	= false;
					_pause();
					dispatch(MediaEvent.PAUSED);
					return true;
				}
				return false;
			}
			
			override public function stop():Boolean
			{
				if (_stream && active)
				{
					_paused		= false;
					_playing	= false;
					_rewind();
					_pause();
					dispatch(MediaEvent.STOPPED);
					return true;
				}
				return false;
			}
			
			public function rewind():Boolean
			{
				if (_stream)
				{
					_rewind();
					dispatch(MediaEvent.REWIND);
					return true;
				}
				return false;
			}
			
			override public function close():Boolean 
			{
				if (_stream)
				{
					stop();
					_stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					_stream.dispose();
					_stream		= null;
					_url		= null;
					dispatch(MediaEvent.CLOSED);
					return true;
				}
				return false;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			/// get the video's source stream object
			public function get stream():NetStream { return _stream; }
		
			/// set or get the position of the video stream
			override public function get position():Number { return _stream.time; }
			override public function set position(seconds:Number):void
			{ 
				playing
					? play(seconds)
					: _stream.seek(seconds);
			}
			
			/// set the video to rewind automatically (and thus show the first frame) when the video has completed playing
			public function get autorewind():Boolean { return _autorewind; }
			public function set autorewind(value:Boolean):void 
			{
				_autorewind = value;
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
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function _rewind():void 
			{
				if (_stream)
				{
					_ended = false;
					_stream.seek(0);
					dispatch(MediaEvent.UPDATED);
				}
			}
		
			protected function _pause():void 
			{
				if (_stream)
				{
					_stream.pause();
					dispatch(MediaEvent.UPDATED);
					timer.stop();
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
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
							dispatch(MediaEvent.ERROR, event);
							break;
						
					// play events
						case 'NetStream.Play.Start':
							_ended = false;
							break;
						
						case 'NetStream.Play.Stop':
							//dispatch(MediaEvent.STOPPED);
							break;
						
						// this gets called when the stream has completed playing (the event is forwarded from the client)
						case 'NetStream.Play.Complete':
							
							// events
							dispatch(MediaEvent.COMPLETE);
							
							// repeat, rewind or pause
							if (_repeat)
							{
								_stream.seek(0);
								dispatch(MediaEvent.REPEAT);
							}
							else if (_autorewind)
							{
								rewind();
								stop();
								dispatch(MediaEvent.FINISHED);
							}
							else
							{
								_ended		= true;
								_playing	= false;
								_paused		= false;
								_pause();
								dispatch(MediaEvent.STOPPED);
								dispatch(MediaEvent.FINISHED);
							}
							break;
							
						case 'NetStream.Play.MetaData':
							dispatch(MediaEvent.METADATA, event.info);
							break;
							
						
					// seek events
						case 'NetStream.SeekStart.Notify':
							// nothing to do here
							break;
						
						case 'NetStream.Seek.Notify':
						case 'NetStream.Seek.Complete':
							// need to fire next events here
							// stopped
							// repeat
							// rewound
							if (_onSeek !== null)
							{
								_onSeek();
								_onSeek = null;
							}
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
				// TODO use new metadata class
				if ( ! _metadata )
				{
					// assign metadata
					_metadata	= new VideoMetadata(data);
					_duration	= Number(data.duration);
					
					// dispatch metadata event
					dispatch(MediaEvent.METADATA, data);
				}
			}
			
	}

}

