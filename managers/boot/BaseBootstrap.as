package core.managers.boot 
{
	import core.data.variables.FlashVars;
	import core.events.TaskEvent;
	import core.managers.tasks.TaskQueue;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	/**
	 * Base Bootstrap provides a single place to queue, load and handle essential 
	 * bootstrap tasks. By default it does the following basic tasks only:
	 * 
	 *  - parsing flashvars
	 *  - adding tasks
	 *  - complete, progress, error and cancel events
	 * 
	 * @author Dave Stewart
	 */
	public class BaseBootstrap extends EventDispatcher
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements
				protected var queue					:TaskQueue;
					
			// flashvars	
				protected var _flashvars			:FlashVars;
				public function get flashvars()		:FlashVars { return _flashvars; }
					
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function BaseBootstrap(root:DisplayObjectContainer)
			{
				// properties
					_flashvars		= new FlashVars(root);
				
				// task queue
					queue = TaskQueue.create()
						.when(TaskEvent.COMPLETE, onComplete)
						.when(TaskEvent.PROGRESS, onProgress)
						.when(TaskEvent.ERROR, onError)
						.when(TaskEvent.CANCEL, onError);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function add(task:Function, name:String = null):BaseBootstrap
			{
				queue.add(task, name);
				return this;
			}
			
			public function start():void 
			{
				queue.start();
			}
			
			public function run(tasks:*):void 
			{
				queue.run(tasks);
			}
			
			public function cancel():void 
			{
				queue.cancel();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			/**
			 * Moves the queue on to the next task
			 * @param	...rest		
			 */
			protected function next(...rest):void 
			{
				queue.next();
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onProgress(event:TaskEvent):void 
			{
				dispatchEvent(new TaskEvent(TaskEvent.PROGRESS, event.data));
			}
			
			protected function onComplete(event:TaskEvent):void 
			{
				trace('BootManager: bootstrap complete');
				///dispatchEvent(event);
				dispatchEvent(new TaskEvent(TaskEvent.PROGRESS, queue.progress));
				dispatchEvent(new TaskEvent(TaskEvent.COMPLETE));
			}
			
			protected function onError(event:TaskEvent):void 
			{
				trace('BootManager: bootstrap failed');
				//dispatchEvent(new Event(TaskEvent.ERROR)); // event ?
				dispatchEvent(new TaskEvent(TaskEvent.ERROR));
				//dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
			
			protected function onCancel(event:TaskEvent):void 
			{
				trace('BootManager: bootstrap cancelled');
				dispatchEvent(new TaskEvent(TaskEvent.CANCEL));
			}
			
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function log(message:String):void 
			{
				dispatchEvent(new TaskEvent(TaskEvent.STATUS, message, false, false));
			}
			
		
			
	}

}