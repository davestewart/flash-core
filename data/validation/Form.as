package core.data.validation 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import core.data.validation.IControl;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Form
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// elements
				public var container	:DisplayObjectContainer;
				
			// properties
				public var parameters	:XML;
				public var validator	:Validator;
				public var errors		:Object;
				
			// controls
				//public var controls	:Object;
				//public var parameters	:Object;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Form(container:DisplayObjectContainer, parameters:XML) 
			{
				// parameters
					this.container		= container;
					this.parameters		= parameters;
					
				// properties
					validator			= new Validator();
					errors				= { };
					
				// initialize
					initialize();
			}
			
			protected function initialize():void 
			{
				// override in subclasses to initialize form
				container.addEventListener(Event.CHANGE, onChange);
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function validate():Boolean
			{
				// errors
					errors							= { };
					
				// variables
					var state		:Boolean		= true;
					
				// debug
					trace('FormValidator: validating ' + container);
					
				// validate
					for each(var control:IControl in controls)
					{
						if ( ! validateControl(control) )
						{
							state = false;
						}
					}
					
				// return	
					return state;
			}
			
			public function validateControl(control:IControl, forceRequired:Boolean = false):Boolean
			{
				// variables
					var state		:Boolean		= true;
					var control		:IControl;
					var name		:String;
					var rules		:String;
					var value		:*;
					var errors		:Array;
					var parameter	:XML			= this.parameter(control.name);
					
				// debug
					//trace('\ncontrol: ' + control);
					//trace('parameter: ' + parameter.toXMLString())
					
				// validate
					if(parameter)
					{
						// variables
							rules		= parameter.@validation;
							
						// attempt to validate
							if (rules)
							{
								// value
									value	= getValue(control);
									errors	= validator.validateOne(value, rules, forceRequired);
									
								// do something about it
									if (errors.length)
									{
										this.errors[name] = errors;
										state = false;
									}
									else
									{
										delete this.errors[name];
									}
									
								// update control
									setError(control, errors);
							}
					}
					
				// return	
					return state;
			}
			
			public function clear():void
			{
				// variables
					var name		:String;
					var control		:IControl;
					
				// do it
					for each(var parameter:XML in parameters.*)
					{
						name		= parameter.@name;
						control		= getControl(name) as IControl;
						if (control)
						{
							control.clear();
						}
					}
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get controls():Vector.<IControl>
			{
				// variables
					var controls:Vector.<IControl> = new Vector.<IControl>;
					
				// get controls
					for each(var parameter:XML in parameters.*)
					{
						var name		:String		= parameter.@name;
						var control		:IControl	= getControl(name);
						if (control)
						{
							controls.push(control) as IControl;
						}
					}
					
				// return
					return controls;
			}

			public function get values():Object
			{
				// variables
					var values:Object = { };
					
				// get values
					for each(var control:IControl in controls)
					{
						values[control.name] = control.value;
					}
					
				// return
					return values;
			}


			public function control(name:String):*
			{
				return getControl(name);
			}

			public function value(name:String):*
			{
				return getControl(name).value;
			}
		
			public function parameter(param:String):XML
			{
				return parameters.*.(attribute('name') == param)[0];
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function getControl(name:String):*
			{
				return container.getChildByName(name) as IControl;
			}
			
			protected function getValue(control:*):* 
			{
				return (control as IControl).value;
			}
			
			protected function setError(control:*, errors:Array):void 
			{
				(control as IControl).error = errors ? errors[0] : ''; // show first error only
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onChange(event:Event):void 
			{
				if (event.target is IControl)
				{
					validateControl(event.target as IControl);
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}


}