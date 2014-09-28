package core.display.components 
{
	import com.greensock.easing.Cubic;
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
	import flash.filters.DropShadowFilter;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Modal extends Element 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				public static var instance				:Modal;
			
			// properties
				protected var background				:Sprite;
				protected var container					:Sprite;
				protected var element					:DisplayObject;
				
				
			// behaviour
				protected var backgroundAlpha			:Number		= 0.4;
				protected var outScale					:Number		= 0.95;
				
			// variables
				static public const WIDTH				:int		= 1200;
				static public const HEIGHT				:int		= 760;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: static
		
			static public function create(parent:DisplayObjectContainer):Modal 
			{
				// activate plugin
					TweenPlugin.activate([AutoAlphaPlugin]);
					
				// throw error if a modal instance has already been created
					if (instance)
					{
						throw new Error('A global Modal has already been created via Modal.create()');
					}
					
				// create and return
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
					background.graphics.beginFill(0x000000, backgroundAlpha);
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
		
			public function update(element:DisplayObject):void 
			{
				// remove any existing element
					if (this.element)
					{
						container.removeChild(this.element);
					}
				
				// add the new element
					this.element = container.addChild(element);
				
				// update
					draw();
					show();
			}
			
			override public function show():void 
			{
				// properties
					container.scaleX = container.scaleY = outScale;
					container.alpha = 0;
					
				// animate
					TweenLite.to(this, 0.3, { autoAlpha:1, ease:Cubic.easeOut } );
					TweenLite.to(container, 0.4, { delay:0.2, autoAlpha:1, scaleX:1, scaleY:1, ease:Cubic.easeOut } );
			}
			
			override public function hide():void 
			{
				TweenLite.to(container, 0.4, { autoAlpha:0, scaleX:outScale, scaleY:outScale, ease:Cubic.easeOut } );
				TweenLite.to(this, 0.3, {  delay:0.2, autoAlpha:0, ease:Cubic.easeIn } );
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
					// update background
						background.width	= stage.stageWidth;
						background.height	= stage.stageHeight;
						
					// update content
						var height:Number	= Math.min(HEIGHT, stage.stageHeight);
						
					// centralize container
						container.x			= background.width / 2;
						container.y			= height / 2;
						
					// offset element
						element.x			= - element.width / 2;
						element.y			= - element.height / 2;			

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