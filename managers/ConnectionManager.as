package core.managers 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.*;
	
	import core.constants.NetStatus;
	import core.data.settings.ServerSettings;
	
	/**
	 * Manages a single connection (server, username, password), its events, and provides a static endpoint to it
	 * @author Dave Stewart
	 */
	public class ConnectionManager extends EventDispatcher 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				public static const instance	:ConnectionManager = new ConnectionManager();
			
			// properties
				protected var _connection		:NetConnection;
				protected var _settings			:ServerSettings;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function ConnectionManager() 
			{
				
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function initialize(settings:*):ConnectionManager
			{
				if(settings is ServerSettings)
				{
					_settings = settings;
				}
				else if (settings is String)
				{
					_settings = new ServerSettings(settings);
				}
				else
				{
					_settings = new ServerSettings(settings.server, settings.username, settings.password);
				}
				return this;
			}

			public function connect(onConnect:Function, onError:Function = null):ConnectionManager 
			{
				// add listeners
					addEventListener(Event.CONNECT, onConnect);
					if (onError is Function)
					{
						addEventListener(ErrorEvent.ERROR, onError);
					}
					
				// connect
					_connection = new NetConnection();
					_connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
					settings.username
						? _connection.connect(settings.server, settings.username, settings.password)
						: _connection.connect(settings.server);
					
				// return
					return this;
			}
			
			public function disconnect():void 
			{
				_connection.close();
				_connection = null;
			}

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get connection():NetConnection 
			{
				if ( ! _connection )
				{
					throw new Error('A connection was requested, but one has not yet been set up! Did you remember to do this?');
				}
				return _connection;
			}
			
			public function get settings():ServerSettings 
			{
				return _settings;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onConnectionStatus(event:NetStatusEvent):void
			{
				// debug
					trace('CONNECTION MANAGER: ' + event.info.code+' (' + event.info.description + ')');
					
				// forward event
					dispatchEvent(event);
						
				// dispatch standard event
					switch(event.info.code)
					{
						case NetStatus.NetConnection_Connect_Success:
							dispatchEvent(new Event(Event.CONNECT));
							return;
						
						case NetStatus.NetConnection_Connect_Failed:
							dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
							trace("Connection failed: Try rtmp://[server ip]/[app name]");
							break;
						
						case NetStatus.NetConnection_Connect_Rejected:
							trace(event.info.description);
							break;
					}
					
				// finally, dispatch an error
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}