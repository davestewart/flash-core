package core.interfaces 
{
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public interface IMedia 
	{
		// properties
		function get url():String;
		function get active():Boolean;
		function get playing():Boolean;
		function get paused():Boolean;
		function get ended():Boolean;
		
		// methods
		function load(url:String, autoplay:Boolean = false):Boolean;
		function play(seconds:Number):void;
		function pause():void;
		function resume():void;
		function stop():void;
	}
	
}