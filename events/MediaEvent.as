package core.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class MediaEvent extends Event 
	{
		
		public static const START			:String	= 'MediaEvent.START';
		public static const SEEK			:String	= 'MediaEvent.SEEK';
		public static const PAUSE			:String	= 'MediaEvent.PAUSE';
		public static const UNPAUSE			:String	= 'MediaEvent.UNPAUSE';
		public static const STOP			:String	= 'MediaEvent.STOP';
		
		public static const PROGRESS		:String	= 'MediaEvent.PROGRESS';
		public static const BUFFERING		:String	= 'MediaEvent.BUFFERING';
		public static const COMPLETE		:String	= 'MediaEvent.COMPLETE';
		public static const LOADED			:String	= 'MediaEvent.LOADED';		
		
		public function MediaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new MediaEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AudioEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}