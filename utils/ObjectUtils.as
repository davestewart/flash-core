package core.utils
{
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	
	import flash.utils.describeType;
 
	public class ObjectUtils
	{
		
		public static function create(Def:Class, ...params):*
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