package core.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class TaskEvent extends Event 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				public static const NOT_STARTED		:String	= 'Task.NOT_STARTED';
				public static const START			:String	= 'Task.START';
				static public const STATUS			:String = 'Task.STATUS';
				public static const PROGRESS		:String	= 'Task.PROGRESS';
				public static const COMPLETE		:String	= 'Task.COMPLETE';
				public static const CANCEL			:String	= 'Task.CANCEL';
				public static const ERROR			:String	= 'Task.ERROR';
				
			// properties
				public var data						:*;
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			public function TaskEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
			{ 
				super(type, bubbles, cancelable);
				this.data = data;
			} 
			
			public override function clone():Event 
			{ 
				return new TaskEvent(type, data, bubbles, cancelable);
			} 
			
			public override function toString():String 
			{ 
				return formatToString('TaskEvent', 'type', 'data', 'bubbles', 'cancelable', 'eventPhase'); 
			}
		
	}
	
}