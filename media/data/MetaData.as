package core.media.data 
{
	/**
	 * @author Dave Stewart
	 */
	dynamic public class Metadata 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
					
			// store original values
			protected var _data			:Object;

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Metadata(data:Object) 
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
		
			public function getData():*
			{
				return _data;
			}
	}

}