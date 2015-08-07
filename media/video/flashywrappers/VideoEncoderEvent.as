package core.media.video.flashywrappers 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoEncoderEvent extends Event 
	{
		
		/// The encoder has is loading
		public static const LOADING				:String		= 'VideoEncoderEvent.LOADING';
		
		/// The encoder has loaded
		public static const LOADED				:String		= 'VideoEncoderEvent.LOADED';
		
		/// The encoder is ready
		public static const READY				:String		= 'VideoEncoderEvent.READY';
		
		/// The encoder has captured a frame
		public static const CAPTURED			:String		= 'VideoEncoderEvent.CAPTURED';

		/// The encoder has started encoding
		public static const ENCODING			:String		= 'VideoEncoderEvent.ENCODING';
		
		/// The encoder has finished encoding
		public static const FINISHED			:String		= 'VideoEncoderEvent.FINISHED';
		
		public function VideoEncoderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new VideoEncoderEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("VideoEncoderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}