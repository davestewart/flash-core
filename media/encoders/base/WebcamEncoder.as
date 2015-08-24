package core.media.encoders.base 
{
	import flash.media.Camera;
	import flash.media.Microphone;
	
	import core.media.camera.Webcam;
	import core.media.encoders.base.VideoEncoder;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class WebcamEncoder extends VideoEncoder 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// source properties
				protected var _camera			:Camera;
				protected var _microphone		:Microphone;
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function WebcamEncoder() 
			{
				super();			
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			/**
			 * Assigns the input (always a camera) object
			 */
			override public function set input(value:*):void 
			{
				// properties
				_input		= value;
				
				// inputs
				if (value is Camera)
				{
					camera		= value;
				}
				else if (value is Webcam)
				{
					camera		= (value as Webcam).camera;
					_microphone	= (value as Webcam).microphone;
				}
				else
				{
					throw new TypeError('The assigned input must be a flash.media.Camera or core.media.camera.Webcam instance');
				}
			}
			
			public function get camera():Camera { return _camera; }
			public function set camera(value:Camera):void 
			{
				_camera = value;
				_source	= value;
			}
			
			public function get microphone():Microphone { return _microphone; }
			public function set microphone(value:Microphone):void 
			{
				_microphone = value;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}