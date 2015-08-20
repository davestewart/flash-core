package core.media.video 
{
	import core.data.settings.CameraSettings;
	import core.errors.ImplementationError;
	import core.events.CameraEvent;
	import core.events.MediaEvent;
	import core.media.camera.Webcam;
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
				
			// variables
								
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoRecorder(width:int = 320, height:int = 180)
			{
				super(width, height);
			}
		
			override protected function build():void 
			{
				// super
				super.build();
				
				// settings
				flipped				= true;
				_settings			= new CameraSettings(video.width, video.height, 25);
				
				// camera
				_webcam				= new Webcam(settings, video);
				webcam.addEventListener(CameraEvent.NO_CAMERA, onNoCamera);
				webcam.addEventListener(CameraEvent.ACTIVATED, onCameraActivated);
				webcam.addEventListener(CameraEvent.NOT_ACTIVATED, onCameraActivated);
				webcam.addEventListener(CameraEvent.ATTACHED, onVideoAttached);
				webcam.addEventListener(CameraEvent.SIZE_CHANGE, onCameraSizeChange);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: camera methods
		
			/**
			 * Attaches the camera to the video
			 * 
			 * This runs the async process of asking the user for permission to use the camera.
			 * 
			 * onCameraActivated() is fired when the user allows or denies the camera
			 */
			public function start():Boolean 
			{
				return webcam.start();
			}
			
			/**
			 * Sets the size of the camera mode (which also sets the size of the video)
			 * 
			 * @param	width
			 * @param	height
			 */
			public function setCameraSize(width:Number, height:Number, fps:int = 25):void 
			{
				// set camera settings
				webcam.settings.width	= width;
				webcam.settings.height	= height;
				webcam.settings.fps		= fps;
				webcam.update();
				
				// update video
				setVideoSize(width, height);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function record(append:Boolean = false):Boolean
			{
				// exit early if camera is not available
					if ( ! webcam.ready )
					{
						dispatchEvent(new MediaEvent(MediaEvent.ERROR, 'unable to record, as there is no camera available'));
						return false;
					}
					
				// debug
					trace('Recording...');
					
				// events
					dispatch(MediaEvent.RECORDING);
					dispatch(MediaEvent.STARTED);
					
				// defer to subclass
					_record(append);
				
				// return
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
				log('webcam: there is no camera!');
			}

			protected function onCameraActivated(event:CameraEvent):void 
			{
				log('status: ' + event.type);
				log('webcam: ' + webcam);
			}
			
			protected function onVideoAttached(event:CameraEvent):void 
			{
				log('webcam: video attached ok');
				dispatch(MediaEvent.READY);
			}
			
			protected function onCameraSizeChange(event:CameraEvent):void 
			{
				// need to update this so it mintains aspect ratio
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

