import core.net.rest.old.RestEvent;
import core.net.old.core.net.rest.old.RestErrorEvent;
package core.net.rest.old core.net.old {
	core.net.old.RestErrorEvent	
	imcore.net.old.RestErrorEvent	public class RestErrorEvent extends RestEvent
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