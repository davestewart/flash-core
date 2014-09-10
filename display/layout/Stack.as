package core.display.layout 
{
	import com.greensock.TweenLite;
	import core.display.elements.Element;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Stacking container, holds elements in a stack and shows one at a time
	 * Override in subclasses to change show/hide method, for example, to animate a cross-fade
	 * @author Dave Stewart
	 */
	public class Stack extends Sprite
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// stage instances
				
			
			// properties
				protected var elements		:Vector.<DisplayObject>;
				protected var element		:DisplayObject;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Stack(parent:DisplayObjectContainer = null) 
			{
				parent.addChild(this);
				elements = new Vector.<DisplayObject>;
			}

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public override function addChild(child:DisplayObject):DisplayObject 
			{
				return addElement(child);
			}
		
			/**
			 * Adds a new element to the stack, shows it, and hides the current element
			 * @param	child
			 * @return
			 */
			public function addElement(child:DisplayObject):DisplayObject 
			{
				// add child to list if not already added
					if (elements.indexOf(child) == -1)
					{
						elements.push(child);
						addChildAt(child, 0);
					}
					
				// if first element, set the stack index
					if (elements.length == 1)
					{
						element = child;
					}
					
				// if more than one element has been added, hide newly-added elements
					else
					{
						child.visible = false;
						child.alpha = 0;
					}
					return child;
			}
			
			public function removeElement(id:*):DisplayObject 
			{
				var element:DisplayObject = getElement(id);
				if (element)
				{
					var index:int = elements.indexOf(element);
					elements.splice(index, 1);
				}
				return element;
			}
		
			/**
			 * Adds multiple elements to the stack at once
			 * @param	...rest
			 * @return
			 */
			public function addElements(...rest):Stack
			{
				for each (var child:DisplayObject in rest) 
				{
					addElement(child);
				}
				return this;
			}
		
			/**
			 * Shows a new element, and automatically hides the current one
			 * @param	id
			 */
			public function showElement(id:*):void 
			{
				// grab new element
					var element:DisplayObject = getElement(id);
					
				// exit early if we're showing the same element again
					if (element == this.element)
					{
						return;
					}
					
				// hide current element if there is one
					if (this.element)
					{
						_hideElement(this.element);
					}
					
				// update properties and show element
					this.element = element;
					_showElement(element);
					dispatchEvent(new Event(Event.CHANGE));
			}
			
			/**
			 * hides an element
			 * @param	id
			 */
			public function hideChild(id:*):void
			{
				var element:DisplayObject = getElement(id);
				if (element)
				{
					_hideElement(element);
				}
			}
			
			public function clear():void 
			{
				while (numChildren) 
				{
					removeChildAt(0);
				}
				element = null;
				elements.length = 0;
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			/**
			 * Sets the current element
			 */
			public function set currentElement(id:*):void
			{
				showElement(id);
			}
		
			/**
			 * Gets the current element
			 */
			public function get currentElement():*
			{
				return element;
			}
		
			/**
			 * Sets the current element
			 */
			public function set currentIndex(index:int):void
			{
				showElement(index);
			}
		
			/**
			 * Gets the current element
			 */
			public function get currentIndex():*
			{
				return element 
						? elements.indexOf(element)
						: -1;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
		
			protected function _showElement(element:DisplayObject):void
			{
				element.visible = true;
				element.alpha	= 1;
			}
		
			protected function _hideElement(element:DisplayObject):void
			{
				element.visible = false;
				element.alpha	= 0;
			}
		
			protected function _addChild(child:DisplayObject):DisplayObject 
			{
				return super.addChild(child);
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers

			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			/**
			 * Gets an element by name or index
			 * @param	id
			 * @return 
			 */
			protected function getElement(id:*):DisplayObject
			{
				var element:DisplayObject = id is int
					? elements[id]
					: id is String
						? getChildByName(id)
						: id is DisplayObject
							? id
							: null;
							
				if (element == null)
				{
					throw new Error('Invalid element identifier:' + id);
				}
				
				return element;
			}
			
			
	}

}