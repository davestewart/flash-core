package core.media.video 
{
	import core.display.elements.Invalidatable;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetStream;
		
	import core.events.MediaEvent;
	import core.media.net.MediaStream;
	
	/**
	 * Base class to place a video screen, potentially with mask, on the page
	 * 
	 * @author Dave Stewart
	 */
	public class VideoBase extends Invalidatable 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements
				public var video				:Video;
				public var container			:Sprite;
				                            
			// properties             
				protected var _width			:uint;
				protected var _height			:uint;
				protected var _autosize			:Boolean;
				protected var _flipped			:Boolean;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoBase(width:uint = 320, height:uint = 180) 
			{
				// parameters
				_height		= height;
				_width		= width;
				
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
				// container
					container			= new Sprite();
					container.name		= 'container';
					addChild(container);
					
				// video
					video				= new Video(_width, _height);
					video.name			= 'video';
					video.smoothing		= true
					container.addChild(video);
					
				// size / layout / masking
					// need to add some code in to handle resizing, masking, etc
					// http://blog.gskinner.com/archives/2006/11/understanding_d.html
					
					/*
					if (height > 360)
						container.scrollRect = new Rectangle(0, 0, width, 360);
					var vidMask:Square = new Square(640, 360);
					addChild(vidMask);
					container.mask = vidMask;
					*/
					
				// update
					draw();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function clear():void 
			{
				video.clear();
			}
			
			public function setSize(width:Number, height:Number):void
			{
				this.width	= width;
				this.height	= height;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			override public function set width(value:Number):void 
			{
				_width = value;
				invalidate();
			}
			
			override public function set height(value:Number):void 
			{
				_height = value;
				invalidate();
			}
			
			public function get flipped():Boolean { return _flipped; }
			public function set flipped(value:Boolean):void 
			{
				_flipped = value;
				invalidate();
			}
			
			public function get autosize():Boolean { return _autosize; }
			public function set autosize(value:Boolean):void 
			{
				_autosize = value;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
				
			override protected function draw():void 
			{
				// background
				graphics.clear();
				graphics.beginFill(0xF5F5F5);
				graphics.drawRect(0, 0, _width, _height);
				
				// video
				video.width			= _width;
				video.height		= _height;
				
				// container
				container.scaleX	= _flipped ? -1 : 1;
				container.x			= _flipped ? video.width : 0;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
	}

}