package core.display.elements 
{
	import app.display.panels.FormPanel;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Element extends Sprite implements IElement
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// stage intances
				
			
			// variables
				private var invalidationDelay:int = 0;
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Element(parent:DisplayObjectContainer = null) 
			{
				if (parent)
				{
					parent.addChild(this);
				}
				blendMode = BlendMode.LAYER;
				initialize();
				build();
			}
		
			static public function create(parent:DisplayObjectContainer):Element 
			{
				return new Element(parent);
			}
			
			protected function initialize():void 
			{
				
			}
			
			protected function build():void 
			{
				
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: display methods
		
			public function show():void
			{
				visible = true;
			}
		
			public function hide():void
			{
				visible = false;
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: children methods
		
			override public function addChild(child:DisplayObject):DisplayObject 
			{
				super.addChild(child);
				invalidate();
				return child;
			}
			
			public function addChildren(...elements):DisplayObject 
			{
				for each(var element:DisplayObject in elements)
				{
					addChild(element);
				}
				return this;
			}
			
			public function clear():void
			{
				while (numChildren > 0)
				{
					removeChildAt(0);
				}
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: drawing methods
		
			public function redraw():void
			{
				draw();
			}
			
			public function invalidate():void 
			{
				invalidationDelay = 1;
				addEventListener(Event.ENTER_FRAME, onInvalidate, false, 0, true);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function draw():void 
			{
				
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onInvalidate(event:Event):void 
			{
				if (invalidationDelay == 0)
				{
					removeEventListener(Event.ENTER_FRAME, onInvalidate);
				}
				else
				{
					invalidationDelay--;
				}
				draw();
			}
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}

