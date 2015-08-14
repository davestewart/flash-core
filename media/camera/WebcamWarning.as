package core.media.camera 
{
	import assets.elements.WebcamWarningAsset;
	import com.greensock.TweenLite;
	import core.display.elements.Invalidatable;
	import core.display.shapes.Square;
	import core.media.video.VideoBase;
	import core.media.video.VideoRecorder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class WebcamWarning extends Invalidatable 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements
				protected var text		:WebcamWarningAsset;
				protected var recorder	:VideoRecorder;
				protected var video		:Video;
				protected var pixel		:Square;
			
			// properties
				protected var timer		:Timer;
				
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function WebcamWarning(parent:VideoRecorder) 
			{
				// elements
				recorder	= parent;
				video		= parent.video;
				
				// build
				initialize();
				build();
			}
			
			protected function initialize():void 
			{
				// add to container
				recorder.container.addChildAt(this, 0);
				
				// timer
				timer			= new Timer(1000);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
			}
			
			protected function build():void 
			{
				// text
				text			= new WebcamWarningAsset();
				text.scaleX		= recorder.container.scaleX;
				addChild(text);
				
				// hide
				text.visible	= false;
				text.alpha		= 0;
				
				// pixel
				pixel = new Square(1, 1);
				recorder.container.addChildAt(pixel, 0);
				
				// draw
				draw();
				
			}
			
			public function show():void 
			{
				TweenLite.to(text, 0.5, { autoAlpha:1, delay:0.5 } );
				timer.start();
			}
		
			public function hide():void 
			{
				text.visible		= false;
				text.alpha		= 0;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function check():void 
			{
				var container	:Sprite		= recorder.container;
				var bmd			:BitmapData = new BitmapData(container.width, container.height);
				bmd.draw(container);
				
				var color		:Number		= bmd.getPixel(0, 0);
				trace(color === 0x0000FF00);
				
			}
		
			override protected function draw():void 
			{
				// text
				text.x		= video.width / 2;
				text.y		= video.height / 2;
				
				if (text.width > video.width)
				{
					var scalar:Number = video.width / text.width;
					text.scaleX *= scalar;
					text.scaleY *= scalar;
				}
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onTimer(event:Event):void 
			{
				check();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}