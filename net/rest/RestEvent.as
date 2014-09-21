package core.net.rest 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class RestEvent extends Event 
	{
		
		static public const SUCCESS		:String		= 'RestEvent.SUCCESS';
		static public const ERROR		:String		= 'RestEvent.ERROR';
		
		public var event				:Event;
		public var data					:*;
		
		public function RestEvent(type:String, data:*, event:Event, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.event	= event;
			this.data	= data;
		} 
		
		public override function clone():Event 
		{ 
			return new RestEvent(type, data, event, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("RestEvent", "data", "event", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}