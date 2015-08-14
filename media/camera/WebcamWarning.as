package core.media.camera 
{
	import assets.elements.WebcamWarningAsset;
	import com.greensock.TweenLite;
	import core.events.CameraEvent;
	import core.media.video.VideoRecorder;
	import core.tools.PixelMonitor;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Video;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class WebcamWarning extends Sprite 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements
				protected var text		:WebcamWarningAsset;
				protected var video		:Video;
				protected var monitor	:PixelMonitor;
			
			// properties
				protected var _parent	:VideoRecorder;
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function WebcamWarning(parent:VideoRecorder, px:int = 0, py:int = 0) 
			{
				// elements
				video		= parent.video;
				monitor 	= new PixelMonitor(parent, px, py);
				monitor.addEventListener(Event.CHANGE, onChange);
				monitor.start();
				
				// add to parent
				parent.addChild(this)

				// build
				build();
			}
			
			protected function build():void 
			{
				// text
				text		= new WebcamWarningAsset();
				visible		= false;
				alpha		= 0;
				addChild(text);
				
				// draw
				draw();
			}
			
			public function show():void 
			{
				TweenLite.to(this, 0.5, { autoAlpha:1, delay:0.5 } );
			}
			
			public function hide():void 
			{
				TweenLite.killTweensOf(this);
				visible		= false;
				alpha		= 0;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function draw():void 
			{
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
		
			protected function onChange(event:Event):void 
			{
				trace('we have vide!')
				hide();
			}
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
	}

}