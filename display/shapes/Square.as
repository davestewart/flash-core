package core.display.shapes 
{
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Square extends Shape 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Square(width:int = 100, height:int = 100, color:int = 0x00FF00, alpha:Number = 1) 
			{
				// graphics
					graphics.beginFill(color);
					graphics.drawRect(0, 0, 100, 100);
					
				// display
					this.alpha		= alpha;
					this.width		= width;
					this.height		= height;
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
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