package core.managers 
{
	import app.controllers.AppController;
	import app.events.AppEvent;
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
				
			// data
				public var flashvars			:FlashVars;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function BootManager(root:DisplayObjectContainer = null) 
			{
				// task queue
					queue = TaskQueue.create()
						.when(TaskQueue.COMPLETE, onComplete)
						//.when(TaskQueue.CANCEL, onError)
						.when(TaskQueue.ERROR, onError);
						
				// flashvars
					if (root)
					{
						flashvars = new FlashVars(root);
					}
					
			}
			
			public function add(task:Function):BootManager
			{
				queue.then(task);
				return this;
			}
			
			public function start():void 
			{
				queue.start();
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
				log('bootstrap complete!');
				dispatchEvent(event);
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			protected function onError(event:Event):void 
			{
				log('bootstrap failed');
				dispatchEvent(new Event(TaskQueue.ERROR)); // event ?
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