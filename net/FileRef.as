package core.net 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.FileReference;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class FileRef extends EventDispatcher 
	{
		
		// --------------------------------------------------------------------------------------------------------
		// variables
		
			// elements
				protected var file:FileReference;
				
		
		// --------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function FileRef() 
			{
				file = new FileReference();
				file.addEventListener(Event.COMPLETE, onSave);
				file.addEventListener(Event.CANCEL, onCancel);
				file.addEventListener(IOErrorEvent.IO_ERROR, onError);
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// public functions
		
			public function save(data:*, filename:String):void
			{
				file.save(data, filename);
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// protected methods
			
			protected function dispatch(message:String, level:String):void 
			{
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, message, level));
			}
			
			
		// --------------------------------------------------------------------------------------------------------
		// handlers
			
			protected function onSave(event:Event):void 
			{
				dispatchEvent(event);
				dispatch('File saved OK', 'success')
			}
			
			protected function onCancel(event:Event):void 
			{
				dispatchEvent(event);
				dispatch('The save was cancelled', 'error')
			}
		
			protected function onError(event:IOErrorEvent):void 
			{
				dispatchEvent(event);
				dispatch('There was a problem saving the file', 'error')
			}
			
	}

}