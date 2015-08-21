package core.interfaces 
{
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public interface IVideoEncoder 
	{

		function start():Boolean
		
		function capture():void
		
		function stop():void 
		
		function process():void 
		
		function finish():void
		
		function reset():void
		
	}
	
}