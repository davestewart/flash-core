package core.net.rest
{
	import flash.events.Event;
	
	import mx.rpc.AsyncToken;
	
	public class RestErrorEvent extends RestEvent
	{
		public static const FAILURE				:String = 'RestErrorEvent.FAILURE';
		public static const IOERROR				:String	= 'RestErrorEvent.IOERROR';
		public static const ACCESS_DENIED		:String = 'RestErrorEvent.ACCESS_DENIED';
		
		public function RestErrorEvent(type:String, data:*= null, statuscode:int = -1, message:String = null, token:AsyncToken = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, statuscode, message, token, bubbles, cancelable);
		}

		public override function clone():Event
		{
			return new RestErrorEvent(type, data, statuscode, message, token, bubbles, cancelable);
		}
	
	}
}