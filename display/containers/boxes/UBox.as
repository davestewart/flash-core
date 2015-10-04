package core.display.containers.boxes 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import core.display.containers.Container;
	import core.display.elements.Element;
	
	/**
	 * Universal Box
	 * 
	 * Base class for other box / layout classes to inherit from
	 * 
	 * Provides access to padding (edge) and spacing (between children)
	 * 
	 * @author Dave Stewart
	 */
	public class UBox extends Container
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// stage intances
				
			
			// variables
				protected var _spacing		:int;
				protected var _padding		:int;
				
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function UBox(parent:DisplayObjectContainer = null, spacing:int = 3, padding:int = 0) 
			{
				// super
				super(parent);
				
				// properties
				_spacing = spacing;
				_padding = padding;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get spacing():int { return _spacing; }
			public function set spacing(value:int):void 
			{
					_spacing = value;
					invalidate();
				if (value >= 0)
				{
				}
			}
			
			public function get padding():int { return _padding; }			
			public function set padding(value:int):void 
			{
				if (value >= 0)
				{
					_padding = value;
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