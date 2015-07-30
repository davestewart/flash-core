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
	 * Basic (no UI) implementation of a carousel or slider class
	 * 
	 * Wraps multiple DisplayObject items and allows them to be slid left and right
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
				protected var _lastIndex		:Number;
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
				super.addChild(content);
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: overridden public methods

			override public function addChild(child:DisplayObject):DisplayObject 
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
			
			override public function removeChild(child:DisplayObject):DisplayObject 
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
			
			override public function removeChildAt(index:int):DisplayObject 
			{
				return removeChild(content.getChildAt(index));
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods

			public function setPosition(placeholder:DisplayObject, replace:Boolean = false, useMask:Boolean = false):void
			{
				if (placeholder.parent)
				{
					// add to stage, just above the placeholder
					var index:int = placeholder.parent.getChildIndex(placeholder);
					placeholder.parent.addChildAt(this, index + 1);
					
					// align to placeholder
					x	= placeholder.x;
					y	= placeholder.y;
					
					// set width parameter, so slides know where to position themselves
					_width	= placeholder.width;
					
					// set the placeholder as a mask
					if (useMask)
					{
						super.addChild(placeholder);
						placeholder.x = 0;
						placeholder.y = 0;
						content.mask = placeholder;
					}
					
					// or optionally remove the placeholder alltogether
					else if (replace)
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
						_lastIndex	= _index;
						_index		= index;
						
					// variables
						var w		:Number	= _width + (_gutter * 2);
						var x		:Number	= - index * w;
						
					// dispatch change
						onAnimateStart();
						
					// update contents
						if (immediate)
						{
							content.x = x;
							onAnimateComplete();
						}
						else
						{
							animate(x);
						}
				}
			}
			
			override public function redraw():void 
			{
				draw();
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			// content
			
				public function get currentItem():DisplayObject 
				{
					return content.numChildren > 0 
						? content.getChildAt(index) 
						: null;
				}
			
				public function get lastItem():DisplayObject 
				{
					return content.numChildren > 0 
						? content.getChildAt(lastIndex) 
						: null;
				}
			
			// layout
			
				override public function get width():Number { return _width; }
				override public function set width(value:Number):void 
				{
					_width = value;
					invalidate();
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
			
			// properties
			
				public function get index():Number { return _index; }
				public function set index(value:Number):void 
				{
					navigate(value, true);
				}
				
				public function get length():int { return content.numChildren }
				
				public function get lastIndex():int { return _lastIndex }
			

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function animate(x:Number):void 
			{
				TweenLite.to(content, _duration, { x:x, onComplete:onAnimateComplete } );
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
		
			protected function onAnimateStart():void 
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		
			protected function onAnimateComplete():void 
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
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