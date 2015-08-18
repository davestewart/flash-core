package core.display.components 
{
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class BaseModal extends Sprite 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// properties
				protected var background			:Sprite;
				protected var container				:Sprite;
				protected var element				:DisplayObject;
				
			// behaviour
				protected var backgroundColor		:Number;
				protected var backgroundAlpha		:Number;
				protected var cancelable			:Boolean;
				
			// variables
				public var minHeight				:int;
				public var maxHeight				:int;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: static
		
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function BaseModal(parent:DisplayObjectContainer, maxHeight:int = Number.MAX_VALUE, minHeight:int = 0)
			{
				// parameters
					this.maxHeight	= maxHeight;
				
				// add child
					parent.addChild(this);
					initialize();
					build();
					hide(true);
			}
			
			protected function initialize():void 
			{
				minHeight		= 300;
				backgroundColor	= 0x000000;
				backgroundAlpha	= 0.4;
			}
			
			protected function build():void 
			{
				// build bg
					background = new Sprite();
					background.graphics.beginFill(backgroundColor, backgroundAlpha);
					background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
					background.graphics.endFill();
					addChild(background);
				
				// build container
					container = new Sprite();
					container.filters = [new DropShadowFilter(10, 90, 0, 0.2, 20, 20, 1, 3)];
					addChild(container);
					
				// listeners
					background.addEventListener(MouseEvent.MOUSE_DOWN, onBackgroundMouseDown);
					stage.addEventListener(Event.RESIZE, onResize);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function update(element:DisplayObject, cancelable:Boolean = true):void 
			{
				// replace existing element
					clear();
					this.element	= container.addChild(element);
				
				// update properties
					this.cancelable	= cancelable;
				
				// update
					draw();
					show();
			}
			
			public function show(immediate:Boolean = false):void 
			{
				visible = true;
			}
			
			public function hide(immediate:Boolean = false):void 
			{
				visible = false;
			}
			
			public function cancel():void
			{
				hide();
				dispatchEvent(new Event(Event.CANCEL));
			}
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function draw():void 
			{
				if (stage && element)
				{	
					// update background
						background.width	= stage.stageWidth;
						background.height	= stage.stageHeight;
						
					// update content
						var height:Number	= Math.min(maxHeight, stage.stageHeight);
						
					// centralize container
						container.x			= background.width / 2;
						container.y			= height / 2;
						
					// offset element
						element.x			= - element.width / 2;
						element.y			= - element.height / 2;
						
					// document hack
						x					= -parent.x;
				}
			}
			
			protected function clear():void 
			{
				if (this.element)
				{
					container.removeChild(this.element);
				}
				element = null;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onResize(event:Event):void 
			{
				draw();
			}
			
			protected function onBackgroundMouseDown(event:MouseEvent):void 
			{
				if (cancelable)
				{
					cancel();
				}
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}