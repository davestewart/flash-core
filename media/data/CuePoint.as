package core.media.data 
{
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class CuePoint 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			///  a string that specifies the type of cue point as either "navigation" or "event".
			public var type			:String;

			///  a string that is the name of the cue point.
			public var name			:String;

			///  a number that is the time of the cue point in seconds with a precision of three decimal places (milliseconds).
			public var time			:Number;

			///  an optional object that has name-value pairs that are designated by the user when creating the cue points.
			public var parameters	:Object;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function CuePoint(values:Object) 
			{
				for (var name:String in values)
				{
					this[name] = values[name];
				}
			}
		
	}

}