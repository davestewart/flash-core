package core.utils
{
	import core.events.ValueEvent;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	
	import flash.utils.describeType;
 
	public class Objects
	{
		
		static public function create(Def:Class, ...params):*
		{
			// unfortunately, constructor.apply(this, params) in not possible in AS3, so we have to do it manually...
			switch(params.length)
			{
				case 0: return new Def();	
				case 1: return new Def(params[0]);	
				case 2: return new Def(params[0], params[1]);	
				case 3: return new Def(params[0], params[1], params[2]);	
				case 4: return new Def(params[0], params[1], params[2], params[3]);	
				case 5: return new Def(params[0], params[1], params[2], params[3], params[4]);	
				case 6: return new Def(params[0], params[1], params[2], params[3], params[4], params[5]);	
				case 7: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6]);	
				case 8: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]);	
				case 9: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8]);	
				case 10: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9]);	
				case 11: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10]);	
				case 12: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11]);	
				case 13: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11], params[12]);	
				case 14: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11], params[12], params[13]);	
				case 15: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11], params[12], params[13], params[14]);	
				case 16: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11], params[12], params[13], params[14], params[15]);	
				case 17: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11], params[12], params[13], params[14], params[15], params[16]);	
				case 18: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11], params[12], params[13], params[14], params[15], params[16], params[17]);	
				case 19: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11], params[12], params[13], params[14], params[15], params[16], params[17], params[18]);	
				case 20: return new Def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11], params[12], params[13], params[14], params[15], params[16], params[17], params[18], params[19]);
				default: throw new Error('More than 20 parameters is not supported');
			}
		}
		
		static public function describe(obj:*):void 
		{
			trace(obj + ' :')
			var description:XML = describeType(obj);
			for each (var a:XML in description.accessor) trace('	' + a.@name + " : " + a.@type);
		}
		
		static public function inspect( obj : * , level : int = 0 ):void
		{
			var tabs:String = "";
			for (var i:int = 0; i < level; i++)
			{
				tabs += "    "
			};
			
			for (var prop:String in obj)
			{
				trace(tabs + "[" + prop + "] -> " + obj[ prop ]);
				inspect(obj[prop], level + 1);
			}
		}
		
		static public function extend(a:Object, b:Object):Object
		{
			for (var prop:String in b)
			{
				a[prop] = b[prop];
			}
			return a;
		}
		
		/**
		 * Returns a formatted class signature
		 * @param	className
		 * @param	names
		 * @return
		 */
		static public function formatToString(instance:*, className:String, names:String):String
		{
			// variables
				var props	:Array	= names.match(/\w+/g);
				var pairs	:Array	= [];
				
			// loop through supplied properties and create outout
				for each(var prop:String in props)
				{
					var value	:*			= instance[prop];
					pairs.push(prop + '="' + String(value).replace('"', '\"') + '"');
				}
				
			// return
				return '[' + className + ' ' + pairs.join(' ') + ']';
		}
		
		/**
		 * Converts a class instance (whose properties can't be iterated over) into an Object
		 * @param	source		Any instance
		 * @param	deep		Currently not implemented properly
		 * @return
		 */
		static public function convert(source:*, deep:Boolean = false):Object 
		{
			// variables
				var qname	:String		= getQualifiedClassName(source);
				var props	:Object		= types[qname] || getProps(source);
				
			// values
				var data	:Object		= { };
				var value	:*;
				
			// loop
				for(var prop:String in props)
				{
					value = data[prop] = source[prop];
					
					if (typeof value == 'object' && deep)
					{
						if (value is Array)
						{
							
						}
						else
						{
							data[prop] = convert(value, true);
						}
					}
				}
				
			// return
				return data;
		}
	
		
		static public function getProps(source:*):Object 
		{
			// description
				var desc:XML = describeType(source);
				
			// debug
				trace(desc.toXMLString());
				
			// get base object if defintion
				if (desc.@base == 'Class')
				{
					desc = desc.factory[0];
				}
				
			// collect properties
				var props:Object = {};
				for each(var node:XML in desc.*)
				{
					var name:String = node.name();
					if (name == 'variable' || (name == 'accessor' && /read/.test(node.@access)))
					{
						props[node.@name] = String(node.@type);
					}
				}
				
			// return
				return props;
		}
		
		
		static public function keys(obj:Object):Array
		{
			var keys:Array = [];
			for (var name:String in obj)
			{
				keys.push(name);
			}
			return keys;
		}

	
	}
	
}

var types:Object = { };


var klass:XML = <type name="DescribeTypeTest.as$0::Test" base="Class" isDynamic="true" isFinal="true" isStatic="true">
  <factory type="DescribeTypeTest.as$0::Test">
    <variable name="publicVar" type="String" />
    <accessor name="getter" access="readonly" type="String" declaredBy="DescribeTypeTest.as$0::Test" />
    <accessor name="setterVar" access="writeonly" type="String" declaredBy="DescribeTypeTest.as$0::Test" />
    <accessor name="getterSetterVar" access="readwrite" type="String" declaredBy="DescribeTypeTest.as$0::Test" />
	</factory>
</type>


var instance:XML = <type name="DescribeTypeTest.as$0::Test" base="Object" isDynamic="false" isFinal="false" isStatic="false">
  <variable name="publicVar" type="String" />
  <accessor name="getterSetterVar" access="readwrite" type="String" declaredBy="DescribeTypeTest.as$0::Test" />
  <accessor name="getter" access="readonly" type="String" declaredBy="DescribeTypeTest.as$0::Test" />
  <accessor name="setterVar" access="writeonly" type="String" declaredBy="DescribeTypeTest.as$0::Test" />
</type>
