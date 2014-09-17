package core.data.settings 
{
	import core.events.ValueEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Settings 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var _handlers		:Array;
				protected var _data			:Object;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Settings() 
			{
				_handlers	= [];
				_data		= {};
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function set(name:String, value:*, slilent:Boolean = false):Settings 
			{
				_data[name] = value;
				trigger(name, value);
				return this;
			}
			
			public function get(name:String):* 
			{
				return _data[name];
			}
			
			public function watch(handler:Function):Settings
			{
				if (_handlers.indexOf(handler) == -1)
				{
					_handlers.push(handler);
				}
				return this;
			}
			
			public function unwatch(handler:Function):Settings 
			{
				var index:int = _handlers.indexOf(handler)
				if (index > -1)
				{
					_handlers.splice(index, 1);
				}
				return this;
			}
			
			public function trigger(name:String = null, value:* = null):void 
			{
				for (var i:int = 0; i < _handlers.length; i++) 
				{
					_handlers[i](new ValueEvent(name, value));
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			public function toObject():Object
			{
				return _data;
			}
			
			public function toString():String
			{
				var arr:Array = [];
				for (var name:String in _data)
				{
					arr.push(name + '="' +_data[name]+ '"');
				}
				return '[object Settings ' +arr.join(' ')+ ']';
			}
			
			
	}

}