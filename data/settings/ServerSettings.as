package core.data.settings {
	import core.data.settings.Settings;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class ServerSettings extends Settings
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: properties
		
				
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function ServerSettings(server:String = '', username:String = '', password:String = '') 
			{
				super('ServerSettings', true);
				_data.server			= server;
				_data.username			= username;
				_data.password			= password;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get server():String { return _data.server; }
			public function set server(value:String):void 
			{
				set('server', value);
			}

			public function get username():String { return _data.username; }
			public function set username(value:String):void 
			{
				set('username', value);
			}

			public function get password():String { return _data.password; }
			public function set password(value:String):void 
			{
				set('password', value);
			}

		
	}

}