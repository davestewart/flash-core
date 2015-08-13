package core.media.video 
{
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
	 * Instantiates a basic NetStreamVideo, then manages playback
	 * 
	 * Encoding live video to H.264/AVC with Flash Player 11
	 * http://www.adobe.com/devnet/adobe-media-server/articles/encoding-live-video-h264.html
	 * 
	 * @author Dave Stewart
	 */
	public class VideoPlayer extends Sprite 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements
				public var video						:Video;
				public var container					:Sprite;
				
			// objects
				protected var _stream					:NetStream;
				protected var _media					:MediaStream;
				
			// video properties
				protected var _flipped					:Boolean;
				protected var _autosize					:Boolean;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoPlayer(width:uint = 320, height:uint = 180) 
			{
				initialize();
				build(width, height);
			}
		
			protected function initialize():void 
			{
				// objects
				_media		= new MediaStream(this);
				_stream		= media.stream;
				
				// events
				addEventListener(MediaEvent.RESET, onReset);
				addEventListener(MediaEvent.METADATA, onMetaData);
				addEventListener(MediaEvent.CLOSED, onClosed);
			}
			
			protected function build(width:Number, height:Number):void 
			{
				// container
					container		= new Sprite();
					container.name	= 'container';
					addChild(container);
					
				// video
					video			= new Video(width, height);
					video.name		= 'video';
					video.smoothing	= true
					video.attachNetStream(media.stream);
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
		
			public function load(url:String, autoplay:Boolean = false):Boolean 
			{
				return media.load(url, autoplay);
			}
		
			public function play():Boolean
			{
				return media.play();
			}
			
			public function replay():Boolean
			{
				return media.replay();
			}

			public function pause():Boolean
			{
				return media.pause();
			}
			
			public function stop():Boolean
			{
				return media.stop();
			}
			
			public function rewind():Boolean
			{
				return media.rewind();
			}

			public function clear():void 
			{
				video.clear();
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get media():MediaStream { return _media; }
			
			override public function set width(value:Number):void 
			{
				video.width = value;
				draw();
			}
			
			override public function set height(value:Number):void 
			{
				video.height = value;
				draw();
			}
			
			public function get flipped():Boolean { return _flipped; }
			public function set flipped(value:Boolean):void 
			{
				_flipped = value;
				draw();
			}
			
			public function get autosize():Boolean { return _autosize; }
			public function set autosize(value:Boolean):void 
			{
				_autosize = value;
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
				
			protected function draw():void 
			{
				container.scaleX	= _flipped ? -1 : 1;
				container.x			= _flipped ? video.width : 0;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onReset(event:MediaEvent):void 
			{
				// re-attach stream to video if it's been renewed
				if (_stream !== media.stream)
				{
					video.attachNetStream(media.stream);
				}
			}
			
			public function onMetaData(event:MediaEvent) :void
			{
				if (_autosize)
				{
					if(video.width !== media.videoWidth || video.height !== media.videoHeight)
					video.width		= media.videoWidth;
					video.height	= media.videoHeight;
					draw();
					dispatchEvent(new Event(Event.RESIZE));
				}
			}
			
			protected function onClosed(event:MediaEvent):void 
			{
				video.attachNetStream(null);
				clear();
			}
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
	}

}