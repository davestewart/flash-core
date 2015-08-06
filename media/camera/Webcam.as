package core.media.camera 
{
	import core.data.settings.VideoSettings;
	import flash.events.EventDispatcher;
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
	import flash.media.Video;
	import flash.media.VideoStreamSettings;
	import flash.net.NetConnection;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import flash.external.ExternalInterface;
	import core.events.CameraEvent;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Webcam extends EventDispatcher 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// objects
				protected var _camera				:Camera;
				protected var _microphone			:Microphone;
				protected var _video				:Video;
													
			// properties                       	
				protected var _settings				:VideoSettings;
				protected var _ready				:Boolean;
				protected var _available			:Boolean;
													
			// variables                        	
				protected var _setup				:Boolean;
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Webcam(video:Video, start:Boolean = true) 
			{
				_video = video;
				if (start)
				{					
					setup();
				}
				
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function update():void
			{
				/*
				if (camera)
				{
					// keyframes
						camera.setKeyFrameInterval(keyframeInterval);
						
					// size
						
						// Detect aspect ratio supported by webcam
						//
						// camera.setMode(4000, 2250, 25);
				        // 
						// var camWidth:Number = camera.width;
						// var camHeight:Number = camera.height;
						// var ratio:Number = gcd (camWidth, camHeight);
						// var aspectRatio:String = camWidth / ratio +":" + camHeight / ratio;
						// 
						// trace("Camera dimensions = ", camWidth, "x", camHeight);
						// trace("Camera aspect ratio = ", aspectRatio);
						// 
						// if (aspectRatio == "16:9")
						// 	camera.setMode(1280, 720, 25);
						// else
						// 	camera.setMode(640, 480, 25);
						//
						
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
						_videoWidth		= camera.width;
						_videoHeight	= camera.height;
						_fps			= camera.fps;
						
					// debug
						//trace('props:', videoWidth, videoHeight, bandwidth, quality, fps, keyframeInterval);
						//trace('rate:', rate);
						
					// event
						dispatchEvent(new CameraEvent(CameraEvent.SIZE_CHANGE));
				}
				*/
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get camera():Camera { return _camera; }
			
			public function get microphone():Microphone { return _microphone; }
			
			public function get video():Video { return _video; }
			
			/**
			 * A camera is available
			 */
			public function get available():Boolean { return _available; }
			
			/**
			 * The camera is ready for use
			 */
			public function get ready():Boolean { return _ready; }
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function setup():void
			{	
				// don't set up twice!
					if (_setup) return;
					
				// debug
					trace('setup camera...');
				
				// get the default Flash camera and microphone
					_camera = Camera.getCamera();
					
				// here are all the quality and performance settings
					if(camera != null)
					{
						// attach video
							video.attachCamera(camera);

						// test to see if camera can be activated
							setTimeout(test, 500);
							
						// update camera
							update();
					}
					else
					{
						trace('No Camera Found');
						dispatchEvent(new CameraEvent(CameraEvent.NO_CAMERA));
					}
					
				// set up the mic
					_microphone = Microphone.getMicrophone();
					if( microphone != null)
					{
						microphone.rate = 11;
						microphone.setSilenceLevel(0, -1); 
					}
					else
					{
						trace('No Microphone Found', 'error');
						dispatchEvent(new CameraEvent(CameraEvent.NO_MICROPHONE));
					}

				// flag as already set up
					_available = true;
					_ready = true;
					_setup = true;
			}
			
			protected function test():void
			{
				// debug
					trace('testing for camera...');
				
				// detect inactivity if another application is using the camera
					camera.addEventListener(ActivityEvent.ACTIVITY, onCameraActivity);
							
				// set up mousemove handler to detect when the dialog has been dismissed
					var moves:int = 0;
					if (video.stage)
					{
						video.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					}
					else
					{
						video.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
					}
			}
		

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onCameraActivity(event:ActivityEvent):void 
			{
				_available = true;
				trace('camera activated successfully!');
				camera.removeEventListener(ActivityEvent.ACTIVITY, onCameraActivity);
				dispatchEvent(new CameraEvent(CameraEvent.ACTIVATED));
			}
		
			protected function onMouseMove(event:MouseEvent):void 
			{
				trace('mouse moved, checking for camera activation');
				video.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				setTimeout(onActivationCheckTimeout, 1000);
			}
			
			protected function onActivationCheckTimeout():void
			{
				if ( ! _available )
				{
					trace('could not activate camera!');
					dispatchEvent(new CameraEvent(CameraEvent.NOT_ACTIVATED));
				}
			}
			
			protected function onAddedToStage(event:Event):void 
			{
				trace('camera added to stage');
				video && video.stage && video.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
				
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}