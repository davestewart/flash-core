package core.media.video 
{
	import core.data.settings.VideoSettings;
	import core.errors.ImplementationError;
	import core.events.MediaEvent;
	import core.media.camera.Webcam;
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
	import flash.external.ExternalInterface;
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
				protected var _webcam					:Webcam;
				protected var _camera					:Camera;
				protected var _settings					:VideoSettings;
				
			// camera variables
				protected var _quality					:int;
				protected var _fps						:int;
			
			// recording variables
				protected var _format					:String;
				
			// stream variables
				protected var _bandwidth				:int;
				protected var _keyframeInterval			:int;
				
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoRecorder(width:int = 320, height:int = 180, connection:NetConnection = null)
			{
				// super
					super(width, height, connection);
					
				// set video dimensions to the same as the video
					_videoWidth		= this.width
					_videoHeight	= this.height;
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
				if ( ! webcam )
				{
					_webcam = new Webcam(video);
					webcam.addEventListener(CameraEvent.SIZE_CHANGE, onCameraSizeChange);
				}
			}
			
			protected function updateCamera():void
			{
				if (camera)
				{
					// keyframes
						camera.setKeyFrameInterval(keyframeInterval);
						
					// size
						
						// Detect aspect ratio supported by webcam
						/*
						camera.setMode(4000, 2250, 25);
				
						var camWidth:Number = camera.width;
						var camHeight:Number = camera.height;
						var ratio:Number = gcd (camWidth, camHeight);
						var aspectRatio:String = camWidth / ratio +":" + camHeight / ratio;
						
						trace("Camera dimensions = ", camWidth, "x", camHeight);
						trace("Camera aspect ratio = ", aspectRatio);
						
						if (aspectRatio == "16:9")
							camera.setMode(1280, 720, 25);
						else
							camera.setMode(640, 480, 25);
						*/
						
						// forcing the camera to 4:3 fixes green stripe issue
						camera.setMode(640, 480, 25);
						if (camera.width < videoWidth)
						{
							camera.setMode(videoWidth, videoHeight, fps);
							dispatchEvent(new CameraEvent(CameraEvent.SIZE_ERROR));
							trace('The camera could not be set to the required size!');
						}
						
					// variables
						var rate:int = camera.width * camera.height; // alternative bandwidth
						
					// quality
						camera.setQuality(bandwidth, quality);
						
					// update values
						
					// debug
						//trace('props:', videoWidth, videoHeight, bandwidth, quality, fps, keyframeInterval);
						//trace('rate:', rate);
						
					// event
						dispatchEvent(new CameraEvent(CameraEvent.SIZE_CHANGE));
				}
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function record(append:Boolean = false):Boolean
			{
				// debug
					log('Recording...');
					
				// exit early if camera is not available
					if ( ! webcam.available )
					{
						dispatchEvent(new CameraEvent(CameraEvent.NOT_ACTIVATED));
						return false;
					}
					
				// set active
					_active = true;
					_paused = false;
					
				// defer to subclass
					dispatchEvent(new MediaEvent(MediaEvent.STARTED));
					_record(append);
				
				// return
					return true;
			}
			
			override public function pause():void 
			{
				super.pause();
				_pause();
				
			}

			override public function stop():void
			{
				// debug
					//trace('stopping recording...')
				
				// super
					super.stop();
					
				// set active
					_active = false;
					_paused = false;

				// defer to subclass
					dispatchEvent(new MediaEvent(MediaEvent.STOPPED));
					_stop();
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
			
			// TODO replace ALL these with a single VideoSettings object that can be passed around
		
			public function get quality():int { return _quality; }
			public function set quality(value:int):void 
			{
				_quality = value;
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
			
			public function get ready():Boolean { return webcam.ready; }
			
			public function get webcam():Webcam { return _webcam; }
			
			public function get camera():Camera { return _camera; }
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function _record(append:Boolean = false):void
			{
				throw new ImplementationError('set up the recoding process');
			}
			
			protected function _pause():void 
			{
				throw new ImplementationError('pause the recording');
			}
		
			protected function _resume():void 
			{
				throw new ImplementationError('resume the recording');
			}
		
			protected function _stop():void 
			{
				throw new ImplementationError('finalize (such as flushing or encoding) the recording');
			}
		
			protected function _onRecordComplete():void 
			{
				throw new ImplementationError('clean up after recording');
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
					
			protected function onCameraSizeChange(event:CameraEvent):void 
			{
				_videoWidth		= webcam.camera.width;
				_videoHeight	= webcam.camera.height;
				_fps			= webcam.camera.fps;
			}
			
			protected function onRecordComplete():void
			{
				_onRecordComplete();
			}

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			override public function toString():String 
			{
				return '[object VideoRecorder videoWidth="' +videoWidth + '" videoHeight="' +videoHeight + '" fps="' +fps + '" quality="' +quality + '" bandwidth="' +bandwidth + '"]';
			}
			
			// get the greatest common divisor
			protected function gcd (a:Number, b:Number):Number
			{
				return (b == 0) ? a : gcd (b, a%b);
			}
		
	}

}

