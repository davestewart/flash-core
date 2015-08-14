package core.media.camera 
{
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.utils.setTimeout;
	
	import core.data.settings.CameraSettings;
	
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
													
			// properties                       	
				protected var _settings				:CameraSettings;
				
			// flags
				protected var _started				:Boolean;
				protected var _available			:Boolean;
				protected var _ready				:Boolean;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Webcam(settings:CameraSettings) 
			{
				_settings = settings;
				initialize();
			}
			
			/**
			 * Sets up listeners to configure the camera when the user has given permission
			 * 
			 * Called on class start
			 */
			protected function initialize ():void 
			{
				if ( ! _started )
				{
					// get camera
					_started	= true;
					_camera		= Camera.getCamera();
					
					// no camera
					if (_camera )
					{
						log('available');
						
						// available
						_available	= true;

						// events
						//_camera.addEventListener(ActivityEvent.ACTIVITY, onCameraActivity, false, 0, true);
						//_camera.addEventListener(Event.VIDEO_FRAME, onVideoFrame, false, 0, true);
						
						// this will always be muted on the first go, as the permissions dialog needs to show
						if (_camera.muted)
						{
							_camera.addEventListener(StatusEvent.STATUS, onCameraStatus, false, 0, true);
						}
						
						// if the user has previously given the camera permissions, I assume this runs
						else
						{
							setup();
						}
					}
					
					// camera
					else
					{
						log('no camera');
						dispatchEvent(new CameraEvent(CameraEvent.NO_CAMERA));
						return;
					}
				}
			}
			
			/**
			 * Sets up the camera & microphone and flags complete
			 * 
			 * Called when the camera has been activated
			 */
			protected function setup():void
			{
				// debug
					log('setup');
					
				// set up the mic (this currently does nothing
					/*
					// @see http://help.adobe.com/en_US/as3/dev/WS5b3ccc516d4fbf351e63e3d118a9b90204-7d1d.html
					_microphone = Microphone.getMicrophone();
					if( microphone != null)
					{
						microphone.rate = 11;
						microphone.setSilenceLevel(0, -1);
						//microphone.setLoopBack(true);
					}
					else
					{
						log('No Microphone Found', 'error');
						dispatchEvent(new CameraEvent(CameraEvent.NO_MICROPHONE));
					}
					*/

				// flag ready
					_ready		= true;
					
				// dispatch a ready event
					dispatchEvent(new CameraEvent(CameraEvent.ACTIVATED));
					
				// update
					update();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function update():void
			{
				if (camera)
				{
					// keyframes
						camera.setKeyFrameInterval(settings.keyframeInterval);
						
					// size
						
						// Detect aspect ratio supported by webcam
						camera.setMode(4000, 2250, 25);
						var camWidth		:Number		= camera.width;
						var camHeight		:Number		= camera.height;
						var ratio			:Number		= gcd (camWidth, camHeight);
						var aspectRatio		:String		= camWidth / ratio +":" + camHeight / ratio;
						
						// debug
						log("Camera dimensions = ", camWidth, "x", camHeight);
						log("Camera aspect ratio = ", aspectRatio);
						
						// set mode according to spect ratio
						if (aspectRatio == "16:9")
							camera.setMode(640, 360, 25);
						else
							camera.setMode(640, 480, 25);
						
						// forcing the camera to 4:3 fixes green stripe issue
						// camera.setMode(640, 480, 25);
						if (camera.width < _settings.width)
						{
							camera.setMode(settings.width, settings.height, settings.fps);
							dispatchEvent(new CameraEvent(CameraEvent.SIZE_ERROR));
							log('The camera could not be set to the required size!');
						}
						/*
						*/
						
					// variables
						var rate:int = camera.width * camera.height; // alternative bandwidth
						
					// quality
						camera.setQuality(settings.bandwidth, settings.quality);
						
					// update settings with new values
						settings.width		= camera.width;
						settings.height		= camera.height;
						settings.fps		= camera.fps;
						
					// debug
						log('props:', settings.width, _settings.height, settings.bandwidth, settings.quality, settings.fps, settings.keyframeInterval);
						//log('rate:', rate);
						
					// event
						dispatchEvent(new CameraEvent(CameraEvent.SIZE_CHANGE));
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get camera():Camera { return _camera; }
			
			public function get microphone():Microphone { return _microphone; }
			
			public function get settings():CameraSettings { return _settings; }
			
			/// The camera has attempted to be started (Flash only gives one go at this)
			public function get started():Boolean { return _started; }

			/// A camera is available
			public function get available():Boolean { return _available; }
			
			/// The camera is ready for use
			public function get ready():Boolean { return _ready; }
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onCameraStatus(event:StatusEvent):void 
			{
				log('camera status');
				switch (event.code)
				{
					case 'Camera.Muted':
					{
						_ready = false;
						dispatchEvent(new CameraEvent(CameraEvent.NOT_ACTIVATED));
						break;
					}
					case 'Camera.Unmuted':
					{
						setup();
						break;
					}
				}
			}
		
			protected function onCameraActivity(event:ActivityEvent):void 
			{
				/*
				log('activity, '+ event);
				_available = true;
				log('camera activated successfully!');
				camera.removeEventListener(ActivityEvent.ACTIVITY, onCameraActivity);
				dispatchEvent(new CameraEvent(CameraEvent.ACTIVATED));
				*/
			}
				
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			override public function toString():String 
			{
				return '[object WebCam started="' +started+ '" available="' +available+ '" ready="' +ready+ '" ]';
			}
		
	}

}

// debug
function log(...rest):void 
{
	trace('WebCam: ' , rest.join(' '));
}

// get the greatest common divisor
function gcd (a:Number, b:Number):Number
{
	return (b == 0) ? a : gcd (b, a % b);
}

