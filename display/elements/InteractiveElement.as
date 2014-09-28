package core.display.elements 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class InteractiveElement extends Element 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function InteractiveElement(element:DisplayObject = null, parent:DisplayObjectContainer = null)
			{
				if (element)
				{
					setElement(element)
				}
				super(parent);
			}
		
			override protected function initialize():void 
			{
				buttonMode		= true;
				useHandCursor	= true;
				mouseChildren	= false;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function setElement(element:DisplayObject):void 
			{
				// move to element location
					x					= element.x;
					y					= element.y;
					rotation			= element.rotation;
					if (element.parent)
					{
						var index:int = element.parent.getChildIndex(element);
						element.parent.addChildAt(this, index);
					}
					
				// reset element
					element.x			= 0;
					element.y			= 0;
					element.rotation	= 0;
					addChild(element);
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