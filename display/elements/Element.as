package core.display.elements 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Element extends Invalidatable
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// stage intances
				
			
			// variables
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			/**
			 * 
			 * @param	parent		An optional parent to attach to
			 */
			public function Element(parent:DisplayObjectContainer = null) 
			{
				// add to stage
				if (parent)
				{
					parent.addChild(this);
				}
				
				// properties
				blendMode = BlendMode.LAYER;
				
				// build
				initialize();
				build();
			}
		
			protected function initialize():void 
			{
				// override in subclass
			}
			
			protected function build():void 
			{
				// override in subclass
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: display methods
		
			public function move(x:Number, y:Number):void 
			{
				this.x = x;
				this.y = y;
			}
		
			public function show():void
			{
				visible = true;
			}
		
			public function hide():void
			{
				visible = false;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: children methods
		
			override public function addChild(child:DisplayObject):DisplayObject 
			{
				invalidate();
				return super.addChild(child);
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

