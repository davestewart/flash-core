package core.media.audio 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class AudioEvent extends Event 
	{
		
		public static const START			:String	= 'AudioEvent.START';
		public static const SEEK			:String	= 'AudioEvent.SEEK';
		public static const PAUSE			:String	= 'AudioEvent.PAUSE';
		public static const UNPAUSE			:String	= 'AudioEvent.UNPAUSE';
		public static const STOP			:String	= 'AudioEvent.STOP';
		public static const PROGRESS		:String	= 'AudioEvent.PROGRESS';
		public static const COMPLETE		:String	= 'AudioEvent.COMPLETE';
		public static const LOADED			:String	= 'AudioEvent.LOADED';		
		
		public function AudioEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new AudioEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AudioEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}