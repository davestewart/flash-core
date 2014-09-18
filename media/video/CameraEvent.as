package core.media.video 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class CameraEvent extends Event 
	{
		
		public function CameraEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new CameraEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CameraEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}