package core.media.data 
{
	/**
	 * @author Dave Stewart
	 */
	dynamic public class VideoMetadata extends Metadata
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			/// A number that is the width of the FLV file, in pixels.
			public var width			:int;

			/// A number that is the height of the FLV file, in pixels.
			public var height			:int;

			/// A number that specifies the duration of the video file, in seconds.
			public var duration			:Number;

			/// A number that is the frame rate of the FLV file.
			public var framerate		:int;

			/// A description of the file
			public var description		:String;
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoMetadata(data:Object) 
			{
				super(data);
				if ('frameWidth' in data)
				{
					width		= int(data.frameWidth);
					height		= int(data.frameHeight);
				}
				else if ('width' in data)
				{
					width		= int(data.width);
					height		= int(data.height);
				}
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods

			
	}

}