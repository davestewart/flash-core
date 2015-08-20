package core.media.video 
{
	import flash.events.Event;
	import flash.net.NetStream;
	
	import core.events.MediaEvent;
	import core.media.net.MediaStream;
	
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
				protected var _stream					:NetStream;
				protected var _media					:MediaStream;
				
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
				_media		= new MediaStream(this);
				_stream		= media.stream;
				
				// events
				addEventListener(MediaEvent.RESET, onReset);
				addEventListener(MediaEvent.LOADED, onLoad, false, 100);
				addEventListener(MediaEvent.METADATA, onMetaData);
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
		
			public function get media():MediaStream { return _media; }
			
			
			
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
				// re-attach stream to video if it's been renewed
				if (_stream !== media.stream)
				{
					video.attachNetStream(media.stream);
				}
			}
			
			public function onMetaData(event:MediaEvent) :void
			{
				// old set video size - left here whilst we ensure that the same functionality in the onLoad handler
				video.width		= media.videoWidth;
				video.height	= media.videoHeight;
				viewport.redraw();

				// set player size
				if (_autosize)
				{
					if (viewport.width !== media.videoWidth || viewport.height !== media.videoHeight)
					{
						viewport.setSize(media.videoWidth, media.videoHeight);
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