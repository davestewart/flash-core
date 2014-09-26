package core.data.variables 
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public dynamic class FlashVars 
	{
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function FlashVars(root:DisplayObject):void 
			{
				var values:Object = LoaderInfo(root.root.loaderInfo).parameters;
				for (var name:String in values)
				{
					this[name] = values[name];
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function get(name:String, defaultValue:* = null):*
			{
				var value:* = this[name];
				if (value != undefined)
				{
					trace('FlashVars: "' + name + '": ' + value);
					return value;
				}
				else
				{
					trace('FlashVars: "' + name + '" is not set');
					return defaultValue;
				}
			}
			
			public function log():void
			{
				// variables
					var str		:String	= '';
					var total	:int	= 0;
					
				// collect
					for (var name:String in this)
					{
						if (name !== 'get')
						{
							str += ' > ' + name + ' : ' + this[name] + '\n';
						}
					}
					
				// print
					if (total)
					{
						trace('\nFlashVars: ' + total + ' values:\n' + str);
					}
					else
					{
						trace('FlashVars: no values');
					}
			}
			
	}

}