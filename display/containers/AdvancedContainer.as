package core.display.containers 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * Base class for advanced containers that require visual debugging
	 * 
	 * @author Dave Stewart
	 */
	public class AdvancedContainer extends Container 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var _debug		:Boolean;
				
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function AdvancedContainer(parent:DisplayObjectContainer = null)
			{
				super(parent);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get debug():Boolean { return _debug; }
			public function set debug(value:Boolean):void 
			{
				_debug = value;
				invalidate();
			}
				
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function draw():void 
			{
				super.draw();
				_debug
					? drawDebug()
					: clearDebug();
				
			}
		
			protected function drawDebug():void 
			{
				// render layout information / trace debug info
			}
			
			protected function clearDebug():void 
			{
				// clear render layout information
				graphics.clear();
			}
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}