package core.managers.boot 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import core.data.variables.Location;
	import core.managers.boot.CoreBootstrap;
	
	/**
	 * CoreBootstrap extends BaseBootstrap to provide a more useful base configuration,
	 * which includes:
	 * 
	 *  - loading a base config XML file (defaults to config/config.xml)
	 *  - setting up the environment, based on the URL or other overrides
	 * 
	 * You should extend from this class, and add your own bootstrap tasks as necessary
	 * 
	 * @author Dave Stewart
	 */
	public class CoreBootstrap extends BaseBootstrap
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// environment
				protected var _env					:String;
				public function get env()			:String { return _env; }
	
			// location
				protected var _location				:Location;
				public function get location()		:Location { return _location; }
					
			// config	
				protected var _configPath			:String;
				protected var _config				:XML;
				public function get config()		:XML { return _config; }
					
			// environment settings
				protected var _settings				:XML;
				public function get settings()		:XML{ return _settings; }

				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function CoreBootstrap(root:DisplayObjectContainer, env:String = '', config:String = 'config/config.xml') 
			{
				// super
					super(root);
					
				// properties
					_location		= new Location();
				
				// parameters. flashvars (as they're more secure than the URL) take precidence, then search params, then passed-in params
					_env			= flashvars.env || location.params.env || env;
					_configPath		= flashvars.config || location.params.config || config;
					
				// add default tasks
					queue
						.add(loadConfig, 'config')
						.add(setupEnvironment, 'environment');
			}
		

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: api
		
			protected function loadConfig():void 
			{
				// debug
					log('Loading config...');
					
				// callback
					function onLoad(event:Event):void 
					{
						_config = new XML(event.target.data);
						next();
					}
					
					function onError(event:IOErrorEvent):void 
					{
						log('The config file at "' +_configPath+ '" could not be loaded');
						cancel();
					}
					
				// load
					var loader:URLLoader = new URLLoader(new URLRequest(_configPath));
					loader.addEventListener(Event.COMPLETE, onLoad, false, 0, true);
					loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: environment
		
			protected function setupEnvironment():void 
			{
				// debug
					log('default env is ' + _env);
					log('host is ' + location.host);
					
				// variables
					var env				:String;
					var settings		:XML;
					var environments	:XML			= config.environments[0];
					
				// if we're in the browser, work out the correct settings to use, based on search ?env=value, then flashvar ?env=value, then host
					if (location.host)
					{
						log('running in the browser...')
						
						env = location.params.env || flashvars.env;
						log('env is ' + env)
						if (env)
						{
							log('choosing ' +env+ 'environment...')
							settings = environments.environment.(attribute('name') == env)[0];
						}
						else
						{
							log('choosing ' +location.host+ ' environment...')
							settings = environments.environment.(attribute('host') == location.host)[0];
						}
					}
					
				// if we're not in the browser, or we've not got a environment, work out the correct environment to use, based on config's default, then supplied variable
					if (settings == null)
					{
						if ( ! ExternalInterface.available )
						{
							log('running in flash...')
						}
						env = this.env || String(environments.@default);
						if (env)
						{
							log('choosing ' +env+ ' environment...')
							settings = environments.environment.(attribute('name') == env)[0];
						}
						else
						{
							log('defaulting to first environment...')
							settings = environments.environment[0];
						}
					}
					
				// by this point, we should have an environment
					log('environment: ' + settings.toXMLString());
				
				// finally, set the environment var based on these choices
					_settings		= settings;
					_env			= settings.@name;				
				
				// report
					log('Setting up ' +_env + ' environment...');
					setTimeout(next, 500);
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}