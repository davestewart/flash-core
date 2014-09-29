package core.display.forms {
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public interface IControl 
	{
		function get value():*
		function set value(value:*):void

		function get label():String
		function set label(value:String):void
		
		function get error():String
		function set error(value:String):void
		
		function clear():void
	}
	
}