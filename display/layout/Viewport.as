package core.display.layout 
{
	import core.display.layout.Container;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import core.display.elements.Invalidatable;
	import core.display.shapes.Rect;
	import core.utils.Elements;
	
	/**
	 * Visual wrapper class 
	 * 
	 * @author Dave Stewart
	 */
	public class Viewport extends Container 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				public static const COVER	:String			= 'cover';
				public static const FIT		:String			= 'fit';
				public static const SCALE	:String			= 'scale';
				public static const NONE	:String			= 'none';
				
			// elements
				protected var viewport		:Rect;
				
			// properties
				protected var _mode			:String;
				protected var _crop			:Boolean;
				protected var _align		:String;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Viewport(width:uint = 320, height:uint = 180, mode:String = COVER, crop:Boolean = true) 
			{
				// super
				super();
				
				// viewport
				viewport			= new Rect(width, height);
				viewport.visible	= false;
				viewport.name		= 'viewport';
				_addChild(viewport);
				
				// mask
				wrapper.mask		= viewport;
				
				// parameters
				this.mode			= mode;
				this.crop			= crop;
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Sets the size of the component
			 * 
			 * @param	width
			 * @param	height
			 */
			public function setSize(width:Number, height:Number):void 
			{
				viewport.width	= width;
				viewport.height	= height;
				invalidate();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			override public function get width():Number { return viewport.width; }
			override public function set width(value:Number):void 
			{
				viewport.width = value;
				invalidate();
			}
			
			override public function get height():Number { return viewport.height; }
			override public function set height(value:Number):void 
			{
				viewport.height = value;
				invalidate();
			}
		
			public function get mode():String { return _mode; }
			public function set mode(value:String):void 
			{
				_mode = value;
				invalidate();
			}
			
			public function get crop():Boolean { return wrapper.mask === viewport; }
			public function set crop(value:Boolean):void 
			{
				wrapper.mask = value ? viewport : null;
			}
			
			public function get align():String { return _align; }
			public function set align(value:String):void 
			{
				_align = value;
				invalidate();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function draw():void
			{
				// debug
				super.draw();
				
				// size
				if (wrapper.numChildren)
				{
					// if everything is the same size, skip fitting and just align
					if (wrapper.width == viewport.width && wrapper.height == viewport.height)
					{
						wrapper.x = wrapper.y = 0;
					}
					
					// otherwise, fit and align
					else
					{
						Elements.fit(wrapper, viewport, mode);
						Elements.align(wrapper, viewport, align);
					}
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}