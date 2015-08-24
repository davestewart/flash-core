package core.media.encoders.base 
{
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoEncoder extends Encoder 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var _format					:String;
				protected var allowedFormats			:Array;
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoEncoder() 
			{
				// super
				super();
				
				// properties
				allowedFormats	= ['mp4'];
				_format			= 'mp4';
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get format():String { return _format; }
			public function set format(value:String):void 
			{
				if (allowedFormats.lastIndexOf(value) > -1)
				{
					_format = value;
				}
				else
				{
					throw new Error('Invalid video format "' +value+ '"');
				}
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}