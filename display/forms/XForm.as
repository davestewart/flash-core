package core.display.forms 
{
	import core.net.rest.RestClient;
	import flash.display.Sprite;

	import core.data.validation.Validator;
	import core.display.elements.Element;
	import core.display.forms.IControl;
	
	/**
	 * Base Form class which allows validation of on-stage form control (IControl) elements
	 * 
	 * @author Dave Stewart
	 */
	public class XForm extends Element
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var parameters	:XML;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function XForm() 
			{

			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			public function validate():Boolean
			{
				// variables
					var validator	:Validator		= new Validator();
					var state		:Boolean		= true;
					var control		:IControl;
					var name		:String;
					var rule		:String;
					var errors		:Array;
					
				// debug
					trace('Form: validating...');
					
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
								control	= getChildByName(name) as IControl;
								if (control)
								{
									//trace('control: ' + control);
									errors = validator.validateOne(control.value, rule);
									if (errors.length)
									{
										control.error = errors.join('. ');
										state = false;
									}
								}

							}
					}
					
				// return	
					return state;
			}
			
			public function validateControl(control:IControl):Boolean
			{
				// variables
					var validator	:Validator		= new Validator();
					var state		:Boolean		= true;
					var control		:IControl;
					var name		:String;
					var rule		:String;
					var errors		:Array;
					var parameter	:XMLList		= parameters.parameter.(attribute('name') == control.name);
					
				// debug
					//trace('\ncontrol: ' + control);
					//trace('parameter: ' + parameter.toXMLString())
					
				// reset control
					control.error = '';
					
				// validate
					if(parameter.length())
					{
						// variables
							name		= parameter.@name;
							rule		= parameter.@validation;
							
						// attempt to validate
							if (rule)
							{
								//trace('rule: ' + rule);
								//trace('value: ' + control.value, typeof control.value);
								
								errors = validator.validateOne(control.value, rule);
								//trace('errors: ' + errors);
								if (errors.length)
								{
									control.error = errors.join('. ');
									state = false;
								}
							}
					}
					
				// return	
					return state;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}