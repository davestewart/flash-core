package core.media.video {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class CameraEvent extends Event 
	{
		
		public static const NO_CAMERA			:String	= 'CameraEvent.NO_CAMERA';
		public static const NO_MICROPHONE		:String	= 'CameraEvent.NO_MICROPHONE';
		public static const ACTIVATED			:String	= 'CameraEvent.ACTIVATED';
		public static const NOT_ACTIVATED		:String	= 'CameraEvent.NOT_ACTIVATED';
		public static const SIZE_CHANGE			:String	= 'CameraEvent.SIZE_CHANGE';
		public static const SIZE_ERROR			:String	= 'CameraEvent.SIZE_ERROR';

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