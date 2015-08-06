package core.data.settings 
{
	import core.events.ValueEvent;
	import core.utils.Objects;
	import flash.errors.IllegalOperationError;
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
				protected var _name			:String;
				protected var _data			:Object;
				protected var _sealed		:Boolean;
				protected var _handlers		:Array;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			/**
			 * 
			 * @param	name		
			 * @param	sealed	
			 * @param	props		
			 * @param	copy		
			 */
			public function Settings(name:String = 'Settings', sealed:Boolean = false, props:* = null, copy:Boolean = false) 
			{
				// properties
				_name		= name;
				_sealed		= sealed;
				_data		= {};
				_handlers	= [];
				
				// initialize
				if (props)
				{
					// String
					if (props is String)
					{
						props = (props as String).match(/\w+/g);
					}
					
					// Array
					if (props is Array)
					{
						for (var i:int = 0; i < props.length; i++) 
						{
							_data[props[i]] = null;
						}
					}
					
					// any iterable object
					else
					{
						for (var name:String in props)
						{
							_data[name] = copy ? props[name] : null;
						}
					}
				}
			}
			
			public static function create(props:*, copy:Boolean = false, sealed:Boolean = false):Settings
			{
				return new Settings('Settings', sealed, props, copy);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function set(prop:*, value:* = null, silent:Boolean = false):Settings 
			{
				// if a single object is passed, copy its properties
				if (arguments.length === 1)
				{
					for (var name:String in prop)
					{
						if (name in _data)
						{						
							set(name, prop[name], true);
						}
					}
					return this;
				}

				// otherwise, set a single property value
				else
				{
					if ( ! _sealed || prop in _data)
					{
						_data[prop] = value;
						if ( ! silent )
						{
							trigger(prop);
						}
					}
					else
					{
						throw new ReferenceError('Invalid access to property ' +prop+ ' on settings object ' +_name);
					}
				}
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
			
			public function trigger(name:String = null):void 
			{
				var value:* = _data[name];
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
				return '[object ' +_name+ ' ' +arr.join(' ')+ ']';
			}
						
	}

}