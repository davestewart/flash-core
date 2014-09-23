package core.display.elements 
{
	import core.display.shapes.Square;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class HitArea extends Sprite 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				public var area		:Square;
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function HitArea(width:Number, height:Number, x:Number = 0, y:Number = 0)
			{
				graphics.beginFill(0xFF0000, 1);
				graphics.drawRect(x, y, width, height);
				//visible		= false;
				name		= '_hitarea';
			}
			
			public static function from(element:DisplayObjectContainer, padding:Number = 5, parent:DisplayObjectContainer = null):HitArea
			{
				// get bounds
					var bounds	:Rectangle	= element.getBounds(element);
					
				// build the hit area
					var hitArea	:HitArea	= new HitArea(bounds.width + (padding * 2), bounds.height + (padding * 2), bounds.x - padding, bounds.y - padding);
					
				// set up the source element
					(parent || element).addChildAt(hitArea, 0);
					element.mouseChildren	= false;
					
				// return
					return hitArea;
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