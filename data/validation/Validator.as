package core.data.validation {
	/**
	 * ...
	 * @author Dave Stewart
	 */
	dynamic public class Validator
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				public var model			:Object;
				public var errors			:Object;
				public var state			:Boolean;
				
			// validation messages
				public var messages			:Object = 
				{
					// generic
						'required'				:'This field is required',
						'invalid'				:'The input appears to be invalid',
						
					// patterns
						'email'					:'Must be a valid e-mail',
						'username'				:'Must be a valid username',
						'url'					:'Must be a valid URL',
						'phone'					:'Must be a valid phone number',
						'creditcard'			:'Must be a valid credit card number',
						'date'					:'Must be a valid date',
						
					// types
						'alpha'					:'Must be letters',
						'alphanumeric'			:'Must be letters and numbers',
						'digits'				:'Must be digits',
						'number'				:'Must be a number',
						
					// string values
						'match'					:'Must be "{arg1}"',
						'contain'				:'Must contain "{arg1}"',
						
					// string lengths
						'minlength'				:'Must be a minimum length of {arg1}',
						'maxlength'				:'Must be a maximum length of {arg1}',
						'rangelength'			:'Must be a length between {arg1} and {arg2}',
						
					// numeric values
						'min'					:'Must be at least {arg1}',
						'max'					:'Must be at most {arg1}',
						'range'					:'Must be between {arg1} and {arg2}',
						
					// option selects
						'minselect'				:'Select at least {arg1} options',
						'maxselect'				:'Select no more than {arg1} options',
						'rangeselect'			:'Select between {arg1} and {arg2} options',
						
					// constraints
						'equalto'				:'Must be the same as "{arg1}"',
						
					// custom
						'question'				:'Must answer the question',
						'captcha'				:'Must complete the captcha'
				};
			
			
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
			
			public function validateOne(value:*, rule:String):Array
			{
				// variables
					var tests		:Array		= parseRule(rule);
					var errors		:Array		= [];
					var method		:String;
					var args		:Array;
					var state		:Boolean;
					
				// validate rule (comprising one or more tests)
					for (var i:int = 0; i < tests.length; i++) 
					{
						// variables
							method		= tests[i][0];
							args		= [value].concat(tests[i].slice(1));
							
						// validate current test
							if (this[method] is Function)
							{
								state = (this[method] as Function).apply(this, args)
								if ( ! state )
								{
									errors.push(getMessage(method, args.slice(1)));
								}
							}
							else
							{
								throw new Error('The Validator method "' +method+ '" does not exist');
							}
					}
					
				// return
					return errors;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: validation methods
		
			// required
			
				public function required(value:*):Boolean 
				{
					return ! (value === undefined || value === null || trim(value).length == 0);
				}
				
				
			// string length
			
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
				
			// numeric value	
			
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
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: type validation methods
		
			public function numeric(value:*):Boolean
			{
				return /^(\d+|\d+\.\d+)$/.test(trim(value));
			}
			
			public function	phone(value:*):Boolean
			{
				return /[-+ ()0-9]/.test(value);
			}
			
			public function email(value:String):Boolean
			{
				var rx:RegExp = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
				return rx.test(value);
			}
			
			public function postcode(value:String):Boolean 
			{
				return /(GIR 0AA)|((([A-Z-[QVX]][0-9][0-9]?)|(([A-Z-[QVX]][A-Z-[IJZ]][0-9][0-9]?)|(([A-Z-[QVX]][0-9][A-HJKSTUW])|([A-Z-[QVX]][A-Z-[IJZ]][0-9][ABEHMNPRVWXY])))) [0-9][A-Z-[CIKMOV]]{2})/.test(value)
			}
			
			public function creditcard(value:String):Boolean
			{
				return trim(value).replace(/\D+/g, '').length == 16;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			public function getErrorText():String
			{
				var arr:Array = [];
				for (var name:String in errors)
				{
					arr.push(name + ': ' + errors[name].join('. ') + '.');
				}
				return arr.join('\n');
			}
		
			protected function parseRule(rule:String):Array 
			{
				var tests:Array = trim(rule).split(/\s+/g);
				for (var i:int = 0; i < tests.length; i++) 
				{
					tests[i] = tests[i].split(/\W/g);
				}
				return tests;
			}
			
			protected function getMessage(name:String, args:Array):String 
			{
				var index:int = 0;
				return messages[name].replace(/{\w+}/, function(match:String, ...rest):String { return args[index++];  } );
			}
		
			protected function trim(value:*):String
			{
				return String(value).replace(/^\s+|\s$/g, '');
			}
			
	}

}

