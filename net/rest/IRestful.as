package core.net.rest 
{
	import mx.rpc.AsyncToken;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public interface IRestful 
	{
		public function get(url:String, values:*):AsyncToken
		public function post(url:String, values:*):AsyncToken
		public function put(url:String, values:*):AsyncToken
		public function del(url:String, values:*):AsyncToken
	}
	
}