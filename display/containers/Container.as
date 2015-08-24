package core.display.containers 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import core.display.elements.Invalidatable;
	import core.display.shapes.Rect;
	import core.utils.Elements;
	
	/**
	 * Base container class for any elements needing to wrap and manipulate other elements 
	 * 
	 * @author Dave Stewart
	 */
	public class Container extends Invalidatable 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// elements
				protected var overlay		:Shape;
				public var wrapper			:Sprite;
				
				
			// properties
				protected var _border		:Boolean;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Container() 
			{
				// overlay
				overlay				= new Shape();
				overlay.name		= 'overlay';
				_addChild(overlay);
				
				// wrapper
				wrapper				= new Sprite();
				wrapper.name		= 'wrapper';
				wrapper.addEventListener(Event.RESIZE, onContentResized);
				_addChild(wrapper);

				// interaction
				tabEnabled			= false;
				mouseEnabled		= false;
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function addChild(child:DisplayObject):DisplayObject 
			{
				return wrapper.addChild(child);
				invalidate();
			}
			
			override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
			{
				return wrapper.addChildAt(child, index);
				invalidate();
			}
			
			public function addChildren(...elements):DisplayObject 
			{
				for each(var element:DisplayObject in elements)
				{
					wrapper.addChild(element);
				}
				return this;
			}
			
			override public function removeChild(child:DisplayObject):DisplayObject 
			{
				return wrapper.removeChild(child);
				invalidate();
			}
			
			override public function removeChildAt(index:int):DisplayObject 
			{
				return super.removeChildAt(index);
				invalidate();
			}
			
			override public function removeChildren(beginIndex:int = 0, endIndex:int = 2147483647):void 
			{
				wrapper.removeChildren(beginIndex, endIndex);
				invalidate();
			}
			
			/*
			override public function getChildAt(index:int):DisplayObject 
			{
				return wrapper.getChildAt(index);
			}
			*/
			
			override public function getChildByName(name:String):DisplayObject 
			{
				return wrapper.getChildByName(name);
			}
		
			public function clear():void 
			{
				if (wrapper.numChildren > 0)
				{
					while (wrapper.numChildren > 0)
					{
						wrapper.removeChildAt(0);
					}
					invalidate();
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
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
				overlay.graphics.clear();
				if (border)
				{
					overlay.graphics.lineStyle(0.25, 0x000000, 1, true);
					overlay.graphics.drawRect(0.5, 0.5, width - 1, height - 1);
					_addChild(overlay);
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onContentResized(event:Event):void 
			{
				invalidate();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			/**
			 * Proxied addChild() method to add elements (masks, etc) directly to the container
			 * 
			 * @param	child
			 * @return
			 */
			protected function _addChild(child:DisplayObject):DisplayObject 
			{
				return super.addChild(child);
			}
			
			protected function _addChildAt(child:DisplayObject, index:int):DisplayObject 
			{
				return super.addChildAt(child, index);
			}
		
			/**
			 * Proxied removeChild() method to remove elements (masks, etc) directly from the container
			 * 
			 * @param	child
			 * @return
			 */
			public function _removeChild(child:DisplayObject):DisplayObject 
			{
				return super.removeChild(child);
			}
		
			
	}

}