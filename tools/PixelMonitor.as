package core.tools 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Monitors the color of a single pixel in an element
	 * 
	 * @author Dave Stewart
	 */
	public class PixelMonitor extends Sprite 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// properties
				protected var element	:Sprite;
				protected var px		:int;
				protected var py		:int;
				protected var color		:Number;
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function PixelMonitor(element:Sprite, px:int = -1, py:int = -1) 
			{
				this.element = element;
				initialize(px, py);
			}
			
			public function initialize(px:int = -1, py:int = -1):void 
			{
				this.px		= px == -1 ? int(element.width / 2) : px;
				this.py		= py == -1 ? int(element.height / 2) : py;
				color 		= getColor();
			}
			
			public function start():void 
			{
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			
			public function stop():void 
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function check():void 
			{
				// get color of pixel
				var color:uint = getColor();
				
				// if different from original, complete
				if (this.color !== color)
				{
					dispatchEvent(new Event(Event.CHANGE));
					stop();
				}
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onEnterFrame(event:Event):void 
			{
				check();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function getColor():Number
			{
				var bmd:BitmapData = new BitmapData(element.width, element.height);
				bmd.draw(element);
				return bmd.getPixel(px, py);
			}
		
	}

}