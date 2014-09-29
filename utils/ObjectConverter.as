package core.utils {
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class ObjectConverter 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				public static var types:Object = {}
			
			// properties
				protected var source:*;
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function ObjectConverter(source:*) 
			{
				this.source = source;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function convert(source:*, deep:Boolean = false):Object 
			{
				// variables
					var qname	:String		= getQualifiedClassName(source);
					var props	:Object		= ObjectConverter.types[qname] || getProps(source);
					
				// values
					var data	:Object		= { };
					var value	:*;
					
				// loop
					for(var prop:String in props)
					{
						value = data[prop] = source[prop];
						if (value is Array)
						{
							
						}
						else
						{
							
						}
					}
					
				// return
					return data;
			}
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function getProps(source:*):Object 
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
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}


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
