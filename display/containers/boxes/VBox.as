package core.display.containers.boxes 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	/**
	 * Vertical Box
	 * 
	 * Lays out chlidren vertically
	 * 
	 * @author Dave Stewart
	 */
	public class VBox extends DBox 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// stage intances
				
			
			// variables
				
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VBox(parent:DisplayObjectContainer, spacing:int = 3, elements:Array = null) 
			{
				super(parent, 'y', spacing);
				addChildren(elements);
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			override public function get rect():Rectangle
			{
				return new Rectangle(content.x, content.y, content.width, _wrap ? _size - (padding * 2) : content.height); 
			}
			
			override public function get height():Number 
			{
				return _wrap 
						? _size 
						: content.height + (_padding * 2);
			}
			
			override public function set height(value:Number):void 
			{
				if (value - (padding * 2) >= 0)
				{
					_size = value;
					_wrap = true;
					invalidate();
				}
			}
			
			public function get innerHeight():Number
			{
				return _wrap
					? _size - (padding * 2)
					: content.height;
			}
			
			public function set innerHeight(value:Number):void 
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