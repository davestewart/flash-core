package core.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class ActionEvent extends Event 
	{
		public var name					:String;
		public var value				:*;
		
		public static const ACTION		:String		= 'ActionEvent.ACTION';
		
		public function ActionEvent(name:String, value:* = null, bubbles:Boolean = true, cancelable:Boolean = false)
		{ 
			super(ACTION, bubbles, cancelable);
			this.name = name;
			this.value = value;
		} 
		
		public override function clone():Event 
		{ 
			return new ActionEvent(name, value, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ActionEvent", "name", "value", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}