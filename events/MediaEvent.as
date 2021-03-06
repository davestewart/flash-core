package core.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 * 
	 * For future work on unified video and audio player base classes:
	 * 
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/fl/video/package-detail.html
	 * @see http://stackoverflow.com/questions/1863309/how-to-detect-when-video-is-buffering
	 * @see http://themeforest.net/forums/thread/as3-buffered-sound-has-started-event/33809
	 */
	public class MediaEvent extends Event 
	{
		// --------------------------------------------------------------------------------------------------------
		// constants
				
			// loading
				public static const LOADING					:String		= 'MediaEvent.LOADING';					// Dispatched when a URL has been called to open
				public static const PROGRESS				:String		= 'MediaEvent.PROGRESS';				// Dispatched every .25 seconds, starting when the load() method is called and ending when all bytes are loaded or there is a network error. You can specify frequency with the progressInterval property
				public static const READY					:String		= 'MediaEvent.READY';					// Dispatched when enough of the video has buffered to play
				public static const LOADED					:String		= 'MediaEvent.LOADED';					// Dispatched when all the video's byes have loaded
				public static const BUFFERING				:String		= 'MediaEvent.BUFFERING';				// Dispatched when the buffering state is entered
				public static const BUFFERED				:String		= 'MediaEvent.BUFFERED';				// Is this the same as ready?
				public static const CLOSED					:String		= 'MediaEvent.CLOSED';					// Dispatched when NetStream is closed, whether through timeout or a call to the close() method
															
			// playback
				public static const PLAYING					:String		= 'MediaEvent.PLAYING';					// Dispatched when the playing state is entered
				public static const PAUSED					:String		= 'MediaEvent.PAUSED';					// Dispatched when the pause state is entered
				public static const RESUMED					:String		= 'MediaEvent.RESUMED';					// Dispatched when playback resumes after paused state
				public static const STOPPED					:String		= 'MediaEvent.STOPPED';					// Dispatched when the stopped state is entered
				public static const REPEAT					:String		= 'MediaEvent.REPEAT';					// Dispatched when repeat is set to true and the stream repeats
		
			// seeking
				public static const SEEKING					:String		= 'MediaEvent.SEEKING';					// Dispatched when the location of the playhead is changed by a call to seek() or by using the corresponding control
				public static const SEEKED					:String		= 'MediaEvent.SEEKED';					// Dispatched when the location of the playhead is changed by a call to seek() or by using the corresponding control
				public static const REWIND					:String		= 'MediaEvent.REWIND';					// Dispatched when the location of the playhead is moved backward by a call to seek() or when the automatic rewind operation completes
				public static const FASTFORWARD				:String		= 'MediaEvent.FASTFORWARD';				// Dispatched when the location of the playhead is moved forward by a call to the seek() method
				
			// playing or recording	
				public static const STARTED					:String		= 'MediaEvent.STARTED';					// Dispatched when a stream started playing from the beginning
				public static const UPDATED					:String		= 'MediaEvent.UPDATED';					// Dispatched every 0.1 seconds by default while the media is playing
				public static const ENDED					:String		= 'MediaEvent.ENDED';					// Dispatched when playing completes by reaching the end of the stream
				public static const FINISHED				:String		= 'MediaEvent.FINISHED';				// Dispatched when a stream has completed playing and did not repeat
				
			// information
				public static const RESET					:String		= 'MediaEvent.RESET'					// Dispatched when the stream is reset
				public static const NETSTATUS				:String		= 'MediaEvent.NETSTATUS'				// Dispatched when the player receives a NetStatus event
				public static const STATE_CHANGE			:String		= 'MediaEvent.STATE_CHANGE'				// Dispatched when the playback state changes
				public static const SIZE_CHANGE				:String		= 'MediaEvent.SIZE_CHANGE'				// Dispatched when the playback state changes
				public static const RESIZE					:String		= 'MediaEvent.RESIZE'					// Dispatched when a video player is resized 
				public static const ERROR					:String		= 'MediaEvent.ERROR';					// Dispatched if there is an error
				
			// data
				public static const METADATA				:String		= 'MediaEvent.METADATA';
				public static const IMAGEDATA				:String		= 'MediaEvent.IMAGEDATA';
				public static const TEXTDATA				:String		= 'MediaEvent.TEXTDATA';
				public static const XMPDATA					:String		= 'MediaEvent.XMPDATA';
				public static const CUEPOINT				:String		= 'MediaEvent.CUEPOINT';
				static public const EVENT					:String		= 'MediaEvent.EVENT';
				
		// --------------------------------------------------------------------------------------------------------
		// properties
		
			public var data:*;

				
		// --------------------------------------------------------------------------------------------------------
		// methods
		
			public function MediaEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
			{ 
				super(type, bubbles, cancelable);
				this.data = data;
			} 
			
			public override function clone():Event 
			{ 
				return new MediaEvent(type, bubbles, cancelable);
			} 
			
			public override function toString():String 
			{ 
				return formatToString("MediaEvent", "type", "data", "bubbles", "cancelable", "eventPhase"); 
			}
		
	}
	
}