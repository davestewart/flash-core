package core.media.video 
{
	import core.data.settings.CameraSettings;
	import core.events.CameraEvent;
	import core.events.MediaEvent;
	import core.media.camera.Webcam;
	
	/**
	 * Starts a webcam and attaches it to the video
	 * 
	 * @author Dave Stewart
	 */
	public class WebcamVideo extends VideoBase 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// properties
				protected var _webcam					:Webcam;
				protected var _settings					:CameraSettings;
				
			// variables
								
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function WebcamVideo(width:int = 320, height:int = 180)
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
				_webcam.addEventListener(CameraEvent.NO_CAMERA, onCameraEvent);
				_webcam.addEventListener(CameraEvent.ACTIVATED, onCameraEvent);
				_webcam.addEventListener(CameraEvent.NOT_ACTIVATED, onCameraEvent);
				_webcam.addEventListener(CameraEvent.ATTACHED, onCameraEvent);
				_webcam.addEventListener(CameraEvent.SIZE_CHANGE, onCameraEvent);				
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
		
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get webcam():Webcam { return _webcam; }

			public function get settings():CameraSettings { return _settings; }
			
			public function get ready():Boolean { return webcam.ready; }
			
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onCameraEvent(event:CameraEvent):void 
			{
				// forward all events
				dispatchEvent(event);
				
				// take action
				switch(event.type)
				{
					case CameraEvent.NO_CAMERA:
						log('webcam: there is no camera!');
						break;
					
					case CameraEvent.ACTIVATED:
					case CameraEvent.NOT_ACTIVATED:
						log('status: ' + event.type);
						log('webcam: ' + webcam);
						break;
					
					case CameraEvent.ATTACHED:
						log('webcam: video attached ok');
						dispatch(MediaEvent.READY);
						break;
					
					case CameraEvent.SIZE_CHANGE:
						if (autosize)
						{
							// need to update this so it mintains aspect ratio (did I do this?)
							width		= webcam.camera.width;
							height		= webcam.camera.height;
						}
						break;
					
					default:
						
				}
			}
					
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			override public function toString():String 
			{
				return '[object WebcamVideo camera.width="' +settings.width + '" camera.height="' +settings.height+ '" fps="' +settings.fps + '" quality="' +settings.quality + '" bandwidth="' +settings.bandwidth + '"]';
			}
			
	}

}