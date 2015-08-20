package core.display.components 
{
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
	public class Viewport extends Invalidatable 
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
				protected var wrapper		:Sprite;
				
			// properties
				protected var _content		:DisplayObject;
				protected var _mode			:String;
				protected var _crop			:Boolean;
				protected var _align		:String;
				protected var _border		:Boolean;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Viewport(width:uint = 320, height:uint = 180, mode:String = COVER, crop:Boolean = true) 
			{
				// viewport
				viewport			= new Rect(width, height);
				viewport.visible	= false;
				viewport.name		= 'viewport';
				addChild(viewport);
				
				// wrapper
				wrapper				= new Sprite();
				wrapper.name		= 'wrapper';
				wrapper.mask		= viewport;
				addChild(wrapper);
				
				// parameters
				this.mode			= mode;
				this.crop			= crop;
				
				// interaction
				mouseEnabled		= false;
				wrapper.addEventListener(Event.RESIZE, onContentResized);
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
			
			public function clear():void 
			{
				if (content && content.parent == wrapper)
				{
					wrapper.removeChild(content);
					_content = null;
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get content():DisplayObject { return _content; }
			public function set content(value:DisplayObject):void 
			{
				clear();
				_content = value;
				wrapper.addChild(_content);
				invalidate();
			}
			
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
				invalidate();
			}
			
			public function get align():String { return _align; }
			public function set align(value:String):void 
			{
				_align = value;
				invalidate();
			}
			
			public function get border():Boolean { return _border; }
			public function set border(value:Boolean):void 
			{
				_border = value;
				invalidate();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function draw():void
			{
				// debug
				graphics.clear();
				if (border)
				{
					graphics.lineStyle(0.25, 0x000000, 1, true);
					graphics.drawRect(0.5, 0.5, viewport.width - 1, viewport.height - 1);
				}
				
				// size
				if (content)
				{
					Elements.fit(wrapper, viewport, mode);
					Elements.align(wrapper, viewport, align);
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onContentResized(event:Event):void 
			{
				draw();
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}