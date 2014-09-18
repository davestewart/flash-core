package core.utils.taskqueue 
{
	import flash.accessibility.Accessibility;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class TaskQueue extends EventDispatcher 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				public static const START			:String	= 'TaskQueue.START';
				public static const PROGRESS		:String	= 'TaskQueue.PROGRESS';
				public static const COMPLETE		:String	= 'TaskQueue.COMPLETE';
				public static const CANCEL			:String	= 'TaskQueue.CANCEL';
				public static const ERROR			:String	= 'TaskQueue.ERROR';				
			
			// properties
				protected var _scope			:*;
				protected var _tasks			:Vector.<Function>;
				
			// variables
				protected var _index				:int;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function TaskQueue(scope:*) 
			{
				_scope = scope || this;
				clear();
			}
			
			public static function create(scope:*):TaskQueue 
			{
				return new TaskQueue(scope);
			}
		

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			// add or remove tasks
			
				public function add(task:Function):TaskQueue 
				{
					_tasks.push(task);
					return this;
				}
				
				public function remove(task:*):void 
				{
					var index:int = task is Function
						? _tasks.indexOf(task)
						: task is int
							? task
							: _tasks.length - 1;
							
					_tasks.splice(index, 1);
				}
				
				public function clear():TaskQueue 
				{
					_index	= 0;
					_tasks	= new Vector.<Function>;
					return this;
				}
				
			// start execution
			
				public function start():TaskQueue 
				{
					dispatchEvent(new Event(START));
					next();
					return this;
				}
				
				public function next():TaskQueue
				{
					if (_index < _tasks.length - 1)
					{
						_tasks[++_index]();
						dispatchEvent(new Event(PROGRESS));
					}
					else
					{
						dispatchEvent(new Event(COMPLETE));
					}
					return this;
				}
				
				public function cancel():TaskQueue 
				{
					dispatchEvent(new Event(CANCEL));
					return this;
				}
				
				public function stop():TaskQueue
				{
					return this;
				}
				
			// event handlers
			
				public function then(task:Function):TaskQueue
				{
					return add(task);
				}
			
				public function when(event:String, handler:Function):TaskQueue 
				{
					addEventListener(event, handler);
					return this;
				}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get index():int 
			{
				return _index;
			}
			
			public function get length():int 
			{
				return _tasks.length;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}

