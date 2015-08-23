package core.media.encoders 
{
	import core.events.VideoEncoderEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import core.media.encoders.base.WebcamEncoder;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class StreamEncoder extends WebcamEncoder 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// server properties
				protected var _server			:String;
				protected var _username			:String;
				protected var _password			:String;
				
			// connection properties
				protected var _connection		:NetConnection;
				protected var _stream			:NetStream;
				
			// recording properties
				protected var _streamName		:String;
				protected var _mode				:String;
				protected var _metadata			:Object;
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			/**
			 * Constructor
			 * 
			 * Note that username and password might have to be passed as part of the server URL: 
			 * 
			 *  - rtmp://username:password@server.com/folder
			 * 
			 * @param	server
			 * @param	username
			 * @param	password
			 */
			public function StreamEncoder(server:String, username:String = '', password:String = '') 
			{
				// super
				super();
				
				// parameters
				_password		= password;
				_username		= username;
				_server			= server;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Connects to the server
			 */
			override public function setup():void 
			{
				if (phase === PHASE_NOT_READY)
				{
					// connection
					_connection = new NetConnection();
					_connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
					_connection.connect(_server);
					
					// formats
					allowedFormats	= ['mp4', 'flv'];
					_format			= 'mp4';
					
					// metadata
					_metadata = 
					{
						description : ''
					};
					
					// set up flushing timer
					timer.addEventListener(TimerEvent.TIMER, onProcess);
				}
			}
			
			/**
			 * Sets up the netstream
			 */
			override public function initialize():void 
			{
				// set phase
				setPhase(PHASE_INITIALIZING);
				
				// clean up the last stream
				close();

				// each time we play a video create a new NetStream object
				_stream				= new NetStream(_connection);
				_stream.bufferTime	= 2; // _bufferTime; // set the buffer time to 2 seconds
				_stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				
				// add h264 settings
				if (format === 'mp4')
				{
					var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
					h264Settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_3_1);
					_stream.videoStreamSettings = h264Settings;
				}
				
				// reset mode to recording (can also have "live" and "default", but "record" has NetStream events we can bind to)
				_mode		= 'record';
				
				// set phase
				setPhase(PHASE_INITIALIZED);
			}
			
			/**
			 * Publishes the stream
			 */
			override public function start():void 
			{
				// initialize if not already
				if (phase !== PHASE_READY)
				{
					initialize();
				}
				
				// phase (check for pause)
				if (phase !== PHASE_CAPTURING)
				{
					super.start();
				}
				
				// debug
				log('Recording...');
				
				// publish the stream by name
				_stream.publish(format + ':' + _streamName, _mode);
				
				// if we're recording, add the metadata at the start of the stream
				if (_mode !== 'append')
				{
					stream.send('@setDataFrame', 'onMetaData', metadata);					
				}
				
				// video frame handler for camera
				_camera.addEventListener(Event.VIDEO_FRAME, onFrame);
				
				// attach the camera and microphone to the stream
				_stream.attachCamera(camera);
				if (_microphone)
				{
					_stream.attachAudio(microphone);
				}
			}
			
			/**
			 * Pauses the recording
			 */
			public function pause():void 
			{
				_mode = 'append';
				_stream.publish('null');
			}
			
			/**
			 * Resumes the recording (alias for start)
			 */
			public function resume():void 
			{
				start();
			}
			
			override public function stop():void 
			{
				// video frame handler for camera
				_camera.removeEventListener(Event.VIDEO_FRAME, onFrame);

				// disable audio so that mp4 will record
				_stream.attachAudio(null);

				// stop streaming video and audio to the publishing NetStream object
				_stream.attachCamera(null);
					
				// set phase
				setPhase(PHASE_PROCESSING);

				// After stopping the publishing we need to check if there is video content in the NetStream buffer. 
				// If there is data we are going to monitor the video upload progress by calling flushVideoBuffer every 250ms.
				_stream.bufferLength > 0
					? timer.start()
					: finish();	
			}
			
			/**
			 * Closes the stream
			 */
			override protected function finish():void 
			{
				// close the stream
				_stream.publish('null'); // TODO check that the string "null" should be passed, and not the value null
				_stream.close();
				
				// finish
				setPhase(PHASE_FINISHED);
			}
			
			/**
			 * Closes any streans and connections
			 */
			override public function destroy():void 
			{
				// nullify timer
				super();

				// nullify stream
				close();
				
				// nullify connection
				_connection.removeEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
				_connection 	= null;
				_camera			= null;
				_microphone		= null;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get streamName():String { return _streamName; }
			public function set streamName(value:String):void 
			{
				_streamName = value;
			}
			
			public function get mode():String { return _mode; }
			
			public function get stream():NetStream { return _stream; }
			
			public function get metadata():Object { return _metadata; }
			
			public function get url():Object { return _server + _streamName + '.' + _format; }
			
			override public function get result():* { return _url; }
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onConnectionStatus(event:NetStatusEvent):void
			{
				// debug
					log(event);
						
				// action
					switch(event.info.code)
					{
						case 'NetConnection.Connect.Success':
							onSetupComplete();
							break;
						
						case 'NetConnection.Connect.Failed':
							error("Connection failed: Try rtmp://[server ip]/[app name]");
							break;
						
						case 'NetConnection.Connect.Rejected':
							error("Connection rejected: " + event.info.description);
							break;
					}				
			}
			
			protected function onNetStatus(event:NetStatusEvent):void 
			{
				// debug
					log(event);
				
				// action
					// @see http://help.adobe.com/en_US/as3/dev/WS901d38e593cd1bac-3d11a09612fffaf8447-8000.html
					switch(event.info.code)
					{
						// publish events
							case 'NetStream.Publish.Start':
								//onStart(); // the recording has started
								break;
							
							case 'NetStream.Unpublish.Success':
								finish();
								break;
							
						// record events
							case 'NetStream.Record.Start':
								//controls.btnRecord.label = 'Stop';
								break;
							
							case 'NetStream.Record.Stop':
								//controls.btnRecord.label = 'Record';
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
			 * this function gets called every 250 ms to monitor the progress of flushing the video buffer
			 * Once the video buffer is empty we close publishing stream
			 * @param	event
			 */
			override protected function onProcess(event:TimerEvent):void 
			{
				super.onProcess(event);
				if (_stream.bufferLength == 0)
				{
					timer.stop();
					finish();
				}
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function close():void 
			{
				if (_stream)
				{
					_stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					_stream.dispose();
					_stream = null;
				}
			}
					
	}

}