package core.geom 
{
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Size 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				public var width		:Number;
				public var height		:Number;
				
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Size(width:Number = 0, height:Number = 0) 
			{
				this.width	= width;
				this.height	= height;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function equals(size:Size):Boolean 
			{
				return this.width === size.width && this.height == size.height;
			}
			
			public function clone(scale:Number = 1):Size
			{
				return new Size(width * scale, height * scale);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get area():Number
			{
				return width * height;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			public function toString():String 
			{
				return '[object Size width="' +width + '" height="' +height + '"]';
			}
		
	}

}