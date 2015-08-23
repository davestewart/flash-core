package core.media.net 
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
				
				
			// variables
				
	
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function NetStreamClient(onPlayStatus:Function, onMetaData:Function)
			{
				_onPlayStatus	= onPlayStatus;
				_onMetaData		= onMetaData;
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