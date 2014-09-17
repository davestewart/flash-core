package core.media.video 
{
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * Instantiates a basic NetStreamVideo, then manages playback
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
				protected var _active					:Boolean;
				protected var _flipped					:Boolean;
				
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
				build(width, height);
				initialize();
				if (connection)
				{
					this.connection = connection;
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
					container.addChild(video);
			
				// update
					draw();
			}
			
			protected function reset():void 
			{
				
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function load(streamName:String):void 
			{
				// set name
					_streamName = streamName;
					
				// setup
					setupStream();
					
				// attach the NetStream
					video.attachNetStream(_stream);
					
				// bind to the initial playback event
					_stream.addEventListener(NetStatusEvent.NET_STATUS, onLoad);
					
				// play the movie you just recorded
					_stream.play(streamName);
			}
		
			public function play(streamName:String = null):void
			{
				// setup
					if (streamName && streamName !== this.streamName)
					{
						_streamName = streamName;
						setupStream();
						video.attachNetStream(_stream);
						_stream.play(streamName);
					}
				
					else
					{
						resume();
					}
					
				// flag
					_active	= true;
				
			}
			
			public function replay():void
			{
				_stream.seek(0);
			}

			public function pause():void
			{
				if (_stream)
				{
					_active	= false;
					_stream.pause();
				}
			}
			
			public function resume():void 
			{
				if (_stream)
				{
					trace('resuming...')
					_active	= true;
					_stream.resume();
				}
			}
		
			public function stop():void
			{
				if (_stream)
				{
					//dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, { code:'NetStream.Play.Complete' } ));
					_active	= false;
					_stream.pause();
				}
				//close();
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
		
			public function get stream():NetStream 
			{
				return _stream;
			}
			
			public function get streamName():String { return _streamName; }
			
			public function get bufferTime():Number { return _bufferTime; }
			public function set bufferTime(value:Number):void 
			{
				_bufferTime = value;
			}
			
			public function get duration():int{ return _duration; }
			
			public function get metadata():Object { return _metaData; }
			
			public function get active():Boolean { return _active; }
			
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
					graphics.clear();
					graphics.beginFill(0x000000, 0.1);
					graphics.drawRect(0, 0, width, height);
					
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
				
				// status
					_status = event.info.description;
					
				// action
					switch(event.info.code)
					{
						// error events
							case 'NetStream.Play.StreamNotFound':
							case 'NetStream.Play.Failed':
								break;
							
						// play events
							case 'NetStream.Play.Complete':
								stop();
								break;
					}
			}
			
			protected function onLoad(event:NetStatusEvent):void 
			{
				if (event.info.code == 'NetStream.Play.Reset')
				{
					_stream.removeEventListener(NetStatusEvent.NET_STATUS, onLoad);
					pause();
				}
			}
		
			/**
			 * Called by the NetStream client
			 * @param	data
			 */
			public function onPlayStatus(event:Object) :void
			{
				dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, event));
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
			}						
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}