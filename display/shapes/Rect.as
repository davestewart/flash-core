package core.display.shapes 
{
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Rect extends Shape 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var _width		:Number;
				protected var _height		:Number;
				protected var _color		:Number;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Rect(width:int = 100, height:int = 100, color:int = 0x00FF00, alpha:Number = 1) 
			{
				// parameters
					_width		= width;
					_height		= height;
					_color		= color;
					
				// display
					this.alpha	= alpha;
					draw();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			override public function set width(value:Number):void 
			{
				_width = value;
				draw();
			}
			
			override public function set height(value:Number):void 
			{
				_height = value;
				draw();
			}
			
			public function set color(value:Number):void 
			{
				_color = value;
				draw();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function draw():void 
			{
				graphics.clear();
				graphics.beginFill(_color);
				graphics.drawRect(0, 0, _width, _height);
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}