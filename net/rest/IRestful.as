package core.net.rest 
{
	import mx.rpc.AsyncToken;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public interface IRestful 
	{
		public function get(url:String, data:*):AsyncToken
		public function post(url:String, data:*):AsyncToken
		public function put(url:String, data:*):AsyncToken
		public function del(url:String, data:*):AsyncToken
	}
	
}