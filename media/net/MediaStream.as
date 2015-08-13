package core.media.net 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
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
				protected var _target					:IEventDispatcher;             
				protected var _connection				:NetConnection;             
				protected var _stream					:NetStream;
				
			// stream variables
				protected var _url						:String;
				protected var _bufferTime				:Number;
				protected var _metaData					:Object;
				protected var _videoWidth				:int;
				protected var _videoHeight				:int;
				protected var _duration					:int;
				
			// play properties
				protected var _repeat					:Boolean;
				protected var _autorewind				:Boolean;
				
			// play state
				protected var _active					:Boolean;
				protected var _playing					:Boolean;
				protected var _paused					:Boolean;
				protected var _ended					:Boolean;
				
			// info
				protected var _status					:String;
				protected var _alwaysRenew				:Boolean;
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function MediaStream(target:IEventDispatcher = null, connection:NetConnection = null) 
			{
				// super
					_target = target || this;
				
				// connect
					if (connection is NetConnection)
					{
						_connection = connection;
					}
					else
					{
						_connection = new NetConnection();
						_connection.connect(null);
					};
					
				// initialize
					initialize();
					reset();
			}
			
			protected function initialize():void 
			{
				_duration	= -1;
				_bufferTime	= 2;
			}
		
			public function reset(renew:Boolean = false):void 
			{
				// sometimes we want to create a new NetStream object (note that any attached videos or mics will need to be reattached!)
					if (_alwaysRenew || renew)
					{
						if (stream)
						{
							stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
							stream.dispose();
							_stream = null;
						}
					}
				
				// create a new stream if one doesn't exist
					if ( ! stream )
					{
						_stream = new NetStream(_connection);
						stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
						stream.client		= this;
					}
					
				// kill old values
					_url				= '';
					_metaData			= null;
					_duration			= 0;
					_videoWidth			= 0;
					_videoHeight		= 0;
					
				// stream properties
					stream.bufferTime	= _bufferTime;
					
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
			public function load(url:String, autoplay:Boolean = false):Boolean 
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
					
				// set name
					_url = url;
					
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
					
				// bind to the initial playback event
					_stream.addEventListener(NetStatusEvent.NET_STATUS, onLoad, false, 100);
					
				// play the url
					_stream.play(url);
					
				// return
					return true;
			}
		
			/**
			 * Load and play the stream immediately
			 * 
			 * @param	streamName
			 */
			public function play():Boolean
			{
				if (_stream)
				{
					if ( ! _playing )
					{
						if (_ended)
						{
							_rewind();
						}
						
						// flags
						_active		= true;
						_playing	= true;
						_paused		= false;
						
						// media events. should these be fired only when the first netstream event fires?
						if (_stream.time == 0 || _ended)
						{
							_ended = false;
							dispatch(MediaEvent.STARTED) // PLAYING will also fire, but driven by the NetStream.
						}
						else
						{
							dispatch(MediaEvent.RESUMED);
						}
						
						// instrcu stream to play
						_stream.resume();
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
					return play();
				}
				return false;
			}

			public function pause():Boolean
			{
				if (_stream && (! _paused) && ( ! _ended) )
				{
					_paused		= true;
					_playing	= false;
					_stream.pause();
					dispatch(MediaEvent.PAUSED);
					return true;
				}
				return false;
			}
			
			public function stop():Boolean
			{
				if (_stream && _active)
				{
					_active		= false;
					_paused		= false;
					_playing	= false;
					_rewind();
					_stream.pause();
					dispatch(MediaEvent.STOPPED);
					return true;
				}
				return false;
			}
			
			public function rewind():Boolean
			{
				if (_stream)
				{
					_rewind()
					dispatch(MediaEvent.REWIND);
					return true;
				}
				return false;
			}
			
			public function close():Boolean 
			{
				// properties
				_playing		= false;
				_paused			= false;
				_active			= false;
				_ended			= false;
				
				// stream
				if (_stream)
				{
					_stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					if (_connection)
					{
						_stream.dispose();
					}
					_stream			= null;
					_url		= null;
					dispatch(MediaEvent.CLOSED);
					return true;
				}
				return false;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get stream():NetStream { return _stream; }
		
			public function get url():String { return _url; }
			public function set url(value:String):void 
			{
				load(url);
			}
			
			public function get repeat():Boolean { return _repeat; }
			public function set repeat(value:Boolean):void 
			{
				_repeat = value;
			}
			
			public function get autorewind():Boolean { return _autorewind; }
			public function set autorewind(value:Boolean):void 
			{
				_autorewind = value;
			}
			
			public function get bufferTime():Number { return _bufferTime; }
			public function set bufferTime(value:Number):void 
			{
				_bufferTime = value;
			}
			
			public function get metadata():Object { return _metaData; }
			
			public function get videoWidth():int { return _videoWidth; }
			public function get videoHeight():int { return _videoHeight; }
			
			public function get duration():int{ return _duration; }
			
			public function get active():Boolean { return _active; }
			
			public function get playing():Boolean { return _playing; }
			
			public function get paused():Boolean { return _paused; }
			
			public function get ended():Boolean { return _ended; }
			
			public function get status():String { return _status; }
			
					
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function _rewind():void 
			{
				if (_stream)
				{
					_ended = false;
					_stream.seek(0);
				}
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onNetStatus(event:NetStatusEvent):void 
			{
				// forward event
					dispatchEvent(event);
					
				// debug
					//trace('>   netstream : ' + event.info.code);
					
				// status
					_status = event.info.description;
					
				// action
					// @see http://help.adobe.com/en_US/as3/dev/WS901d38e593cd1bac-3d11a09612fffaf8447-8000.html
					switch(event.info.code)
					{
						// error events
							case 'NetStream.Play.StreamNotFound':
							case 'NetStream.Play.Failed':
								dispatch(MediaEvent.ERROR)
								break;
							
						// play events
							case 'NetStream.Play.Start':
								dispatch(MediaEvent.PLAYING)
								_ended = false;
								break;
							
							case 'NetStream.Play.Stop':
								dispatch(MediaEvent.STOPPED)
								break;
							
							// this gets called when the stream has completed playing (the event is forwarded from the client)
							case 'NetStream.Play.Complete':
								
								// properties
								_ended		= true;
								_playing	= false;
								
								// events
								dispatch(MediaEvent.COMPLETE);
								dispatch(MediaEvent.FINISHED);
								
								// repeat, rewind or pause
								if (_repeat)
								{
									replay();
								}
								else if (_autorewind)
								{
									rewind();
									stop();
								}
								else
								{
									_stream.pause();
								}
								break;
								
							case 'NetStream.Play.MetaData':
								dispatch(MediaEvent.METADATA, event.info)
								break;
								
							
						// seek events
							case 'NetStream.SeekStart.Notify':
								
								break;
							
							case 'NetStream.Seek.Notify':
								
								break;
							
							case 'NetStream.Unpause.Notify':
								dispatch(MediaEvent.PLAYING)
								break;
							
						// publish events
							case 'NetStream.Publish.Start':
								dispatch(MediaEvent.RECORDING);
								break;
							
							case 'NetStream.Unpublish.Success':
								if ( ! paused )
								{
									dispatch(MediaEvent.PROCESSED);
								}
								break;
							
						// record events
							case 'NetStream.Record.Start':
								
								break;
							
							case 'NetStream.Record.Stop':
								// called just before 'NetStream.Unpublish.Success':
								break;
							
						// buffer events
							case 'NetStream.Buffer.Full':
								
								break;
							
							case 'NetStream.Buffer.Flush':
								
								break;
							
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
			public function onPlayStatus(event:Object) :void
			{
				//trace('>>  client    : ' + event.code);
				stream.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, event));
				/**
				if (event.code == 'NetStream.Play.Complete')
				{
					_repeat ? replay() : stop();
				}
				**/
			}						
			
			/**
			 * Called by the NetStream client
			 * @param	data
			 */
			public function onMetaData(data:Object) :void
			{
				if ( ! _metaData )
				{
					// assign metadata
					_metaData = data;
					if ('frameWidth' in data)
					{
						_videoWidth		= int(data.frameWidth);
						_videoHeight	= int(data.frameHeight);
					}
					else
					{
						_videoWidth		= int(data.width);
						_videoHeight	= int(data.height);
					}
					_duration		= int(data.duration);
					
					// dispatch metadata event
					dispatch(MediaEvent.METADATA, data);
				}
			}
			
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function dispatch(eventName:String, data:* = null):void 
			{
				//trace('>>> media     : ' + eventName);
				_target.dispatchEvent(new MediaEvent(eventName, data, true));
			}
		
			protected function log(message:String, status:String = 'status'):void
			{
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, message, status));
			}
						
		
	}

}
