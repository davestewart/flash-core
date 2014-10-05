package core.utils.tools 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Layout 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				public var placeholder	:DisplayObject;
				public var element		:DisplayObject;
				
			// variables
				protected var bounds	:Rectangle;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			/**
			 * 
			 * @param	placeholder		The placeholder being aligned-to
			 * @param	element			The element being aligned
			 * @param	useBounds		An optional Boolean to use the placeholder's bounds, defaults to true
			 */
			public function Layout(placeholder:DisplayObject, element:DisplayObject, useBounds:Boolean = true):void 
			{
				setElement(element);
				setPlaceholder(placeholder, useBounds);
			}
			
			/**
			 * 
			 * @param	placeholder		The placeholder being aligned-to
			 * @param	element			The element being aligned
			 * @param	useBounds		An optional Boolean to use the placeholder's bounds, defaults to true
			 */
			public static function grab(placeholder:DisplayObject, element:DisplayObject, useBounds:Boolean = true):Layout 
			{
				return new Layout(placeholder, element, useBounds);
			}
			
			/**
			 * 
			 * @param	placeholder		The placeholder being aligned-to
			 * @param	element			The element being aligned
			 * @param	useBounds		An optional Boolean to use the placeholder's bounds, defaults to true
			 */
			public static function replace(placeholder:DisplayObject, element:DisplayObject, useBounds:Boolean = true):Layout 
			{
				var utils:Layout = new Layout(placeholder, element, useBounds);
				if (placeholder.parent)
				{
					placeholder.parent.addChildAt(element, placeholder.parent.getChildIndex(placeholder));
					placeholder.parent.removeChild(placeholder);					
				}
				return utils;
			}			
		
			/**
			 * 
			 * @param	placeholder		The placeholder being aligned-to
			 * @param	useBounds		An optional Boolean to use the placeholder's bounds, defaults to true
			 * @return
			 */
			public function setPlaceholder(placeholder:DisplayObject, useBounds:Boolean = true):Layout
			{
				this.placeholder = placeholder;
				bounds = placeholder is Stage
							? new Rectangle(0, 0, placeholder.stage.stageWidth, placeholder.stage.stageHeight)
							: useBounds
								? placeholder.getBounds(placeholder.parent ? placeholder.parent : placeholder)
								: new Rectangle(placeholder.x, placeholder.y, placeholder.width, placeholder.height);
				return this;
			}
		
			/**
			 * 
			 * @param	element			The element being aligned
			 * @return
			 */
			public function setElement(element:DisplayObject):Layout
			{
				this.element = element;
				return this;
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function align(type:String = 'top left', offset:Number = 0):Layout
			{
				switch(type)
				{
					// corners
						case 'top left':
							align('top', offset);
							align('left', offset);
						break;
						case 'top right':
							align('top', offset);
							align('right', offset);
						break;
						case 'bottom left':
							align('bottom', offset);
							align('left', offset);
						break;
						case 'bottom right':
							align('bottom', offset);
							align('right', offset);
						break;
						
					// edges
						case 'left':
							element.x			= bounds.left + offset;
						break;			
						case 'right':			
							element.x			= bounds.right - element.width + offset;
						break;			
						case 'top':			
							element.y			= bounds.top + offset;
						break;
						case 'bottom':
							element.y			= bounds.bottom - element.height + offset;
						break;
						
					// centers
						case 'horz':
						case 'horizontal':
							element.x			= (bounds.width / 2) - (element.width / 2) + offset;
						break;
						case 'vert':
						case 'vertical':
							element.y			= (bounds.height / 2) - (element.height / 2) + offset;
						break;
					case 'center':
							trace(bounds)
							align('vertical', offset);
							align('horizontal', offset);
						break;
				}
				
				return this;
			}
			
			public function match(type:String = 'size'):Layout
			{
				switch(type)
				{
					// scale
						case 'scale':
							element.scaleX		= placeholder.scaleX;
							element.scaleY		= placeholder.scaleY;
						break;	
						case 'scaleX':	
							element.scaleX		= placeholder.scaleX;
						break;	
						case 'scaleY':	
							element.scaleY		= placeholder.scaleY;
						break;	
							
					// size	
						case 'size':	
							element.width		= placeholder.width;
							element.height		= placeholder.height;
						break;	
						case 'width':	
							element.width		= placeholder.width;
						break;	
						case 'height':	
							element.height		= placeholder.height;
						break;	
							
					// size proportional	
						case 'WIDTH':	
							element.width		= placeholder.width;
							element.scaleY		= element.scaleX;
						break;	
						case 'HEIGHT':	
							element.width		= placeholder.width;
							element.scaleX		= element.scaleY;
						break;
						
					// other dimensions
						case 'rotation':
							element.rotation	= placeholder.rotation;
						break;
				}
				
				return this;
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