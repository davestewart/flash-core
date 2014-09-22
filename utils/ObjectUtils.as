package core.utils
{
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	
	import flash.utils.describeType;
 
	public class ObjectUtils
	{
		
		public function ObjectUtils() 
		{
			
		}
		
		public static function describe(obj:*):void 
		{
			trace(obj + ' :')
			var description:XML = describeType(obj);
			for each (var a:XML in description.accessor) trace('	' + a.@name + " : " + a.@type);
		}
		
		public static function extend(a:Object, b:Object):Object
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
		public static function formatToString(instance:*, className:String, names:String):String
		{
			// trim and split names list on non-word characters
				var props	:Array	= names.replace(/(^\W+|\W+$)/g, '').split(/\W+/g);
				
			// loop through supplied properties and create outout
				var pairs	:Array	= [];
				for each(var prop:String in props)
				{
					var value	:*			= instance[prop];
					pairs.push(prop + '= "' + value.replace('"', '\"') + '"');
				}
				
			// return
				return '[' + className + ' ' + pairs.join(' ') + ']';
		}			

		
	}
	
}