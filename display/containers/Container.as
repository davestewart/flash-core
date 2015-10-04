package core.display.containers 
{
	import core.display.elements.Element;
	import core.geom.Size;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import core.display.elements.Invalidatable;
	
	/**
	 * Base container class for any elements needing to wrap and manipulate other elements
	 * 
	 * Manages adding and removing elements, as well as dispatching resize events
	 * 
	 * @author Dave Stewart
	 */
	public class Container extends Element 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// elements
				public var content			:Sprite;
				
				
			// properties
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Container(parent:DisplayObjectContainer = null) 
			{
				super(parent);
			}
			
			override protected function initialize():void 
			{
				tabEnabled			= false;
			}
			
			override protected function build():void 
			{
				// wrapper
				content				= new Sprite();
				content.name		= 'content';
				content.addEventListener(Event.RESIZE, onContentResized);
				_addChild(content);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function addChild(child:DisplayObject):DisplayObject 
			{
				invalidate();
				return content.addChild(child);
			}
			
			override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
			{
				invalidate();
				return content.addChildAt(child, index);
			}
			
			public function addChildren(...elements):DisplayObject 
			{
				invalidate();
				if (elements.length)
				{
					if(elements[0] is Array)
					{
						elements = elements[0];
					}
					for each(var element:DisplayObject in elements)
					{
						element && content.addChild(element);
					}
				}
				return this;
			}
			
			override public function removeChild(child:DisplayObject):DisplayObject 
			{
				invalidate();
				return content.removeChild(child);
			}
			
			override public function removeChildAt(index:int):DisplayObject 
			{
				invalidate();
				return content.removeChildAt(index);
			}
			
			override public function removeChildren(beginIndex:int = 0, endIndex:int = 2147483647):void 
			{
				invalidate();
				content.removeChildren(beginIndex, endIndex);
			}
			
			override public function getChildAt(index:int):DisplayObject 
			{
				return content.getChildAt(index);
			}
			
			override public function getChildByName(name:String):DisplayObject 
			{
				return content.getChildByName(name);
			}
		
			public function clear():void 
			{
				if (content.numChildren > 0)
				{
					while (content.numChildren > 0)
					{
						content.removeChildAt(0);
					}
					invalidate();
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			override public function get numChildren():int { return content.numChildren; }
			
			public function get rect():Rectangle
			{
				return new Rectangle(content.x, content.y, content.width, content.height);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function draw():void
			{
				// exit early if no content
				if ( ! content )
				{
					return;
				}
				
				// get current size
				var width	:Number	= this.width;
				var height	:Number	= this.height;
				
				// layout
				layout();
				
				// check if size has changed
				if (width !== this.width || height !== this.height)
				{
					dispatchEvent(new Event(Event.RESIZE));
				}
			}
			
			protected function layout():void 
			{
				// lay out contents
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onContentResized(event:Event):void 
			{
				event.stopPropagation();
				invalidate();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: proxied add/remove methods (for subclasses and any external classes that REALLY need to add something to the top level)
		
			/**
			 * Proxied addChild() method for subclasses, in order to add elements (masks, etc) directly
			 * 
			 * @param	child
			 * @return
			 */
			public function _addChild(child:DisplayObject):DisplayObject 
			{
				return super.addChild(child);
			}
			
			public function _addChildAt(child:DisplayObject, index:int):DisplayObject 
			{
				return super.addChildAt(child, index);
			}
		
			/**
			 * Proxied removeChild() method for subclasses, to remove elements (masks, etc) directly from the container
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