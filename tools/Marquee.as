package core.tools 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Allows the drawing of a rectangular marquee / region on the stage
	 * 
	 * Doesn't take into account rotation or scaling, so best to attach to non-scaled or rotated hierarchies
	 * 
	 * @author Dave Stewart
	 */
	public class Marquee extends Sprite 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// element properties
				protected var _parent		:DisplayObjectContainer;
						                    
			// geometry properties		    
				protected var pt			:Point;
				protected var rect			:Rectangle;
				protected var mtx			:Matrix;
				                            
			// behavioural properties       
				public var locked			:Boolean;
				public var constrained		:Boolean;
				                            
			// objects                      
				protected var ants			:MarchingAnts;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Marquee(parent:DisplayObjectContainer = null, constrained:Boolean = false, animate:Boolean = false) 
			{
				// event handlers
				addEventListener(Event.ADDED, onAdded);
				addEventListener(Event.REMOVED, onRemoved);
				
				// properties
				this.constrained	= constrained;
				
				// properties
				mtx					= new Matrix();
				mouseEnabled		= false;
				blendMode			= BlendMode.DIFFERENCE;
				
				// ants
				if (animate)
				{
					ants			= new MarchingAnts();
					ants.addEventListener(Event.CHANGE, onAntsUpdate);
				}
				
				// add to parent
				if (parent)
				{					
					parent.addChild(this);
				}
			}
					
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function reset():void 
			{
				// graphics
				graphics.clear();
				
				// rect
				rect = null;
				
				// event
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			public function getMatrix(scaled:Boolean = false):Matrix
			{
				if ( ! rect)
				{
					return null;
				}
				
				// scale to bitmap
				else if (scaled)
				{
					// get inverse scale ratios
					var sx	:Number		= _parent.width / rect.width;
					var sy	:Number		= _parent.height / rect.height;

					// matrix
					mtx					= new Matrix(sx, 0, 0, sy, -rect.x * sx, -rect.y * sy); // need to scale translation as well!
				}
				
				// just copy
				else
				{
					// matrix
					mtx					= new Matrix(1, 0, 0, 1);
					mtx.tx				= -rect.x;
					mtx.ty				= -rect.y;
				}
				
				return mtx;
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get rectangle():Rectangle
			{
				return rect ? rect.clone() : null;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function invalidate():void 
			{
				addEventListener(Event.ENTER_FRAME, onInvalidate);
			}
			
			protected function update():void 
			{
				if (rect.width * rect.height > 0)
				{
					draw();
				}
				dispatchEvent(new Event(Event.CHANGE));
			}
			
			protected function draw():void 
			{
				graphics.clear();
				graphics.lineStyle(0.25, 0xFFFFFF);
				if (ants)
				{
					graphics.lineBitmapStyle(ants.bitmapData, ants.matrix);
				}
				
				graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onMouseDown(event:MouseEvent):void 
			{
				if ( ! locked )
				{
					// rectangle
					pt				= new Point(_parent.mouseX, _parent.mouseY)
					
					// ignore if constrained and outside bounds of parent
					if (constrained && ! _parent.getBounds(_parent).containsPoint(pt) )
					{
						return;
					}
					
					// rectangle
					rect			= new Rectangle();
					rect.x			= pt.x;
					rect.y			= pt.y;
					rect.width = rect.height = 0;
					
					// listeners
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
			}
			
			protected function onMouseMove(event:MouseEvent):void 
			{
				// ignore if constrained and outside bounds of parent
				if (constrained && ! _parent.getBounds(_parent).containsPoint(new Point(_parent.mouseX, _parent.mouseY)) )
				{
					return;
				}
				
				// dimensions
				var x:Number	= pt.x;
				var y:Number	= pt.y;
				var w:Number	= _parent.mouseX - x;
				var h:Number	= _parent.mouseY - y;
				
				// adjust for negative values
				if (w < 0)
				{
					w		= -w;
					x		-= w;
				}
				if (h < 0)
				{
					h		= -h;
					y		-= h;
				}
				
				// update rectangle
				rect.x			= x;
				rect.y			= y;
				rect.width		= w;
				rect.height		= h;
				
				// update
				invalidate();
			}
			
			protected function onMouseUp(event:MouseEvent):void 
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		
			protected function onAdded(event:Event):void 
			{
				_parent = parent;
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			
			protected function onRemoved(event:Event):void 
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			
			protected function onInvalidate(event:Event):void 
			{
				removeEventListener(Event.ENTER_FRAME, onInvalidate);
				update();
			}
			
			protected function onAntsUpdate(event:Event):void 
			{
				if (rect)
				{
					draw();
				}
				
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}


import flash.display.BitmapData;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.geom.Matrix;
import flash.utils.Timer;

class MarchingAnts extends EventDispatcher
{
	
	protected var mtx		:Matrix;
	protected var timer		:Timer;
	protected var data		:BitmapData;
	
	// ---------------------------------------------------------------------------------------------------------------------
	// { region: variables
	
		// constants
			
		
		// properties
			
			
		// variables
			
			
		
	// ---------------------------------------------------------------------------------------------------------------------
	// { region: instantiation
	
		public function MarchingAnts() 
		{
			// pixels
			var pixels:Array = 
			[
				[1, 0, 0],
				[0, 1, 0],
				[0, 0, 1],
			];
			
			// matrix
			mtx = new Matrix();
			mtx.scale(2, 2);
			
			// bitmap data
			data = new BitmapData(pixels[0].length, pixels.length, false, 0xFFFFFF);
			
			// draw
			data.unlock();
			for (var y:int = 0; y < pixels.length; y++) 
			{
				for (var x:int = 0; x < pixels[y].length; x++) 
				{
					if (pixels[y][x] === 1)
					{
						data.setPixel(x, y, 0x000000);
					}
				}
			}
			data.lock();
			
			// timer
			timer = new Timer(200);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		
		protected function onTimer(event:TimerEvent):void 
		{
			mtx.translate(4, 2);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	
	// ---------------------------------------------------------------------------------------------------------------------
	// { region: public methods
	
		public function destroy():void 
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
		}
		
	
	// ---------------------------------------------------------------------------------------------------------------------
	// { region: accessors
	
		public function get bitmapData():BitmapData 
		{
			return data;
		}
	
		public function get matrix():Matrix
		{
			return mtx;
		}

		
	// ---------------------------------------------------------------------------------------------------------------------
	// { region: protected methods
	
		
	
	
	// ---------------------------------------------------------------------------------------------------------------------
	// { region: handlers
	
		
	
	
	// ---------------------------------------------------------------------------------------------------------------------
	// { region: utilities
	
		
	
}

