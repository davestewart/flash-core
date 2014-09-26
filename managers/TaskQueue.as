package core.managers 
{
	import flash.events.EventDispatcher;
	import core.events.TaskEvent;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class TaskQueue extends EventDispatcher 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
			
			// properties
				protected var _tasks				:Vector.<Function>;
				
			// variables
				protected var _index				:int;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function TaskQueue() 
			{
				clear();
			}
			
			public static function create():TaskQueue 
			{
				return new TaskQueue();
			}
			
			public static function build(tasks:Array, onComplete:Function, onError:Function = null):TaskQueue
			{
				// set up queue
					var queue:TaskQueue = create().when(TaskEvent.COMPLETE, onComplete);
					
				// add optional handlers
					if (onError is Function)
					{
						queue.when(TaskEvent.ERROR, onError);
					}
					
				// add tasks
					for each(var task:Function in tasks)
					{
						queue.add(task);
					}
					
				// return
					return queue;
			}
		

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			// add or remove tasks
			
				public function add(task:Function):TaskQueue 
				{
					_tasks.push(task);
					return this;
				}
				
				public function addMany(...tasks):TaskQueue 
				{
					for each(var task:Function in tasks)
					{
						add(task);
					}
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
					_index	= -1;
					_tasks	= new Vector.<Function>;
					return this;
				}
				
			// start execution
			
				/**
				 * Starts loading, dispatching a START event
				 * @return
				 */
				public function start():TaskQueue 
				{
					dispatchEvent(new TaskEvent(TaskEvent.START));
					dispatchEvent(new TaskEvent(TaskEvent.PROGRESS, 0));
					next();
					return this;
				}
				
				/**
				 * Continues with the next task, dispatching a PROGRESS event
				 * @param	...rest
				 * @return
				 */
				public function next(...rest):TaskQueue
				{
					onNext();
					return this;
				}
				
				/**
				 * Signals an error, but continues with the next task, dispatching ERROR and PROGRESS events
				 * @param	...rest
				 * @return
				 */
				public function error(...rest):TaskQueue
				{
					onNext(true);
					return this;
				}
				
				/**
				 * Signals an error, and stops, dispatching a CANCEL event
				 * @param	...rest
				 * @return
				 */
				public function cancel(...rest):TaskQueue 
				{
					dispatchEvent(new TaskEvent(TaskEvent.CANCEL));
					return this;
				}
				
				/**
				 * Signals completion, and stops, dispatching a COMPLETE event
				 * @return
				 */
				public function complete():TaskQueue
				{
					dispatchEvent(new TaskEvent(TaskEvent.COMPLETE));
					return this;
				}
				
			// event handlers
			
				public function then(task:Function, skip:Boolean = false):TaskQueue
				{
					return skip ? this : add(task);
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
		
			public function get progress():Number
			{
				return index / length;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function onNext(error:Boolean = false):void 
			{
				if (_index < _tasks.length - 1)
				{
					if (error)
					{
						dispatchEvent(new TaskEvent(TaskEvent.ERROR, error));
					}
					_tasks[++_index]();
					
					// this appears to be buggy - check index update - are they 1 less than they should be?
					//dispatchEvent(new TaskEvent(TaskEvent.PROGRESS, progress));
				}
				else
				{
					complete();
				}
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}

