package core.managers.taskqueue 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class TaskQueueEvent extends Event 
	{
		
		public function TaskQueueEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TaskQueueEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TaskQueueEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}