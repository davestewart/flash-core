package core.display.containers.boxes 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	/**
	 * Directional Box
	 * 
	 * Base class for VBox and HBox classes to inherit from.
	 * 
	 * Contains core layout methods, and provides base methhods to set width, height and wrapping
	 * 
	 * @author Dave Stewart
	 */
	public class DBox extends UBox
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// stage intances
				
			
			// variables
				protected var _axis			:String;
				protected var _size			:Number;
				protected var _wrap			:Boolean;
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function DBox(parent:DisplayObjectContainer = null, axis:String = 'x', spacing:int = 3, padding:int = 0) 
			{
				// properties
				this.axis	= axis;
				
				// super
				super(parent, spacing, padding);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function get width():Number { return content.width + padding * 2; }
			override public function set width(value:Number):void 
			{
				// override in subclass
			}
			
			override public function get height():Number { return content.height + padding * 2; }
			override public function set height(value:Number):void 
			{
				// override in subclass;
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get axis():String { return _axis; }
			public function set axis(value:String):void 
			{
				if (value !== 'x' && value !== 'y')
				{
					throw new Error('Property axis may only be "x" or "y"');
				}
				_axis	= value;
				invalidate();
			}
			
			public function get wrap():Boolean { return _wrap; }
			public function set wrap(value:Boolean):void 
			{
				_wrap = value;
				invalidate();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function layout():void 
			{
				// variables
				var child		:DisplayObject;
				var sizeA		:Number = 0;
				var sizeB		:Number = 0;
				var tempB		:Number = 0;
				var axisA		:String	= _axis;
				var axisB		:String	= axisA === 'x' ? 'y' : 'x';
				var propA		:String	= axisA === 'x' ? 'width' : 'height';
				var propB		:String	= axisA === 'x' ? 'height' : 'width';
				var wrapV		:Number	= _size - (_padding * 2);
				
				// container
				content.x		= padding;
				content.y		= padding;
				
				// layout elements
				for (var i:int = 0; i < content.numChildren; i++)
				{
					// get child
					child = getChildAt(i);
					
					// wrap
					if (wrap)
					{
						// wrap if position would overflow wrap value
						if (i > 0 && sizeA + child[propA] > wrapV)
						{
							sizeB += tempB + spacing;
							sizeA = 0;
							tempB = 0;						
						}
						
						// capture max alternative axis dimension
						if (child[propB] > tempB)
						{
							tempB = child[propB];
						}
					}
					
					// position child
					child[axisA]	= sizeA;
					child[axisB]	= sizeB;
					sizeA			+= child[propA] + spacing;
				}
			}
			
			/**
			override protected function drawDebug():void 
			{
				graphics.clear();
				var r:Rectangle = rect;
				graphics.lineStyle(0.1, 0x000000, 0.5, true);
				graphics.drawRect(0, 0, r.width + padding * 2, r.height + padding * 2); // outer
				graphics.drawRect(r.x, r.y, r.width, r.height); // inner
			}
			**/
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}