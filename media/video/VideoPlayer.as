package core.media.video 
{
	import flash.events.Event;
	import flash.net.NetStream;
	
	import core.events.MediaEvent;
	import core.media.streams.VideoStream;
	
	/**
	 * Instantiates MediaStream object, and manages playback
	 * 
	 * Encoding live video to H.264/AVC with Flash Player 11
	 * http://www.adobe.com/devnet/adobe-media-server/articles/encoding-live-video-h264.html
	 * 
	 * @author Dave Stewart
	 */
	public class VideoPlayer extends VideoBase 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements

			
			// objects
				protected var _media					:VideoStream;
				
			// video properties

			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoPlayer(width:uint = 320, height:uint = 180) 
			{
				super(width, height);
			}
		
			override protected function initialize():void 
			{
				// objects
				_media		= new VideoStream(this);
				
				// events
				addEventListener(MediaEvent.RESET, onReset);
				addEventListener(MediaEvent.LOADED, onLoad, false, 100);
				addEventListener(MediaEvent.METADATA, onMetadata);
				addEventListener(MediaEvent.CLOSED, onClosed);
			}
			
			override protected function build():void 
			{
				super.build();
				video.attachNetStream(media.stream);
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

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get media():VideoStream { return _media; }
			
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
				
				
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onLoad(event:MediaEvent):void 
			{
				// set video size
				/*
				if (video.videoWidth > 0)
				{
					video.width		= video.videoWidth;
					video.height	= video.videoHeight;
					viewport.redraw();
				}
				*/
			}
			
			protected function onReset(event:MediaEvent):void 
			{
				video.attachNetStream(media.stream);
			}
			
			public function onMetadata(event:MediaEvent) :void
			{
				// old set video size - left here whilst we ensure that the same functionality in the onLoad handler
				video.width		= media.width;
				video.height	= media.height;
				viewport.redraw();

				// set player size
				if (_autosize)
				{
					if (viewport.width !== media.width || viewport.height !== media.height)
					{
						viewport.setSize(media.width, media.height);
						viewport.redraw();
						dispatchEvent(new Event(Event.RESIZE));
					}
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