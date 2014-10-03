package core.managers 
{
	import core.events.CameraEvent;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.utils.setTimeout;

	
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class CameraManager extends EventDispatcher 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// elements
				
				
			// properties
				public var camera			:Camera;
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function CameraManager(target:flash.events.IEventDispatcher = null) 
			{
				super(target);
				initialize();
			}
		
			protected function initialize():void 
			{
				
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			protected function setup():void
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
					trace('testing for camera...');
				
				// detect inactivity if another application is using the camera
					camera.addEventListener(ActivityEvent.ACTIVITY, onCameraActivity);
							
				// set up mousemove handler to detect when the dialog has been dismissed
					var moves:int = 0;
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
					// keyframes
						camera.setKeyFrameInterval(keyframeInterval);
						
					// size
						
						// Detect aspect ratio supported by webcam
						/*
						camera.setMode(4000, 2250, 25);
				
						var camWidth			:Number = camera.width;
						var camHeight			:Number = camera.height;
						var ratio				:Number = gcd (camWidth, camHeight);
						var aspectRatio			:String = camWidth / ratio +":" + camHeight / ratio;
						
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
						_videoWidth		= camera.width;
						_videoHeight	= camera.height;
						_fps			= camera.fps;
						
					// debug
						//trace('props:', videoWidth, videoHeight, bandwidth, quality, fps, keyframeInterval);
						//trace('rate:', rate);
						
					// event
						dispatchEvent(new CameraEvent(CameraEvent.SIZE_CHANGE));
				}
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
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
				setTimeout(onActivationCheckTimeout, 1000);
			}
			
			function onActivationCheckTimeout():void
			{
				if ( ! _available )
				{
					trace('could not activate camera!');
					dispatchEvent(new CameraEvent(CameraEvent.NOT_ACTIVATED));
				}
			}
			
			function onAddedToStage(event:Event):void 
			{
				trace('camera added to stage');
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}