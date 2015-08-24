package core.interfaces 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public interface IEncoder extends IEventDispatcher
	{

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: properties
		
			// set the input of the encoder
			function set input(value:*):void;
			function get input():*;
			
			// the actual input of the encoder (may be found inside another object) such as a video
			function get source():*;
			
			// the encoding phase the encoder is in
			function get phase():String;
			
			// the length (could be frames, bytes, etc) of the current capture
			function get length():int;
			
			// the progress of the current process
			function get progress():Number;
			
			// the encoder's final output (could be bytes, a url, etc)
			function get output():*;

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: methods
		
			// sets up the encoder, one time only
			function setup():void
			
			// initializes the encoder before each encode
			function initialize():void
			
			// starts the encoder
			function start():void
			
			// stops the encoder
			function stop():void
			
			// destroys the encoder
			function destroy():void 				
	}
	
}