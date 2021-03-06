package core.display.elements 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Invalidatable extends Sprite
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Invalidatable() 
			{
				
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: drawing methods
		
			public function invalidate():void 
			{
				addEventListener(Event.ENTER_FRAME, onInvalidate);
			}
		
			public function redraw():void
			{
				draw();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function draw():void 
			{
				// override in subclass
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onInvalidate(event:Event):void 
			{
				removeEventListener(Event.ENTER_FRAME, onInvalidate);
				draw();
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}