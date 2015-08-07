package core.tools 
{
	import flash.utils.getTimer;

	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Timer 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var timeStart		:Number;
				protected var timeStop		:Number;
				
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Timer(start:Boolean = false) 
			{
				if (start)
				{
					this.start();
				}				
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function start():Timer
			{
				timeStart	= getTimer();
				timeStop	= 0;
				return this;
			}
			
			public function stop():Timer
			{
				timeStop = getTimer();
				return this;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get ticks():int
			{
				return (timeStop == 0 ? getTimer() : timeStop) - timeStart;
			}
			
			public function get seconds():Number
			{
				return ticks / 1000;
			}
		
			public function get time():String
			{
				return seconds.toFixed(2) + ' seconds';
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}
