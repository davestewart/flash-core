package core.display.components 
{
	import core.display.elements.Element;
	import core.display.shapes.Rect;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class ProgressBar extends Element 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				public var bg	:Rect;
				public var fg	:Rect;
				
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function ProgressBar(parent:DisplayObjectContainer = null, width:Number = 100, height:Number = 10)
			{
				// super
				super(parent);
				
				// size
				this.width	= width;
				this.height	= height;
				
				// property
				value			= 0;
			}
			
			override protected function build():void 
			{
				bg = new Rect(100, 10, 0xEEEEEE);
				addChild(bg);
				fg = new Rect(100, 10, 0x666666);
				addChild(fg);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function get width():Number { return super.width; }
			override public function set width(value:Number):void 
			{
				fg.width	= value;
				bg.width	= value;
			}
			
			override public function get height():Number { return super.height; }
			override public function set height(value:Number):void 
			{
				fg.height	= value;
				bg.height	= value;
			}
		
			public function get value():Number { return fg.scaleX; }
			public function set value(value:Number):void 
			{
				fg.scaleX	= value;
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