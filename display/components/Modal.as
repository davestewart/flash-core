package core.display.components 
{
	import core.display.elements.Element;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Modal extends Element 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				public static var instance:Modal;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: static
		
			static public function create(parent:DisplayObjectContainer):Modal 
			{
				instance = new Modal(parent);
				return instance;
			}
			
			static public function show(element:DisplayObject):void 
			{
				instance.update(element);
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Modal(parent:DisplayObjectContainer = null)
			{
				super(parent);
			}
			
			override protected function build():void 
			{
				// add stage resize listener
				
				// build bg
				
				// add bg close listener
				
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function update(element:DisplayObject):void 
			{
				// remove old children
				
				// add new child
				
				// draw
				
				// show
			}
			
			override public function hide():void 
			{
				// hide
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function draw():void 
			{
				if (parent)
				{
					// resize, center
				}
			}
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onResize(event:Event):void 
			{
				draw();
			}
			
			protected function onClose():void 
			{
				hide();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}