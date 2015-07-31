package core.media.core 
{
	
	/**
	 * Simple generic interface to govern playable items
	 * 
	 * @author Dave Stewart
	 */
	public interface IPlayable 
	{
		/// starts the item playing
		function start():void;
		
		/// pauses the item, leaving the playhead / position at the point of pause
		function pause():void;
		
		/// stops the item, and resets the playhead / position to the start
		function stop():void;
	}
	
}