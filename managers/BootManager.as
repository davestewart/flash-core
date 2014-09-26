package core.managers 
{
	import app.controllers.AppController;
	import core.data.variables.FlashVars;
	import core.events.ActionEvent;
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
						.when(TaskQueue.COMPLETE, onComplete)
						.when(TaskQueue.ERROR, onError)
						.when(TaskQueue.CANCEL, onError);
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
		
			protected function onComplete(event:Event):void 
			{
				trace('bootstrap complete');
				dispatchEvent(event);
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			protected function onError(event:Event):void 
			{
				trace('bootstrap failed');
				dispatchEvent(new Event(TaskQueue.ERROR)); // event ?
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
			
			protected function onCancel(event:Event):void 
			{
				trace('bootstrap cancelled');
				dispatchEvent(new Event(TaskQueue.CANCEL));
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
			
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function log(message:String):void 
			{
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, message));
			}
			
		
			
	}

}