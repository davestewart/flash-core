package core.display.containers 
{
	import core.display.elements.Element;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class HBox extends Element 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// stage intances
				
			
			// variables
				protected var _spacing:int;
				
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function HBox(parent:DisplayObjectContainer, spacing:int = 3, elements:Array = null) 
			{
				super(parent);
				_spacing = spacing;
				if (elements)
				{
					for (var i:int = 0; i < elements.length; i++) 
					{
						addChild(elements[i]);
					}
				}
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function draw():void 
			{
				// super
					super.draw();
				
				// variables
					var child		:DisplayObject;
					var lastChild	:DisplayObject;

				// align elements
					for (var i:int = 1; i < numChildren; i++)
					{
						child		= getChildAt(i);
						lastChild	= getChildAt(i - 1);
						child.x		= lastChild.x + lastChild.width + _spacing;
					}
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}