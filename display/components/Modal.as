package core.display.components 
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import core.display.elements.Element;
	import core.utils.display.DisplayUtils;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Modal extends Element 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				public static var instance				:Modal;
				protected var background				:Sprite;
				protected var container					:Sprite;
				
			// variables
				static public const WIDTH				:int = 1200;
				static public const HEIGHT				:int = 760;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: static
		
			static public function create(parent:DisplayObjectContainer):Modal 
			{
				TweenPlugin.activate([AutoAlphaPlugin]);
				instance = new Modal(parent);
				return instance;
			}
			
			static public function show(element:DisplayObject):void 
			{
				instance.update(element);
			}
			
			static public function hide():void 
			{
				instance.hide();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Modal(parent:DisplayObjectContainer = null)
			{
				super(parent);
			}
			
			override protected function build():void 
			{
				// vsiibility
					alpha		= 0;
					visible		= false;
					
				// build bg
					background = new Sprite();
					background.graphics.beginFill(0x000000, 0.4);
					background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
					background.graphics.endFill();
					addChild(background);
				
				// build container
					container = new Sprite();
					addChild(container);
					
				// listeners
					background.addEventListener(MouseEvent.MOUSE_DOWN, onBackgroundMouseDown);
					stage.addEventListener(Event.RESIZE, onResize);
				
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function update(element:DisplayObject):void 
			{
				// remove old children
					if (container.numChildren > 0)
						container.removeChildAt(0);
				
				// add new child
					container.addChild(element);
				
				// draw
					draw();
				
				// show
					show();
			}
			
			override public function show():void 
			{
				TweenLite.to(this, 0.3, { autoAlpha:1 } );
			}
			
			override public function hide():void 
			{
				TweenLite.to(this, 0.3, { autoAlpha:0 } );
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
		
			override protected function draw():void 
			{
				if (parent)
				{	
					background.width = stage.stageWidth;
					background.height = stage.stageHeight;
					
					var height:Number = Math.min(HEIGHT, stage.stageHeight);
					
					container.x = background.width / 2 - container.width / 2;
					container.y = height / 2 - container.height / 2;			
				}
			}
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onResize(event:Event):void 
			{
				draw();
			}
			
			private function onBackgroundMouseDown(event:MouseEvent):void 
			{
				cancel();
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}