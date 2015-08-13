package core.media.video 
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import core.events.MediaEvent;
	
	/**
	 * Instantiates a basic NetStreamVideo, then manages playback
	 * 
	 * Encoding live video to H.264/AVC with Flash Player 11
	 * http://www.adobe.com/devnet/adobe-media-server/articles/encoding-live-video-h264.html
	 * 
	 * @author Dave Stewart
	 */
	public class VideoPlayer extends Sprite 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements
				protected var video						:Video;
				protected var container					:Sprite;
				
			// objects
				protected var _connection				:NetConnection;             
				protected var _stream					:NetStream;
				
			// video properties
				protected var _flipped					:Boolean;
				protected var _autosize					:Boolean;
				
			// play properties
				protected var _repeat					:Boolean;
				protected var _autorewind				:Boolean;
				
			// play state
				protected var _active					:Boolean;
				protected var _playing					:Boolean;
				protected var _paused					:Boolean;
				protected var _ended					:Boolean;
				
			// stream variables
			// TODO move all this rubbish to a stream-manager class
				protected var _streamName				:String; // url
				protected var _videoWidth				:int;
				protected var _videoHeight				:int;
				protected var _duration					:int;
				protected var _bufferTime				:Number;
				protected var _metaData					:Object;
				
			// feedback
				protected var _status					:String;
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoPlayer(width:uint = 320, height:uint = 180, connection:NetConnection = null) 
			{
				// build
					build(width, height);
					initialize();
					
				// connect
					if (connection is NetConnection)
					{
						this.connection = connection;
					}
					else
					{
						this.connection = new NetConnection();
						this.connection.connect(null);
					};
			}
		
			protected function initialize():void 
			{
				_duration	= -1;
				bufferTime	= 2;
			}
		
			protected function build(width:Number, height:Number):void 
			{
				// container
					container		= new Sprite();
					container.name	= 'container';
					addChild(container);
					
				// video
					video			= new Video(width, height);
					video.name		= 'video';
					video.smoothing	= true
					container.addChild(video);
					
				// size
					// need to add some code in to handle resizing, masking, etc
					
					/*
					if (height > 360)
						container.scrollRect = new Rectangle(0, 0, width, 360);
					var vidMask:Square = new Square(640, 360);
					addChild(vidMask);
					container.mask = vidMask;
					*/
					
				// update
					draw();
			}
			
			protected function reset():void 
			{
				
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Load the steam and pause it immediately upon loading
			 * 
			 * @param	streamName
			 */
			public function load(streamName:String, autoplay:Boolean = false):Boolean 
			{
				// don't load the same stream twice
					if (streamName === _streamName)
					{
						return false;
					}
					
				// set name
					_streamName = streamName;
					
				// setup
					setupStream();
					
				// attach the NetStream
					video.attachNetStream(_stream);
					
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
					
				// play the movie you just recorded
					_stream.play(streamName);
					
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
						
						_active		= true;
						_playing	= true;
						_paused		= false;
						
						if (_stream.time == 0 || _ended)
						{
							_ended = false;
							dispatch(MediaEvent.STARTED) // PLAYING will also fire, but driven by the NetStream
						}
						else
						{
							dispatch(MediaEvent.RESUMED);
						}
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
			protected function _rewind():void 
			{
				if (_stream)
				{
					_ended		= false;
					_stream.seek(0);
				}
			}
		
			public function clear():void 
			{
				video.clear();
			}
			
			public function close():Boolean 
			{
				// properties
				_playing		= false;
				_paused			= false;
				_active			= false;
				_ended			= false;
				
				// video
				clear();
				video.attachNetStream(null);
				
				// stream
				if (_stream)
				{
					_stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					if (_connection)
					{
						_stream.dispose();
					}
					_stream			= null;
					_streamName		= null;
					dispatch(MediaEvent.CLOSED);
					return true;
				}
				return false;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			override public function set width(value:Number):void 
			{
				video.width = value;
				draw();
			}
			
			override public function set height(value:Number):void 
			{
				video.height = value;
				draw();
			}
			
			public function get videoWidth():int { return _videoWidth; }
			public function get videoHeight():int { return _videoHeight; }
			
			public function get flipped():Boolean { return _flipped; }
			public function set flipped(value:Boolean):void 
			{
				_flipped = value;
				draw();
			}
			
			public function get connection():NetConnection { return _connection; }
			public function set connection(connection:NetConnection):void 
			{
				_connection = connection;
			}
			
			public function get fullscreen():Boolean { return stage ? stage.displayState == StageDisplayState.FULL_SCREEN : false; }
			public function set fullscreen(state:Boolean):void 
			{
				if (state)
				{
					// currently, this isn't working
					// @see http://help.adobe.com/en_US/as3/dev/WS44B1892B-1668-4a80-8431-6BA0F1947766.html
					/*
					var coords:Point	= localToGlobal(new Point(x, y));
					var rect:Shape		= new Square(width, height);
					rect.x				= coords.x;
					rect.y				= coords.y;
					
					trace(coords);
					App.instance.document.addChild(rect);
					stage.fullScreenSourceRect	= new Rectangle(coords.x, coords.y, width, height); 
					//stage.displayState			= StageDisplayState.FULL_SCREEN;
					*/
				}
				else
				{
					stage.displayState			= StageDisplayState.NORMAL;
				}
			}
			
			public function get autosize():Boolean { return _autosize; }
			public function set autosize(value:Boolean):void 
			{
				_autosize = value;
			}
			
			
			
			// TODO move all netstream-related rubbish into the stream class, or a settings class
		
			public function get stream():NetStream { return _stream; }
			
			public function get streamName():String { return _streamName; }
			
			public function get bufferTime():Number { return _bufferTime; }
			public function set bufferTime(value:Number):void 
			{
				_bufferTime = value;
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
			
			public function get duration():int{ return _duration; }
			
			public function get metadata():Object { return _metaData; }
			
			public function get active():Boolean { return _active; }
			
			public function get playing():Boolean { return _playing; }
			
			public function get paused():Boolean { return _paused; }
			
			public function get ended():Boolean { return _ended; }
			
			public function get status():String { return _status; }
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function setupStream():void
			{
				// clean up the last stream
					if (_stream)
					{
						_stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
						_stream.dispose();
					}
				
				// each time we play a video create a new NetStream object
					_stream = new NetStream(_connection);
					_stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					
				// client
					stream.client		= this;

				// set the buffer time to 2 seconds
					stream.bufferTime	= _bufferTime;
					
				// kill old values
					_duration			= 0;
					_metaData			= null;
			}
		
			protected function draw():void 
			{
				// background
					/*
					graphics.clear();
					graphics.beginFill(0x000000, 0.1);
					graphics.drawRect(0, 0, width, height);
					*/
					
				// video
					container.scaleX	= _flipped ? -1 : 1;
					container.x			= _flipped ? video.width : 0;
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
								
								// rewind, etc
								if ( ! (_autorewind && _repeat) )
								{
									_stream.pause();
								}
								
								if (_autorewind)
								{
									rewind();
									if ( ! _repeat )
									{
										stop();
									}
								}
								
								if (_repeat)
								{
									replay();
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
								
								break;
							
							case 'NetStream.Unpublish.Success':
								if ( ! paused )
								{
									dispatch(MediaEvent.PROCESSED)
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
					
					// autosize
					if (_autosize)
					{
						if(video.width !== _videoWidth || video.height !== _videoHeight)
						video.width		= _videoWidth;
						video.height	= _videoHeight;
						draw();
						dispatch(MediaEvent.RESIZE);
					}
				}
			}
			
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function dispatch(eventName:String, data:* = null):void 
			{
				trace('>>> player    : ' + eventName);
				dispatchEvent(new MediaEvent(eventName, data));
			}
		
			protected function log(message:String, status:String = 'status'):void
			{
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, message, status));
			}
			
	}

}