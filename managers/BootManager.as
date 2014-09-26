package core.managers 
{
	import app.controllers.AppController;
	import core.data.variables.FlashVars;
	import core.events.ActionEvent;
	import core.events.TaskEvent;
	import core.managers.AssetManager;
	import core.managers.TaskQueue;
	import flash.display.DisplayObjectContainer;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class BootManager extends EventDispatcher
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// properties
				protected var queue				:TaskQueue;
				
			// loading
				protected var loader			:AssetManager;
				
			// environment
				protected var _env					:String;
				public function get env():String { return _env; }

			// data
				protected var _flashvars			:FlashVars;
				public function get flashvars():FlashVars { return _flashvars; }
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function BootManager(root:DisplayObjectContainer = null, environment:String = '') 
			{
				// flashvars
					if (root)
					{
						_flashvars = new FlashVars(root);
					}
				
				// set base environment from flashvars
					_env = flashvars.env || flashvars.environment || environment;
						
				// task queue
					queue = TaskQueue.create()
						.when(TaskEvent.COMPLETE, onComplete)
						.when(TaskEvent.PROGRESS, onProgress)
						.when(TaskEvent.ERROR, onError)
						.when(TaskEvent.CANCEL, onError);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function add(task:Function):BootManager
			{
				queue.then(task);
				return this;
			}
			
			public function start():void 
			{
				queue.start();
			}
			
			public function cancel():void 
			{
				queue.cancel();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
		
			protected function next(...rest):void 
			{
				queue.next();
			}
			
			protected function reset():void 
			{
				if (loader)
				{
					loader.queue.dispose();
				}
				loader = new AssetManager();
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