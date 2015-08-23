package core.interfaces 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public interface IVideoEncoder extends IEventDispatcher
	{
		// properties
		function set source(value:*):void;
		function get source():*;
		function get target():*;
		function get phase():String;
		function get frames():int;
		function get progress():Number;
		function get result():*;
		
		// methods
		function setup():void
		function initialize():void
		function start():void
		function stop():void 
		function destroy():void 				
	}
	
}