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
		function get phase():String;
		
		// public methods
		function setup():void
		function initialize():void
		function start():void
		function stop():void 
		
		// protected methods
		function process():void 
		function finish():void
				
	}
	
}