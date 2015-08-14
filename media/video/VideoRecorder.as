package core.media.video 
{
	import core.data.settings.CameraSettings;
	import core.errors.ImplementationError;
	import core.events.CameraEvent;
	import core.events.MediaEvent;
	import core.media.camera.Webcam;
	import core.media.camera.WebcamWarning;
	import flash.net.NetConnection;
	
	/**
	 * Instantiates a basic NetStreamVideo, then manages camera and publish locations
	 * 
	 * @author Dave Stewart
	 */
	public class VideoRecorder extends VideoBase 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// properties
				protected var _webcam					:Webcam;
				protected var _settings					:CameraSettings;
				protected var warning					:WebcamWarning;
								
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoRecorder(width:int = 320, height:int = 180, connection:NetConnection = null)
			{
				super(width, height);
			}
		
			override protected function initialize():void 
			{
				// video
				flipped						= true;
				
				// settings
				_settings					= new CameraSettings();
				settings.width				= 640;
				settings.height				= 360;
				settings.fps				= 15;
				settings.quality			= 90;
				settings.format				= 'mp4';
				settings.bandwidth			= 0;
				settings.keyframeInterval	= 15;
				
				// camera
				_webcam						= new Webcam(settings);
				webcam.addEventListener(CameraEvent.NO_CAMERA, onNoCamera);
				webcam.addEventListener(CameraEvent.ACTIVATED, onCameraActivated);
				webcam.addEventListener(CameraEvent.NOT_ACTIVATED, onCameraActivated);
				webcam.addEventListener(CameraEvent.SIZE_CHANGE, onCameraSizeChange);
			}
			
			override protected function build():void 
			{
				super.build();
				warning = new WebcamWarning(this);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: camera methods
		
			/**
			 * Attaches the camera to the video
			 * 
			 * This runs the async process of asking the user for permission to use the camera.
			 * 
			 * When the user chooses, the onCameraActivated() event fires
			 */
			public function startCamera():void 
			{
				video.attachCamera(webcam.camera);
			}
			
			public function stopCamera():void
			{
				video.attachCamera(null);
				warning.hide();
				clear();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function record(append:Boolean = false):Boolean
			{
				// debug
					trace('Recording...');
					
				// exit early if camera is not available
					if ( ! webcam.available )
					{
						dispatchEvent(new CameraEvent(CameraEvent.NOT_ACTIVATED));
						return false;
					}
					
				// event
					dispatch(MediaEvent.STARTED);
					
				// defer to subclass
					_record(append);
				
				// return
					return true;
			}
			
			public function pause():Boolean 
			{
				dispatch(MediaEvent.PAUSED);
				_pause();
				return true;
				
			}

			public function stop():Boolean
			{
				dispatch(MediaEvent.STOPPED);
				_stop();
				return true;
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get webcam():Webcam { return _webcam; }

			public function get settings():CameraSettings { return _settings; }
			
			public function get ready():Boolean { return webcam.ready; }
			
			
			
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
					
			protected function onNoCamera(event:CameraEvent):void 
			{
				log('there is no camera!');
			}

			protected function onCameraActivated(event:CameraEvent):void 
			{
				log('status: ' + event.type);
				log('webcam: ' + webcam);
				
				warning.show();

				if (webcam.available)
				{
					//startCamera();
				}
			}
			
			protected function onCameraSizeChange(event:CameraEvent):void 
			{
				if (autosize)
				{
					width		= webcam.camera.width;
					height		= webcam.camera.height;
				}
			}
			
			protected function onRecordComplete():void
			{
				_onRecordComplete();
			}

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function dispatch(eventName:String, data:* = null):void 
			{
				dispatchEvent(new MediaEvent(eventName, data, true));
			}
		
			override public function toString():String 
			{
				return '[object VideoRecorder camera.width="' +settings.width + '" camera.height="' +settings.height+ '" fps="' +settings.fps + '" quality="' +settings.quality + '" bandwidth="' +settings.bandwidth + '"]';
			}
			
	}

}

// debug
function log(...rest):void 
{
	trace('VideoRecorder: ' , rest);
}

