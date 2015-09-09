package core.utils 
{
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public function defer(callback:Function, delay:int = 0):Defer
	{
		return new Defer(callback, delay);
	}

}

import flash.utils.clearTimeout;
import flash.utils.setTimeout;

class Defer
{
	protected var id:int;
	
	public function Defer(callback:Function, delay:int = 0):void
	{
		id = setTimeout(callback, delay);
	}
	
	public function cancel():void 
	{
		clearTimeout(id);
	}
}