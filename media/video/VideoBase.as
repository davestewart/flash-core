package core.media.video 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Video;
		
	import core.display.layout.Viewport;
	
	/**
	 * Base class to place a video screen, potentially with mask, on the page
	 * 
	 * @author Dave Stewart
	 */
	public class VideoBase extends Sprite 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements
				public var viewport				:Viewport;
				public var video				:Video;
				
			// properties
				protected var _autosize			:Boolean;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoBase(width:uint = 320, height:uint = 180) 
			{
				// initial build
					viewport			= new Viewport(width, height);
					viewport.name		= 'viewport';
					viewport.border		= true;
					//viewport.crop		= false;
					addChild(viewport);
				
				// code
					initialize();
					build();
			}
		
			protected function initialize():void 
			{
				// override in subclasses
			}
			
			protected function build():void 
			{
				// video
					video				= new Video(viewport.width, viewport.height);
					video.name			= 'video';
					video.smoothing		= true
					
				// viewport
					viewport.addChild(video);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			/**
			 * Sets the size of the component
			 * 
			 * @param	width
			 * @param	height
			 */
			public function setSize(width:Number, height:Number):void 
			{
				viewport.width	= width;
				viewport.height	= height;
				viewport.invalidate();
			}
			
			/**
			 * Sets the size of the video element within the component
			 * 
			 * @param	width
			 * @param	height
			 */
			public function setVideoSize(width:Number, height:Number):void
			{
				video.width		= width;
				video.height	= height;
				viewport.invalidate();
			}
			
			public function clear():void 
			{
				video.clear();
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			override public function get width():Number { return viewport.width; }
			override public function set width(value:Number):void 
			{
				viewport.width = value;
			}
			
			override public function get height():Number { return viewport.height; }
			override public function set height(value:Number):void 
			{
				viewport.height = value;
			}
		
			public function get flipped():Boolean { return viewport.scaleX < 0; }
			public function set flipped(state:Boolean):void 
			{
				viewport.scaleX		= state ? -1 : 1;
				viewport.x			= state ? viewport.width : 0;
			}
			
			public function get autosize():Boolean { return _autosize; }
			public function set autosize(state:Boolean):void 
			{
				_autosize = state;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
				
				
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onSizeChange(event:Event):void 
			{
				
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
	}

}