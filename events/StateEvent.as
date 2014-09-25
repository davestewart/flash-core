package core.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class StateEvent extends Event 
	{
		public var name					:String;
		public var value				:*;
		
		public static const CHANGE		:String		= 'StateEvent.CHANGE';
		
		public function StateEvent(name:String, value:* = null, bubbles:Boolean = true, cancelable:Boolean = false)
		{ 
			super(CHANGE, bubbles, cancelable);
			this.name = name;
			this.value = value;
		} 
		
		public override function clone():Event 
		{ 
			return new StateEvent(name, value, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StateEvent", "name", "value", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}