package core.net 
{
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class NetStreamClient 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var _onPlayStatus		:Function;
				protected var _onMetaData		:Function;
				protected var _onCuePoint		:Function;
				
				
			// variables
				
	
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function NetStreamClient(onPlayStatus:Function, onMetaData:Function, onCuePoint:Function = null)
			{
				_onPlayStatus	= onPlayStatus;
				_onMetaData		= onMetaData;
				_onCuePoint		= onCuePoint;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function onPlayStatus(event:Object) :void
			{
				_onPlayStatus(event);
			}						
			
			public function onMetaData(data:Object) :void
			{
				_onMetaData(data);
			}
					
			public function onCuePoint(data:Object) :void
			{
				_onCuePoint(data);
			}
					
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}