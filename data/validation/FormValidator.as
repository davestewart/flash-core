package core.data.validation 
{
	import core.display.forms.IControl;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class FormValidator extends EventDispatcher 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// elements
				public var form			:DisplayObjectContainer;
				public var parameters	:XML;
				
				
			// variables
				public var validator	:Validator;
				public var errors		:Object;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function FormValidator(form:DisplayObjectContainer, parameters:XML = null) 
			{
				form			= form;
				parameters		= parameters;
				validator		= new Validator();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function validate(parameters:XML = null):Boolean
			{
				// errors
					this.errors						= { };
					
				// variables
					var state		:Boolean		= true;
					var control		:*;
					var name		:String;
					var rule		:String;
					var value		:*;
					var errors		:Array;
					
				// parameters
					parameters		= parameters || this.parameters;
					
				// debug
					trace('FormValidator: validating ' + form);
					
				// validate
					for each(var parameter:XML in parameters.parameter)
					{
						// variables
							name		= parameter.@name;
							rule		= parameter.@validation;
							
						// debug
							//trace('parameter: ' + parameter.toXMLString(), rule)
							
						// attempt to validate
							if (rule)
							{
								//trace('rule: ' + rule);
								control	= getControl(name);
								if (control)
								{
									// get value
										value = getValue(control);
										
									// get errors
										errors = validator.validateOne(value, rule);
										
									// debug
										//trace('control: ' + control);
										
									// if there's an error, store it
										if (errors.length)
										{
											state				= false;
											this.errors[name]	= errors;
										}
										
									// update control
										setError(control, errors ? errors.join('. ') : '');
								}

							}
					}
					
				// return	
					return state;
			}
			
			public function validateControl(control:IControl):Boolean
			{
				// variables
					var state		:Boolean		= true;
					var control		:IControl;
					var name		:String;
					var rule		:String;
					var value		:*;
					var errors		:Array;
					var parameter	:XMLList		= parameters.parameter.(attribute('name') == control.name);
					
				// debug
					//trace('\ncontrol: ' + control);
					//trace('parameter: ' + parameter.toXMLString())
					
				// validate
					if(parameter.length())
					{
						// variables
							name		= parameter.@name;
							rule		= parameter.@validation;
							
						// attempt to validate
							if (rule)
							{
								// value
									value = getValue(control);
									
								// errors
									errors = validator.validateOne(value, rule);
									
								// debug
									//trace('rule: ' + rule);
									//trace('value: ' + control.value, typeof control.value);
									//trace('errors: ' + errors);
									
								// do something about it
									if (errors.length)
									{
										state = false;
									}
									
								// update control
									setError(control, errors ? errors.join('. ') : '');
							}
					}
					
				// return	
					return state;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function getValue(control:*):* 
			{
				return (control as IControl).value;
			}
			
			protected function setError(control:*, error:String):void 
			{
				(control as IControl).error = error;
			}
			
			protected function getControl(name:String):*
			{
				return form.getChildByName(name) as IControl;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}


}