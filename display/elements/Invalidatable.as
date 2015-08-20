package core.display.elements 
{
	import flash.display.Sprite;
	import app.display.panels.FormPanel;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
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
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: drawing methods
		
			public function redraw():void
			{
				draw();
			}
			
			public function invalidate():void 
			{
				addEventListener(Event.ENTER_FRAME, onInvalidate);
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
			
			protected function onAddedToStage(event:Event):void 
			{
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				onInvalidate(null);
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}