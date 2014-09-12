package core.display.components.video
{
	
	import fl.video.MetadataEvent;
	import fl.video.VideoEvent;
	
	import flash.display.Sprite;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	
	import flash.media.SoundTransform;
	import flash.media.Video;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class NetstreamVideo extends Sprite
	{

	// ------------------------------------------------------------------------------------------------------------------------
	//
	//  ██  ██            ██       ██    ██             
	//  ██  ██                     ██    ██             
	//  ██  ██ █████ ████ ██ █████ █████ ██ █████ █████ 
	//  ██  ██    ██ ██   ██    ██ ██ ██ ██ ██ ██ ██    
	//  ██  ██ █████ ██   ██ █████ ██ ██ ██ █████ █████ 
	//   ████  ██ ██ ██   ██ ██ ██ ██ ██ ██ ██       ██ 
	//    ██   █████ ██   ██ █████ █████ ██ █████ █████ 
	//
	// ------------------------------------------------------------------------------------------------------------------------
	// Variables

		// stage
			public var index					:int;
			public var url						:String;
			public var video					:Video;
			public var connection				:NetConnection;
			public var stream					:NetStream;
			public var client					:Object;
			
			public var isPaused					:Boolean;
			public var repeat					:Boolean;
			
			protected var initialized			:Boolean;
			protected var _volume				:Number				= 1;	// an additional volume property needed for when before the video is loaded.
			
		
	// ------------------------------------------------------------------------------------------------------------------------
	//
	//  ██       ██  ██   ██       ██ ██             ██   ██             
	//  ██           ██            ██                ██                  
	//  ██ █████ ██ █████ ██ █████ ██ ██ ████ █████ █████ ██ █████ █████ 
	//  ██ ██ ██ ██  ██   ██    ██ ██ ██   ██    ██  ██   ██ ██ ██ ██ ██ 
	//  ██ ██ ██ ██  ██   ██ █████ ██ ██  ██  █████  ██   ██ ██ ██ ██ ██ 
	//  ██ ██ ██ ██  ██   ██ ██ ██ ██ ██ ██   ██ ██  ██   ██ ██ ██ ██ ██ 
	//  ██ ██ ██ ██  ████ ██ █████ ██ ██ ████ █████  ████ ██ █████ ██ ██ 
	//
	// ------------------------------------------------------------------------------------------------------------------------
	// Initialization

		public function NetstreamVideo(width:int, height:int, url:String = '', autoPlay:Boolean = true)
		{
			// video
				build();
				
			// connection
				connect();
				
			// load
				if (url != '')
				{
					load(url, autoPlay)
				}
		}
		
		protected function build():void 
		{
			video = new Video(width, height);
			video.smoothing = true;
			addChild(video);
		}
		
		protected function connect():void 
		{
			if (connection == null)
			{
				// connection
				
					// object
						connection				= new NetConnection();
						connection.connect(null); 

					// listeners
						connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus, false, 0, true);
						connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
						connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError, false, 0, true);
						
				// stream
				
					// object
						stream					= new NetStream(connection);
						stream.bufferTime		= 3;
						
					// volume
					
					// this is pretty hacky. I'm setting the volume to 0, and when the metadata loads, I set 
					// its volume back otherwise I'm finding that Flash plays some of the stream as it loads
					// and you get a brief spike of sound as the stream initializes
					
						stream.soundTransform	= new SoundTransform(0);
						
					// client (handles metadata callbacks)
						client					=
						{
							onMetaData			:onClientMetaData,
							onClientPlayStatus		:onClientPlayStatus
						}
						stream.client			= client;

					// normal event listeners
						stream.addEventListener(NetStatusEvent.NET_STATUS, onNetstreamStatus, false, 0, true);

					// attach stream (if there is one)
						video.attachNetStream(stream); 
						
				
			}
		}
			
	// ------------------------------------------------------------------------------------------------------------------------
	//
	//  ██████       ██    ██ ██            ██   ██        ██   ██             ██       
	//  ██  ██       ██    ██               ███ ███        ██   ██             ██       
	//  ██  ██ ██ ██ █████ ██ ██ █████      ███████ █████ █████ █████ █████ █████ █████ 
	//  ██████ ██ ██ ██ ██ ██ ██ ██         ██ █ ██ ██ ██  ██   ██ ██ ██ ██ ██ ██ ██    
	//  ██     ██ ██ ██ ██ ██ ██ ██         ██   ██ █████  ██   ██ ██ ██ ██ ██ ██ █████ 
	//  ██     ██ ██ ██ ██ ██ ██ ██         ██   ██ ██     ██   ██ ██ ██ ██ ██ ██    ██ 
	//  ██     █████ █████ ██ ██ █████      ██   ██ █████  ████ ██ ██ █████ █████ █████ 
	//
	// ------------------------------------------------------------------------------------------------------------------------
	// Public Methods

		public function load(url:String, autoPlay:Boolean = true):void 
		{
			// variables
				this.url			= url;
				this.isPaused		= !autoPlay;
				this.initialized	= false;
				
			// debug
				trace('NetstreamVideo loading: ' + url)
				
			// play url
				stream.play(url);
		}
		
		public function play():void 
		{
			//trace('playing ')
			if (isPaused)
			{
				//trace('resuming');
				//trace('volume is: ' + volume);
				//trace('url is ' + url);
				isPaused = false;
				stream.resume();
				volume = 1;
			}
			else 
			{
				//trace('seeking to 0');
				stream.seek(0);
				stream.resume();
				volume = 1;
			}
		}
		
		public function pause():void 
		{
			stream.pause();
			isPaused = true;
		}
		
		public function stop():void 
		{
			rewind();
		}
		
		public function rewind():void 
		{
			var lastVolume = volume;
			volume = 0;
			pause();
			stream.seek(0);
			volume = lastVolume;
		}
		
		public function close():void
		{
			if (stream != null)
			{
				stream.pause();
				stream.close();
				video.clear();
				initialized = false;
			}
		}
		
		
		public function set volume(value:Number):void 
		{
			//trace('SETTING VOLUME TO: ' + value, url);
			_volume = value;
			stream.soundTransform = new SoundTransform(value);
		}
		
		public function get volume():Number 
		{
			return stream.soundTransform.volume;
		}
		
	// ------------------------------------------------------------------------------------------------------------------------
	//
	//  ██  ██                ██ ██                  
	//  ██  ██                ██ ██                  
	//  ██  ██ █████ █████ █████ ██ █████ ████ █████ 
	//  ██████    ██ ██ ██ ██ ██ ██ ██ ██ ██   ██    
	//  ██  ██ █████ ██ ██ ██ ██ ██ █████ ██   █████ 
	//  ██  ██ ██ ██ ██ ██ ██ ██ ██ ██    ██      ██ 
	//  ██  ██ █████ ██ ██ █████ ██ █████ ██   █████ 
	//
	// ------------------------------------------------------------------------------------------------------------------------
	// Handlers


		// connection
			protected function onConnectionStatus(event:NetStatusEvent):void
			{
				//trace(evt.info.code);

				switch (event.info.code) {
					
					case "NetConnection.Connect.Success" :
						//trace("Incoming connection found to: " + url);
						break;
			
					case "NetStream.Publish.BadName" :
						//trace("Incoming connection not found for: " + url);
						break;
						
					case "NetConnection.Connect.Closed" :
						connection.removeEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
						connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
						connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
						connection = null;
						break;
				}
			}
			
		// security
			protected function onSecurityError(evt:SecurityErrorEvent):void
			{
				//trace("securityErrorHandler: " + evt);
			}
			
		// async
			function onAsyncError(evt:AsyncErrorEvent):void
			{
				// ignore AsyncErrorEvent events.
				//trace('Async error')
			}

		// playing and stopping
			protected function onNetstreamStatus(object:Object):void
			{
				//trace('\nnetStreamStatusHandler:' + object.info.code)
				switch(object.info.code)
				{
					case "NetStream.Play.Complete":
						// this never fires!
						break;	
					
					case "NetStream.Play.Stop":
						if (!repeat)
						{
							dispatchEvent(new VideoEvent(VideoEvent.STOPPED_STATE_ENTERED, false, false, null, stream.time, index));					
						}
						else
						{
							stream.seek(0);
							stream.resume();
						}
						break;

					case "NetStream.Play.Start":
						// this only fires the first time the stream loads and plays
						break;
						
					case "NetStream.Play.StreamNotFound":
						trace('Stream load failed: retrying...')
						//load(url, false);
						break;
						
					case "NetStream.Clear.Success":
						//trace("Stream cleared successfully"); // this never fires!
						break;
					
					case "NetStream.Clear.Failed":
						//trace("Stream not cleared"); // this never fires!
						break;
					
				}
			}
			
			protected function onClientPlayStatus(object:Object):void
			{
				//trace('\nonPlayStatus:' + object.info.code)
			};
			
			
		// metadata, size, etc
			protected function onClientMetaData(info:Object):void
			{
				if (!initialized)
				{
					// debug
						if (true)
						{
							//trace('\nMetadata received for: ' + url);
							/*
							trace('Width is: ' + info.width)
							for (var p in info)
							{
								trace(p + ' ' + info[p]);
							}
							*/
						}

			
					// set volume and move to start of stream, ready for playing
						if (isPaused)
						{
							stream.pause();
							stream.seek(0);
						}
						
					// check buffertime
						if (stream.bufferTime > info.duration)
						{
							stream.bufferTime = info.duration - 1;
						}
					
					// variables & properties
						initialized = true;
						if (_volume > 0)	// set volume back to 1, unless previously set to 0
						{
							volume = _volume;
						}
						
					// tell the world
						dispatchEvent(new MetadataEvent(MetadataEvent.METADATA_RECEIVED, false, false, info));
						dispatchEvent(new VideoEvent(VideoEvent.READY, false, false, null, stream.time, index));					
				}

				
			} 

		
	}
}