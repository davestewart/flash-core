package core.data.validation.plugins 
{
	/**
	 * Validation helper class to test against a list of words
	 * 
	 * @author Dave Stewart
	 */
	public class ListValidator 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// variables
				protected var strings		:Array;
				protected var rxs			:Array;
				
			// properties
				protected var _input		:String;
				protected var _match		:String;
				protected var _error		:Boolean;
				protected var _contained	:Boolean;
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function ListValidator(strings:Array, contained:Boolean = true) 
			{
				reset();
				this.strings		= [].concat(strings);
				this.contained		= contained;
			}
			
			public static function parse(text:String, useRx:Boolean = true):ListValidator
			{
				return new ListValidator(text.match(/^\s*(.+?)\s*$/gm), useRx);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function test(input:String):Boolean
			{
				// reset
				reset();
				
				// properties
				_input		= input;
				
				// test
				return _contained 
					? testString()
					: testRx();
			}
			
			public function reset():void 
			{
				_input = '';
				_match = '';
				_error = false;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get input():String { return _input; }
			
			public function get match():String { return _match; }
			
			public function get error():Boolean { return _error; }
			
			public function get contained():Boolean { return _contained; }
			public function set contained(state:Boolean):void 
			{
				_contained = state;
				if ( state && rxs == null )
				{
					rxs = [];
					for each(var value:String in strings)
					{
						rxs.push(new RegExp('\\b(' +value+ ')\\b')); 
					};
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function testString():Boolean 
			{
				for each(var string:String in strings)
				{
					if (_input.indexOf(string) !== -1)
					{
						_error = true;
						_match = string;
						return false;
					}
				}
				return true;
			}
		
			protected function testRx():Boolean 
			{
				var matches:Array;
				for each(var rx:RegExp in rxs)
				{
					matches = _input.match(rx);
					if (matches)
					{
						_error = true;
						_match = matches[1];
						return false;
					}
				}
				return true;
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}