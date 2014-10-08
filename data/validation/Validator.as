package core.data.validation 
{
	
	import flash.errors.IllegalOperationError;
	/**
	 * ...
	 * @author Dave Stewart
	 */
	dynamic public class Validator
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: messages
		
				public var messages:Object = 
				{
					// generic
						'required'				:'This field is required',
						'invalid'				:'The input appears to be invalid',
						
					// patterns
						'email'					:'Must be a valid e-mail',
						'username'				:'Must be a valid username',
						'password'				:'Must be a valid password',
						'url'					:'Must be a valid URL',
						'creditcard'			:'Must be a valid credit card number',
						'date'					:'Must be a valid date',
						
					// locality
						'phone'					:'Must be a valid phone number',
						'postcode'				:'Must be a valid postcode',
						
					// types
						'alpha'					:'Must be letters',
						'alphanumeric'			:'Must be letters and numbers',
						'digits'				:'Must be digits',
						'numeric'				:'Must be a number',
						'resrict'				:'Must be {arg1} only',
						
					// string values
						'match'					:'Must be "{arg1}"',
						'contain'				:'Must contain "{arg1}"',
						
					// string lengths
						'length'				:'Must be {arg1} character(s)',
						'minlength'				:'Must be at least {arg1} characters',
						'maxlength'				:'Must be at most {arg1} characters',
						'rangelength'			:'Must be between {arg1} and {arg2} characters',
						
					// numeric values
						'value'					:'Must be {arg1}',
						'min'					:'Must be at least {arg1}',
						'max'					:'Must be at most {arg1}',
						'range'					:'Must be between {arg1} and {arg2}',
						
					// option selects
						'select'				:'Select {arg1} option(s)',
						'minselect'				:'Select at least {arg1} option(s)',
						'maxselect'				:'Select at most {arg1} option(s)',
						'rangeselect'			:'Select between {arg1} and {arg2} options',
						
					// constraints
						'equalto'				:'Must match {arg1}',
						
					// custom
						'question'				:'Must answer the question',
						'captcha'				:'Must complete the captcha'
				};
				
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				public var model			:Object;
				public var errors			:Object;
				public var state			:Boolean;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Validator(model:Object = null) 
			{
				this.model = model;
			}
			
			public static function factory(model:Object):Validator
			{
				return new Validator(model);
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function validate(rules:Object = null, model:Object = null):Boolean
			{
				// parameters
					model			= model || this.model;
					rules			= rules || this.model.rules;
					
				// properties
					this.state		= true;
					this.errors		= { };
					
				// variables
					var errors		:Array;
				
				// validate
					for (var name:String in rules)
					{
						// validate one
							errors	= validateOne(model[name], rules[name]);
							
						// add messages to error object
							if (errors.length > 0)
							{
								this.errors[name] = errors;
								state = false;
							}
					}
					
				// return
					return state;
			}
			
			public function validateOne(value:*, rule:String, forceRequired:Boolean = false):Array
			{
				// if force, ensure "required" is set first
					if (forceRequired && ! /\brequired\b/.test(rule))
					{
						rule = 'required ' + rule;
					}
				
				// validate if empty and not required
					if (isEmpty(value) && /\brequired\b/.test(rule) == false ) 
					{
						return [];
					}
					
				// variables
					var parameters	:Vector.<Parameter>	= parseRule(rule);
					var errors		:Array				= [];
					var method		:String;
					var args		:Array;
					var state		:Boolean;
					
				// otherwise, validate rule (comprising one or more tests)
					for each(var parameter:Parameter in parameters)
					{
						// variables
							method		= parameter.name;
							args		= [value].concat(parameter.args);
							
						// validate current test
							if (this[method] is Function)
							{
								state = (this[method] as Function).apply(this, args)
								if ( ! state )
								{
									errors.push(getMessage(method, parameter.args));
								}
							}
							else
							{
								throw new IllegalOperationError('The Validator method "' +method+ '" does not exist');
							}
					}
					
				// return
					return errors;
			}
			
			public function getErrorText():String
			{
				var arr:Array = [];
				for (var name:String in errors)
				{
					arr.push(name + ': ' + errors[name].join('. ') + '.');
				}
				return arr.join('\n');
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: validation methods
		
			// generic
		
				public function required(value:*):Boolean 
				{
					return value is Boolean
						? value === true
						: ! (value === undefined || value === null || trim(value).length == 0);
				}
		
				public function invalid(value:String, arg:int):Boolean 
				{
					return true;
				}			
		
	
			// patterns
		
				public function email(value:String):Boolean
				{
					return /^[a-z0-9._%+-]+@[a-z0-9.-]+(\.[a-z]{2,})(\.[a-z]{2,})?$/i.test(value);
				}
		
				public function username(value:String):Boolean 
				{
					return rangelength(value, 4, 24) && /^[a-z0-9_]$/i.test(value);
				}			
		
				public function password(value:String):Boolean 
				{
					return rangelength(value, 6, 24) && /^[a-z0-9_!£$%^&~]$/i.test(value);
				}			
		
				public function url(value:String):Boolean 
				{
					return true;
				}				
		
				public function creditcard(value:String):Boolean
				{
					return /^\d{4} ?\d{4} ?\d{4} ?\d{4}$/.test(value);
				}
		
				public function date(value:String):Boolean
				{
					return new Date(Date.parse(value)).toString() !== 'Invalid Date';
				}
				
		
			// local
		
				public function	phone(value:*):Boolean
				{
					return /^(?:(?:\(?(?:0(?:0|11)\)?[\s-]?\(?|\+)44\)?[\s-]?(?:\(?0\)?[\s-]?)?)|(?:\(?0))(?:(?:\d{5}\)?[\s-]?\d{4,5})|(?:\d{4}\)?[\s-]?(?:\d{5}|\d{3}[\s-]?\d{3}))|(?:\d{3}\)?[\s-]?\d{3}[\s-]?\d{3,4})|(?:\d{2}\)?[\s-]?\d{4}[\s-]?\d{4}))(?:[\s-]?(?:x|ext\.?|\#)\d{3,4})?$/.test(value);
				}
		
				public function postcode(value:String):Boolean 
				{
					return /^(GIR ?0AA|[A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]([0-9ABEHMNPRV-Y])?)|[0-9][A-HJKPS-UW]) ?[0-9][ABD-HJLNP-UW-Z]{2})$/i.test(value);
				}

	
			// types
		
				public function alpha(value:String):Boolean 
				{
					return /^[a-z]+$/i.test(trim(value));
				}				
		
				public function alphanumeric(value:String):Boolean 
				{
					return /^[a-z\d]+$/i.test(trim(value));
				}		
		
				public function digits(value:String):Boolean 
				{
					return /^\d+$/.test(trim(value));
				}			
		
				public function numeric(value:*):Boolean
				{
					return /^(\d+|\d+\.\d+)$/.test(trim(value));
				}
		
				public function restrict(value:*, values:String):Boolean
				{
					var rx:RegExp = new RegExp('^[' + values + ']+$', 'i');
					return rx.test(trim(value));
				}
		
	
			// string values
		
				public function match(value:String, arg:String):Boolean 
				{
					return value == arg;
				}				
		
				public function contain(value:String, arg:String):Boolean 
				{
					return value.indexOf(arg) > -1;
				}			
		
	
			// string lengths
		
				public function length(value:String, length:int):Boolean 
				{
					return trim(value).length == length;
				}
				
				public function minlength(value:String, length:int):Boolean 
				{
					return trim(value).length >= length;
				}
				
				public function maxlength(value:String, length:int):Boolean 
				{
					return trim(value).length <= length;
				}
			
				public function rangelength(value:String, min:int, max:int):Boolean 
				{
					return this.minlength(value, min) && this.maxlength(value, max);
				}
		
	
			// numeric values
		
				public function value(value:int, length:int):Boolean 
				{
					return value == length;
				}
				
				public function min(value:int, length:int):Boolean 
				{
					return value >= length;
				}
				
				public function max(value:int, length:int):Boolean 
				{
					return value <= length;
				}
			
				public function range(value:int, min:int, max:int):Boolean 
				{
					return value >= min && value <= max;
				}
		
	
			// option selects
		
				public function select(value:String, length:int):Boolean 
				{
					throw new IllegalOperationError('This method has not yet been implemented');
					return true;
				}			
		
				public function minselect(value:String, length:int):Boolean 
				{
					throw new IllegalOperationError('This method has not yet been implemented');
					return true;
				}			
		
				public function maxselect(value:String, length:int):Boolean 
				{
					throw new IllegalOperationError('This method has not yet been implemented');
					return true;
				}			
		
				public function rangeselect(value:String, min:int, max:int):Boolean 
				{
					throw new IllegalOperationError('This method has not yet been implemented');
					return true;
				}		
		
	
			// constraints
		
				public function equalto(value:String, arg:String):Boolean 
				{
					return value == arg;
				}			
		
	
			// custom
		
				public function question(value:String, arg:String):Boolean 
				{
					return value == arg;
				}			
		
				public function captcha(value:String, arg:String):Boolean 
				{
					return value == arg;
				}			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function parseRule(rule:String):Vector.<Parameter> 
			{
				// variables
					var parameters	:Vector.<Parameter>	= new Vector.<Parameter>;
					var tests		:Array				= trim(rule).split(/\s+/g);
					
				// create
					for (var i:int = 0; i < tests.length; i++) 
					{
						parameters.push(new Parameter(tests[i]));
					}
					
				// return
					return parameters;
			}
			
			protected function getMessage(name:String, args:Array):String 
			{
				var index:int = 0;
				return messages[name].replace(/{\w+}/, function(match:String, ...rest):String { return args[index++];  } );
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function isEmpty(value:*):Boolean
			{
				return value is String
					? value == ''
					: value is Array
						? value.length == 0
						: value == null;
			}
		
			protected function trim(value:*):String
			{
				return String(value).replace(/^\s+|\s$/g, '');
			}
			
	}

}

class Parameter
{
	public var name		:String;
	public var args		:Array;
	
	public function Parameter(rule:String)
	{
		var parts:Array	= rule.split(/[,:]/g);
		name			= parts.shift();
		args			= parts;
	}
	
}