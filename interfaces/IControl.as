package core.interfaces {
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public interface IControl 
	{
		function get name():String;
		function set name(value:String):void;

		function get label():String
		function set label(value:String):void
		
		function get value():*
		function set value(value:*):void

		function get error():String
		function set error(value:String):void
		
		function clear():void
	}
	
}