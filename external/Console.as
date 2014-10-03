package core.external 
{
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Console 
	{
		public static var enabled:int = -1;
		
		public static function log(value:*):void 
		{
			if (ExternalInterface.available)
			{
				if (enabled < 0)
				{
					enabled = exists() ? 1 : 0;
				}
				if (enabled > 0)
				{
					ExternalInterface.call('console.log', value);
				}
			}
		}
		
		public static function exists():Boolean
		{
			return ExternalInterface.call('eval', '(function(){ return window.console && "log" in window.console; })();');
		}
	}

}