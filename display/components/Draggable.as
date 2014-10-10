package utils 
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import gs.TweenLite;

	/**
	 * @usage	Convert any display object into a draggable object
	 * 			Hold CTRL and drag to have the object revert back after dragging.
	 * 			Hold SHIFT and drag to have the object permanently move (shift) to the new position
	 * 
	 * @example	Draggable.create(someObject);
	 * 			Draggable.create(slowObject, 2);
	 * 
	 * @author	Dave Stewart
	 */

	public class Draggable
	{
		// --------------------------------------------------------------------------------------------------------
		// variables
		
			public static var elements			:Dictionary;			// all the elements set up for dragging
			public static var element			:DraggedElement;		// the currently-dragged object

			public static var clickPoint		:Point;					// the point first clicked
			public static var _useModifierKeys	:Boolean;				// use modifier keys or not
			
			
		// --------------------------------------------------------------------------------------------------------
		// static actions
		
			/**
			 * Whether to make the user use CTRL or SHIFT to drag the object
			 * @param	state		
			 */
			public static function useModifierKeys(state:Boolean = true)
			{
				Draggable._useModifierKeys = state;
				return Draggable;
			}
			
			/**
			 * Enable an object to be draggable
			 * @param	element		The element to drag
			 * @param	time		The amount of tiem in seconds the object should animate back to its starting position if CTRL is pressed
			 * @param	children	Whether to affect the entire object, or the children of the object
			 */
			public static function create(element:DisplayObject, time:Number = 0.25, children:Boolean = false, mouseMoveHandler:Function = null, mouseUpHandler:Function = null)
			{
				// create a new dictionary to hold any objects
					if (Draggable.elements == null)
					{
						Draggable.elements = new Dictionary(true);
					}
					
				// add element to the list
					Draggable.elements[element] = new DraggedElement(element, Math.abs(time), children, mouseMoveHandler, mouseUpHandler);

				// set up the mouse listener
					element.addEventListener(MouseEvent.MOUSE_DOWN, Draggable.mouseDownHandler, false, 0, true);
					
				// return the object for chaining
					return Draggable;
			}
			
			/**
			 * Stop an object from being draggable
			 * @param	element
			 */
			public static function destroy(element:DisplayObject)
			{
				if (element)
				{
					element.removeEventListener(MouseEvent.MOUSE_DOWN, Draggable.mouseDownHandler, false);
				}
				return Draggable;
			}
			
			/**
			 * Create an array of draggable objects in one go
			 * @param	elements
			 */
			public static function createMany(elements:Array):void 
			{
				for (var i:int = 0; i < elements.length; i++) 
				{
					Draggable.create(elements[i]);
				}
			}
			
			/**
			 * Destroy an array of draggable objects in one go
			 * @param	elements
			 */
			public static function destroyMany(elements:Array):void 
			{
				for (var i:int = 0; i < elements.length; i++) 
				{
					Draggable.destroy(elements[i]);
				}
			}
			
			/**
			 * Release all draggable objects
			 */
			public static function release():void 
			{
				for (var i:int = 0; i < Draggable.elements.length; i++) 
				{
					Draggable.destroy(Draggable.elements[i]);
				}
			}
			
		// --------------------------------------------------------------------------------------------------------
		// handlers
		
			/**
			 * Mouse down handler for the dragged object
			 * @param	event
			 */
			public static function mouseDownHandler(event:MouseEvent):void 
			{
				var allowDrag = true;
				if (Draggable._useModifierKeys && ! (event.ctrlKey || event.shiftKey))
				{
					allowDrag = false;
				}
				
				//trace(Draggable.elements[event.currentTarget as DisplayObject].element as DisplayObject)
				if (allowDrag) 
				{
					// set the current element as the dragged element
						element = Draggable.elements[event.currentTarget as DisplayObject];
						clickPoint = new Point(Draggable.element.element.mouseX, Draggable.element.element.mouseY);
						
					// set the revert data
						if (element)
						{
							element.x = element.element.x;
							element.y = element.element.y;
							element.active = event.ctrlKey
						}
						
					// initialize the drag
						element.element.stage.addEventListener(MouseEvent.MOUSE_MOVE, Draggable.mouseMoveHandler, false, 0, true);
						element.element.stage.addEventListener(MouseEvent.MOUSE_UP, Draggable.mouseUpHandler, false, 0, true);
/*
				*/
				}
			}
			
			/**
			 * Mouse move handler for the dragged object
			 * @param	event
			 */
			public static function mouseMoveHandler(event:MouseEvent):void 
			{
				element.element.x = event.stageX - Draggable.clickPoint.x
				element.element.y = event.stageY - Draggable.clickPoint.y;
				if (element.mouseMoveHandler != null)
				{
					element.mouseMoveHandler(event)
				}
			}
			
			/**
			 * Mouse up handler for the dragged object
			 * @param	event
			 */
			public static function mouseUpHandler(event:MouseEvent):void 
			{
				// remove any event listeners
					element.element.stage.removeEventListener(MouseEvent.MOUSE_MOVE, Draggable.mouseMoveHandler, false);
					element.element.stage.removeEventListener(MouseEvent.MOUSE_UP, Draggable.mouseUpHandler, false);
					
				// check if the object had been flagged for reversion
					if (element.active)
					{
						TweenLite.to(Draggable.element.element, element.time, { x:element.x, y:element.y } );
					}
				/*
					*/

			}
			
		
	}

}

import flash.display.DisplayObject;

class DraggedElement
{
	// element
		public var element				:DisplayObject;
		
	// properties
		public var time					:Number;
		public var children				:Boolean;
		
	// extra mouse listeners
		public var mouseMoveHandler		:Function;
		public var mouseUpHandler		:Function;
		
	// draggable info
		public var x					:Number;
		public var y					:Number;
		public var active				:Boolean;
	
	public function DraggedElement(element:DisplayObject, time:Number, children:Boolean, mouseMoveHandler:Function, mouseUpHandler:Function):void 
	{
		this.element			= element;
		this.time				= time;
		this.children			= children;
		this.mouseMoveHandler	= mouseMoveHandler;
		this.mouseUpHandler		= mouseUpHandler;
	}
}


