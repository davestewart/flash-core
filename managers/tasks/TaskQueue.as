package core.managers.tasks {
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
				protected var _tasks				:Vector.<Task>;
				protected var _runningTasks			:Vector.<Task>;
				
			// variables
				protected var _index				:int;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function TaskQueue() 
			{
				clear();
			}
			
			public static function create(tasks:Array = null, onComplete:Function = null, onError:Function = null):TaskQueue
			{
				// set up queue
					var queue:TaskQueue = new TaskQueue();
					
				// add tasks
					if (tasks)
					{
						for each(var task:Function in tasks)
						{
							queue.add(task);
						}
					}
					
				// add optional handlers
					if (onComplete is Function)
					{
						queue.when(TaskEvent.COMPLETE, onComplete);
					}
					
					if (onError is Function)
					{
						queue.when(TaskEvent.ERROR, onError);
					}
					
				// return
					return queue;
			}
		

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			// add or remove tasks
			
				public function add(task:Function, name:String = null):TaskQueue 
				{
					_tasks.push(new Task(task, name || 'task' + _tasks.length));
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
					// variables
						var index	:int;
						var i		:int;
						
					// find index
						if (task is int)
						{
							index = task;
						}
						else if (task is Task)
						{
							index = _tasks.indexOf(task);
						}
						else if (task is Function)
						{
							for (i = 0; i < _tasks.length; i++) 
							{
								if (_tasks[i].func == task)
								{
									index = i;
									break;
								}
							}
						}
						else if (task is String)
						{
							for (i = 0; i < _tasks.length; i++) 
							{
								if (_tasks[i].name == task)
								{
									index = i;
									break;
								}
							}
						}
						else
						{
							index = _tasks.length - 1;
						}
						
					// remove
						_tasks.splice(index, 1);
				}
				
				public function clear():TaskQueue 
				{
					_index			= -1;
					_tasks			= new Vector.<Task>;
					_runningTasks	= new Vector.<Task>;
					return this;
				}
				
			// start execution
			
				/**
				 * Starts loading, dispatching a START event
				 * @return
				 */
				public function start():TaskQueue 
				{
					_runningTasks = _tasks;
					_run();
					return this;
				}
				
				/**
				 * Run a subset of named tasls
				 * @param	tasks
				 * @return
				 */
				public function run(tasks:* = null):TaskQueue 
				{
					// collate names
						var names:Array;
						if (tasks is String)
						{
							names = tasks.match(/\w+/g);
						}
						else if (tasks is Array)
						{
							names = tasks;
						}
						else
						{
							throw new Error('TaskQueue:run() expects an Array or String of task names');
						}
						
					// collate tasks
						_runningTasks = new Vector.<Task>;
						for (var i:int = 0; i < _tasks.length; i++) 
						{
							if (names.indexOf(_tasks[i].name) > -1)
							{
								_runningTasks.push(_tasks[i]);
							}
						}
					
					// run
						_run();
						return this;
				}
				
				/**
				 * Continues with the next task, dispatching a PROGRESS event
				 * @param	...rest
				 * @return
				 */
				public function next(...rest):TaskQueue
				{
					doNext();
					return this;
				}
				
				/**
				 * Signals an error, but continues with the next task, dispatching ERROR and PROGRESS events
				 * @param	...rest
				 * @return
				 */
				public function error(...rest):TaskQueue
				{
					dispatchEvent(new TaskEvent(TaskEvent.ERROR, error));
					doNext();
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
				
			// event handling
			
				/**
				 * Calls a function immediately before a task is about to run
				 * @param	name
				 * @param	handler
				 * @return
				 */
				public function before(name:String, handler:Function):TaskQueue 
				{
					// TODO implement before and after
					return this;
				}
				
				/**
				 * Calls a function immediately after a task has run
				 * @param	name
				 * @param	handler
				 * @return
				 */
				public function after(name:String, handler:Function):TaskQueue 
				{
					// TODO implement before and after
					return this;
				}
			
				public function when(event:String, handler:Function):TaskQueue 
				{
					addEventListener(event, handler);
					return this;
				}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get current():Task
			{
				return _runningTasks.length > 0 
					? _runningTasks[_index] 
					: null;
			}
			
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
				return index / _runningTasks.length;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function _run():void 
			{
				// variables
					_index = 0;
					
				// events
					dispatchEvent(new TaskEvent(TaskEvent.START));
					dispatchEvent(new TaskEvent(TaskEvent.PROGRESS, 0));
					
				// start
					doNext();
			}
		
			protected function doNext():void 
			{
				if (hasNext())
				{
					_runningTasks[_index++].exec();
				}
				else
				{
					complete();
				}
			}
		
			public function hasNext():Boolean
			{
				return _index < _runningTasks.length;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}

