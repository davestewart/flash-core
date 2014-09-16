package core.net.rest
{
	import flash.events.Event;
	
	import mx.rpc.AsyncToken;
	
	public class RestEvent extends Event
	{
		public static const SUCCESS		:String				= 'RestEvent.SUCCESS';

		public var data					:*;
		public var statuscode			:int;
		public var message				:String;
		public var token				:AsyncToken;
		
		public function RestEvent(type:String, data:*= null, statuscode:int = -1, message:String = null, token:AsyncToken = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.data			= data;
			this.statuscode		= statuscode;
			this.message		= message;
			this.token			= token;
		}

		
		public override function clone():Event
		{
			return new RestEvent(type, data, statuscode, message, token);
		}
	
	}
}