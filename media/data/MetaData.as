package core.media.data 
{
	/**
	 * @author Dave Stewart
	 */
	dynamic public class MetaData 
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
			
			// store original values
			protected var _data		:Object;

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function MetaData(data:Object) 
			{
				_data = data;
				initialize();
			}
			
			protected function initialize():void 
			{
				for (var name:String in _data)
				{
					this[name] = _data[name];
				}				
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function getData()
			{
				return _data;
			}
	}

}