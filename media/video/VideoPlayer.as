package core.media.video 
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
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
				
			// properties
				protected var _connection				:NetConnection;             
				protected var _stream					:NetStream;
				
			// play properties
				protected var _active					:Boolean;
				protected var _flipped					:Boolean;
				protected var _paused					:Boolean;
				protected var _repeat					:Boolean;
				
			// stream variables
				protected var _streamName				:String;
				protected var _videoWidth				:int;
				protected var _videoHeight				:int;
				protected var _duration					:int;
				protected var _bufferTime				:Number;
				protected var _metaData					:Object;
				
			// feedback
				protected var _status					:String;
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoPlayer(width:int = 320, height:int = 180, connection:NetConnection = null) 
			{
				// parameters
					width	= width > 0 ? width : 320;
					height	= height > 0 ? height : 180;
				
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
					
					if (height > 360)
						container.scrollRect = new Rectangle(0, 0, width, 360);
					
					/*
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
			public function load(streamName:String, autoplay:Boolean = false):void 
			{
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
							_stream.removeEventListener(NetStatusEvent.NET_STATUS, onLoad);
							dispatchEvent(new MediaEvent(MediaEvent.LOADED));
							autoplay 
								? replay()
								: pause();
						}
					}
					
				// bind to the initial playback event
					_stream.addEventListener(NetStatusEvent.NET_STATUS, onLoad);
					
				// play the movie you just recorded
					_stream.play(streamName);
			}
		
			/**
			 * Load and play the stream immediately
			 * 
			 * @param	streamName
			 */
			public function play():void
			{
				// TODO set this up so that play only plays / resumes an existing stream (ALWAYS use load to load a stream)
				
				// setup
					if (streamName && streamName !== this.streamName)
					{
						_streamName = streamName;
						setupStream();
						video.attachNetStream(_stream);
						_stream.play(streamName);
						dispatchEvent(new MediaEvent(MediaEvent.STARTED)); // PLAYING will also fire, but driven by the NetStream
					}
				
					else
					{
						resume();
					}
					
				// flag
					_paused	= false;
					_active	= true;
			}
			
			public function replay():void
			{
				if (_stream)
				{
					_active	= true;
					_paused	= false;
					_stream.seek(0);
				}
			}

			public function pause():void
			{
				if (_stream)
				{
					_paused	= true;
					_stream.pause();
					dispatchEvent(new MediaEvent(MediaEvent.PAUSED));
				}
			}
			
			public function resume():void 
			{
				if (_stream)
				{
					trace('VideoPlayer: resuming...')
					_paused	= false;
					_stream.resume();
					dispatchEvent(new MediaEvent(MediaEvent.RESUMED));
				}
			}
		
			public function stop():void
			{
				if (_stream)
				{
					//dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, { code:'NetStream.Play.Complete' } ));
					_active	= false;
					_paused	= false;
					_stream.pause();
					dispatchEvent(new Event(Event.COMPLETE));
					dispatchEvent(new MediaEvent(MediaEvent.STOPPED));
				}
				//close();
			}
			
			public function rewind():void
			{
				if (_stream)
				{
					_active	= false;
					_paused	= true;
					_stream.pause();
					_stream.seek(0);
					dispatchEvent(new MediaEvent(MediaEvent.REWIND));
				}
			}
		
			public function clear():void 
			{
				video.clear();
			}
			
			public function close():void 
			{
				video.attachNetStream(null);
				video.clear();
				
				if (_stream)
				{
					_stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					if (_connection)
					{
						_stream.dispose();
					}
					_stream			= null;
					_streamName		= null;
					dispatchEvent(new MediaEvent(MediaEvent.CLOSED));
				}
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
			
			public function get duration():int{ return _duration; }
			
			public function get metadata():Object { return _metaData; }
			
			public function get active():Boolean { return _active; }
			
			public function get status():String { return _status; }
			
			public function get paused():Boolean { return _paused; }
			
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
					trace('>>> ' + event.info.code);
					
				// status
					_status = event.info.description;
					
				// action
					// @see http://help.adobe.com/en_US/as3/dev/WS901d38e593cd1bac-3d11a09612fffaf8447-8000.html
					switch(event.info.code)
					{
						// error events
							case 'NetStream.Play.StreamNotFound':
							case 'NetStream.Play.Failed':
								dispatchEvent(new MediaEvent(MediaEvent.ERROR));
								break;
							
						// play events
							case 'NetStream.Play.Start':
								dispatchEvent(new MediaEvent(MediaEvent.PLAYING));
								break;
							
							case 'NetStream.Play.Stop':
								// this gets called when the 
								break;
							
							// this gets called when the stream has completed playing
							case 'NetStream.Play.Complete':
								stop();
								break;
								
							case 'NetStream.Play.MetaData':
								dispatchEvent(new MediaEvent(MediaEvent.METADATA, event.info));
								break;
								
							
						// seek events
							case 'NetStream.SeekStart.Notify':
								
								break;
							
							case 'NetStream.Seek.Notify':
								
								break;
							
							case 'NetStream.Unpause.Notify':
								
								break;
							
							case 'NetStream.Unpause.Notify':
								
								break;
							
						// publish events
							case 'NetStream.Publish.Start':
								
								break;
							
							case 'NetStream.Unpublish.Success':
								if ( ! paused )
								{
									dispatchEvent(new MediaEvent(MediaEvent.PROCESSED));
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
								dispatchEvent(new MediaEvent(MediaEvent.STOPPED)); // temp
								break;
							
							default:
							
					}
			}
			
			/**
			 * Called by the NetStream client, playback only
			 * @param	data
			 */
			public function onPlayStatus(event:Object) :void
			{
				trace('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + event.code);
				dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, event));
				if (event.code == 'NetStream.Play.Complete')
				{
					_repeat ? replay() : stop();
				}
			}						
			
			/**
			 * Called by the NetStream client
			 * @param	data
			 */
			public function onMetaData(data:Object) :void
			{
				_metaData = data;
				if ('frameWidth' in data)
				{
					_videoWidth		= int(data.frameWidth);
					_videoHeight	= int(data.frameHeight);
					_duration		= int(data.duration);
				}
				data.code = 'NetStream.Play.MetaData';
				dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, data));
				dispatchEvent(new MediaEvent(MediaEvent.METADATA, data));
				
			}
			
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}