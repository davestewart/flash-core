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
		
		public var data					:*;
		public var token				:AsyncToken;
		
		public function RestEvent(type:String, data:*, token:AsyncToken, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.data	= data;
			this.token	= token;
		} 
		
		public override function clone():Event 
		{ 
			return new RestEvent(type, data, token, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("RestEvent", "type", "data", "token", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}