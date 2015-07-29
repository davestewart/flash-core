package core.display.components 
{
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import core.display.elements.Element;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * Slider Class
	 * 
	 * Wraps multiple slide items and allows them to be slid left and right
	 * 
	 * @author Dave Stewart
	 */
	public class Slider extends Element 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// elements
				protected var content			:Sprite;
				
			// layout
				protected var _width			:Number			= NaN;
				protected var _gutter			:Number;
				
			// variables
				protected var _index			:Number;
				protected var _duration			:Number;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Slider(gutter:Number = 0, duration:Number = 0.7)
			{
				_gutter		= gutter;
				_duration	= duration;
			}
		
			override protected function initialize():void 
			{
				_index = 0;
			}
			
			override protected function build():void 
			{
				content			= new Sprite();
				content.name	= '_content';
				addChild(content);
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function setPlaceholder(placeholder:DisplayObject, replace:Boolean = false):void
			{
				if (placeholder.parent)
				{
					// add to stage if a placeholder is supplied
					var index:int = placeholder.parent.getChildIndex(placeholder);
					placeholder.parent.addChildAt(this, index + 1);
					
					// align child
					x	= placeholder.x;
					y	= placeholder.y;
					
					// set width
					_width	= placeholder.width;
					
					// remove
					if (replace)
					{
						placeholder.parent.removeChild(placeholder);
					}
				}
			}
		
			public function prev():void 
			{
				if (index > 0)
				{
					navigate(index - 1);
				}
			}
			
			public function next():void 
			{
				if (index < content.numChildren - 1)
				{
					navigate(index + 1);
				}
			}
			
			public function navigate(index:int, immediate:Boolean = false):void 
			{
				if (index >= 0 && index < content.numChildren)
				{
					// set index
						_index = index;
						
					// variables
						var w	:Number	= _width + (_gutter * 2);
						var x	:Number	= - index * w;
						
					// dispatch change
						onTransitionStart();
						
					// update contents
						if (immediate)
						{
							content.x = x;
							onTransitionComplete();
						}
						else
						{
							transition(x);
						}
				}
			}
			
			override public function redraw():void 
			{
				draw();
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			// layout
			
				override public function get width():Number { return _width; }
				override public function set width(value:Number):void 
				{
					_width = value;
					invalidate();
				}
				
				public function get contentWidth():Number { return super.width; }
				public function set contentWidth(value:Number):void 
				{
					super.width = value;
					invalidate();
				}
				
			// behaviour
			
				public function get currentItem():DisplayObject { return content.numChildren > 0 ? content.getChildAt(index) : null; }
			
				public function get index():Number { return _index; }
				public function set index(value:Number):void 
				{
					navigate(value, true);
				}
				
				public function get gutter():Number { return _gutter; }
				public function set gutter(value:Number):void 
				{
					_gutter = value;
					invalidate();
				}
				
				public function get duration():Number { return _duration; }
				public function set duration(value:Number):void 
				{
					_duration = value;
				}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function transition(x:Number):void 
			{
				TweenLite.to(content, _duration, { x:x, onComplete:onTransitionComplete } );
			}
	
			override protected function draw():void 
			{
				// variables
					var child	:DisplayObject;
					var offset	:Number;
				
				// update child objects
					for (var i:int = 0; i < content.numChildren; i++) 
					{
						// position child
							child		= content.getChildAt(i);
							child.x		= (_width + _gutter * 2) * i;
							
						// offset (center) according to its width
							offset		= (_width - child.width) / 2
							child.x		+= offset;
					}
					
				// update overall offset
					var w	:Number	= _width + (_gutter * 2);
					content.x = - index * w;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onTransitionStart():void 
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		
			protected function onTransitionComplete():void 
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			public function addItem(child:DisplayObject):DisplayObject 
			{
				// set width if not already set
				if (isNaN(_width))
				{
					_width = child.width;
				}
				
				// add child
				content.addChild(child);
				invalidate();
				return child;
			}
			
			public function removeItem(child:DisplayObject):DisplayObject 
			{
				var child:DisplayObject = content.removeChild(child);
				if (index > content.numChildren - 1)
				{
					index = content.numChildren - 1;
					navigate(index, true);
				}
				invalidate();
				return child;
			}
			
			public function removeItemAt(index:int):DisplayObject 
			{
				return removeItem(content.getChildAt(index));
			}
			
			
	}

}

import core.display.elements.Element;
import flash.display.DisplayObject;
import flash.display.Sprite;

class Slide extends Element
{
	protected var _content	:DisplayObject;
	protected var _gutter	:Number;
	
	public function Slide(content:DisplayObject, gutter:Number)
	{
		// parameters
		_gutter		= gutter;
		_content	= content;
		
		// add content
		addChild(content);
	}
}