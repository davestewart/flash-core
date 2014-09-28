package core.media.video 
{
	import flash.events.ActivityEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import core.events.CameraEvent;
	
	/**
	 * Instantiates a basic NetStreamVideo, then manages camera and publish locations
	 * 
	 * @author Dave Stewart
	 */
	public class VideoRecorder extends VideoPlayer 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// properties
				protected var camera					:Camera;
				//protected var microphone				:Microphone;
				
			// camera variables
				protected var _quality					:int;
				protected var _fps						:int;
			
			// recording variables
				protected var _format					:String;
				
			// stream variables
				protected var _bandwidth				:int;
				protected var _keyframeInterval			:int;
				
			// setup flags
				protected var _setup					:Boolean;
				protected var _ready					:Boolean;
				protected var _available				:Boolean;
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoRecorder(width:int = 320, height:int = 180, setup:Boolean = true, connection:NetConnection = null)
			{
				// super
					super(width, height, connection);
					
				// set video dimensions to the same as the video
					_videoWidth		= this.width
					_videoHeight	= this.height;
					
				// setup camera
					if (setup)
					{
						this.setup();
					}
			}
		
			override protected function initialize():void 
			{
				format				= 'mp4';
				fps					= 25;
				quality				= 90;
				bandwidth			= 0;
				keyframeInterval	= 15;
				bufferTime			= 20;
				flipped				= true;
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: camera methods
		
			public function setup():void 
			{
				video.clear();
				setupCamera();
			}
			
			protected function setupCamera():void
			{	
				// don't set up twice!
					if (_setup) return;
					
				// debug
					trace('setup camera...');
				
				// get the default Flash camera and microphone
					camera = Camera.getCamera();
					
				// here are all the quality and performance settings
					if(camera != null)
					{
						// attach video
							video.attachCamera(camera);

						// test to see if camera can be activated
							setTimeout(testCamera, 500);
							
						// update camera
							updateCamera();
					}
					else
					{
						dispatchEvent(new CameraEvent(CameraEvent.NO_CAMERA));
						trace('No Camera Found');
					}
					
				// set up the mic
				/*
					microphone = Microphone.getMicrophone();
					if( microphone != null)
					{
						microphone.rate = 11;
						microphone.setSilenceLevel(0, -1); 
					}
					else
					{
						log('No Microphone Found', 'error');
						dispatchEvent(new CameraEvent(CameraEvent.NO_MICROPHONE));
					}
				*/
					
				// flag as already set up
					_ready = true;
					_setup = true;
			}
			
			protected function testCamera():void
			{
				// debug
					trace('testing for camera...')
				
				// callbacks
					function onCameraActivity(event:ActivityEvent):void 
					{
						_available = true;
						trace('camera activated successfully!');
						camera.removeEventListener(ActivityEvent.ACTIVITY, onCameraActivity);
						dispatchEvent(new CameraEvent(CameraEvent.ACTIVATED));
					}
				
					function onMouseMove(event:MouseEvent):void 
					{
						trace('mouse moved, checking for camera activation');
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
						setTimeout(onActivationCheckTimeout, 500);
					}
					
					function onActivationCheckTimeout():void
					{
						if ( ! _available )
						{
							trace('could not activate camera!');
							//dispatchEvent(new CameraEvent(CameraEvent.NOT_ACTIVATED));
						}
					}
					
					function onAddedToStage(event:Event):void 
					{
						trace('camera added to stage');
						stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					}
				
				// detect inactivity if another application is using the camera
					camera.addEventListener(ActivityEvent.ACTIVITY, onCameraActivity);
							
				// set up mousemove handler to detect when the dialog has been dismissed
					if (stage)
					{
						stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					}
					else
					{
						addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
					}
			}
		
			protected function updateCamera():void
			{
				if (camera)
				{
					// variables
						var rate:int = videoWidth * videoHeight; // alternative bandwidth
						
					// keyframes
						camera.setKeyFrameInterval(keyframeInterval);
						
					// quality
						camera.setQuality(bandwidth, quality);
						
					// size
						
						// @TODO make more robust
						camera.setMode(1280, 720, fps);
						if (camera.height !== 720)
						{
							camera.setMode(640, 360, fps);
							if (camera.width !== videoWidth)
							{
								camera.setMode(videoWidth, videoHeight, fps);
								dispatchEvent(new CameraEvent(CameraEvent.SIZE_ERROR));
								trace('The camera could not be set to the required size!');
							}
						}
						
					// update values
						_videoWidth		= camera.width;
						_videoHeight	= camera.height;
						_fps			= camera.fps;
						
					// debug
						trace('props:', videoWidth, videoHeight, bandwidth, quality, fps, keyframeInterval);
						trace('rate:', rate);
						
					// event
						dispatchEvent(new CameraEvent(CameraEvent.SIZE_CHANGE));
				}
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			// Start recording video to the server
			public function record(streamName:String = null, append:Boolean = false):Boolean
			{
				// debug
					log('Recording...');
					
				// exit early if camera is not available
					if ( ! _available )
					{
						dispatchEvent(new CameraEvent(CameraEvent.NOT_ACTIVATED));
						return false;
					}
					
				// set active
					_active = true;
					_paused = false;
					
				// append
					if (append )
					{
						stream.publish(format + ':' + streamName, 'append');
					}
					else
					{
						// setup stream
							setupStream();
							
						// add h264 settings
							if (format == 'mp4')
							{
								var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
								h264Settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_3_1);
								stream.videoStreamSettings = h264Settings;
							}

						// publish the stream by name
							stream.publish(format + ':' + streamName, append ? 'append' : 'record'); // can also have "live" and "default", but "record" has NetStream events we can bind to
							
						// add custom metadata to the header of the .flv file
							var metaData:Object	= 
							{
								description : 'Recorded using WebcamRecording example.'
							};
							stream.send('@setDataFrame', 'onMetaData', metaData);
						
						// TODO implement proper handlers for permissions: http://help.adobe.com/en_US/as3/dev/WSfffb011ac560372f3fa68e8912e3ab6b8cb-8000.html#WS5b3ccc516d4fbf351e63e3d118a9b90204-7d37
						
						// attach the camera and microphone to the server
							stream.attachCamera(camera);
							//stream.attachAudio(microphone);
					}
					
				// return
					return true;
			}
			
			override public function pause():void 
			{
				super.pause();
				stream.publish('null');
			}

			override public function stop():void
			{
				// debug
					//trace('stopping recording...')
				
				// set active
					_active = false;
					_paused = false;

				// variables
					var intervalId:Number;
				
				// this function gets called every 250 ms to monitor the progress of flushing the video buffer.
				// Once the video buffer is empty we close publishing stream
					function onBufferFlush():void
					{
						log('Waiting for buffer to empty...');
						if (stream.bufferLength == 0)
						{
							log('Buffer emptied!');
							clearInterval(intervalId);
							onRecordComplete();
						}
					}

				// stop streaming video and audio to the publishing NetStream object
					stream.attachCamera(null);
					
				// disabled audio so that mp4 will record
					stream.attachAudio(null); 

				// After stopping the publishing we need to check if there is video content in the NetStream buffer. 
				// If there is data we are going to monitor the video upload progress by calling flushVideoBuffer every 250ms.
					stream.bufferLength > 0
						? intervalId = setInterval(onBufferFlush, 250)
						: onRecordComplete();		
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get format():String { return _format; }
			public function set format(value:String):void 
			{
				if (/^(flv|mp4)$/.test(value))
				{
					_format = value;
				}
				else
				{
					throw new Error('Invalid video format "' +value+ '"');
				}
			}
		
			public function get quality():int { return _quality; }
			public function set quality(value:int):void 
			{
				_quality = value;
				updateCamera();
			}
			
			public function get size():Array { return [videoWidth, videoHeight]; }
			public function set size(value:Array):void 
			{
				_videoWidth		= value[0];
				_videoHeight	= value[1];
				updateCamera();
			}
			
			public function set videoWidth(value:int):void 
			{
				_videoWidth = value;
				updateCamera();
			}
			
			public function set videoHeight(value:int):void 
			{
				_videoHeight = value;
				updateCamera();
			}
			
			public function get fps():int { return _fps; }
			public function set fps(value:int):void 
			{
				_fps = value;
				updateCamera();
			}
			
			public function get bandwidth():int { return _bandwidth; }
			public function set bandwidth(value:int):void 
			{
				_bandwidth = value;
				updateCamera();
			}
			
			public function get keyframeInterval():int { return _keyframeInterval; }
			public function set keyframeInterval(value:int):void 
			{
				_keyframeInterval = value;
				updateCamera();
			}
			
			public function get available():Boolean { return _available; }
			
			public function get ready():Boolean { return _ready; }
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onRecordComplete():void
			{
				// debug
					log('Finished recording!')
					
				// after we have hit "Stop" recording, and after the buffered video data has been
				// sent to the Wowza Media Server, close the publishing stream
					stream.publish('null');
					stream.close();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function log(message:String, status:String = 'status'):void
			{
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, message, status));
			}
			
			override public function toString():String 
			{
				return '[object VideoRecorder videoWidth="' +videoWidth + '" videoHeight="' +videoHeight + '" fps="' +fps + '" quality="' +quality + '" bandwidth="' +bandwidth + '"]';
			}
		
	}

}

