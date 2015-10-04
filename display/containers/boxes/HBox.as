package core.display.containers.boxes 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	/**
	 * Horizontal Box
	 * 
	 * Lays out children horizontally
	 * 
	 * @author Dave Stewart
	 */
	public class HBox extends DBox 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// stage intances
				
			
			// variables
				
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function HBox(parent:DisplayObjectContainer, spacing:int = 3, elements:Array = null) 
			{
				super(parent, 'x', spacing);
				addChildren(elements);
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			override public function get rect():Rectangle 
			{
				return new Rectangle(content.x, content.y, _wrap ? _size - (padding * 2) : content.width, content.height); 
			}
		
			override public function get width():Number 
			{
				return _wrap 
						? _size 
						: content.width + (_padding * 2);
			}
			
			override public function set width(value:Number):void 
			{
				if (value - (padding * 2) >= 0)
				{
					_size = value;
					_wrap = true;
					invalidate();
				}
			}
			
			public function get innerWidth():Number
			{
				return _wrap
						? _size - (padding * 2)
						: content.width;
			}
			
			public function set innerWidth(value:Number):void 
			{
				if (value >= 0)
				{
					_size = value + (padding * 2);
					_wrap = true;
					invalidate();
				}
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}