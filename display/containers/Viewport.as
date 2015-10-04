package core.display.containers 
{
	import core.display.containers.Container;
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
				protected var window		:Rect;
				
			// properties
				protected var _crop			:Boolean;
				protected var _scaling		:String;
				protected var _align		:String;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Viewport(width:uint = 320, height:uint = 180, scaling:String = COVER, crop:Boolean = true) 
			{
				// super
				super();
				
				// window (building this here, not in build() so to not need to create redumndant _width and _height variables)
				window				= new Rect(width, height);
				window.visible		= false;
				window.name			= 'window';
				_addChild(window);
				
				// mask
				content.mask		= window;
				
				// parameters
				this.scaling		= scaling;
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
				window.width	= width;
				window.height	= height;
				invalidate();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			override public function get width():Number { return window.width; }
			override public function set width(value:Number):void 
			{
				window.width = value;
				invalidate();
			}
			
			override public function get height():Number { return window.height; }
			override public function set height(value:Number):void 
			{
				window.height = value;
				invalidate();
			}
		
			/**
			 * Crops the contained content using the width and height of the container
			 */
			public function get crop():Boolean { return content.mask === window; }
			public function set crop(value:Boolean):void 
			{
				content.mask = value ? window : null;
			}
			
			/**
			 * Sets the scaling mode of the content
			 */
			public function get scaling():String { return _scaling; }
			public function set scaling(value:String):void 
			{
				_scaling = value;
				invalidate();
			}
			
			/**
			 * Sets the alignment mode of the content
			 */
			public function get align():String { return _align; }
			public function set align(value:String):void 
			{
				_align = value;
				invalidate();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function layout():void
			{
				if (content.numChildren)
				{
					// if everything is the same size, skip fitting and just align
					if (content.width == window.width && content.height == window.height)
					{
						content.x = content.y = 0;
					}
					
					// otherwise, fit and align
					else
					{
						Elements.fit(content, window, _scaling);
						Elements.align(content, window, _align);
					}
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}