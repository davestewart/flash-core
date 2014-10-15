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
		
			/**
			 * Selects the application <environment> node from the global <config>
			 * 
			 * Config should be structured like this:
			 * 
			 * 		<config>
			 *			<environments default="name">
			 *				<environment name="dev"		host="staging.yourdomain.com"		setting="whatever you like" />
			 *				<environment name="live"	host="yourdomain.com"				setting="might be different" />
			 *			</environments>
			 * 		</config>
			 * 
			 * Add as many environments, and to each as many attributes or child nodes as required.
			 * Environments can be selected by name or host (if in the browser)
			 * 
			 * Picking order:
			 * 
			 *	> Browser
			 *	
			 *		1. flashvars.env					- essentially this "locks" env as it can't be overridden by location params or affected by the host
			 *		2. location.params.env				- picks the environment matching the query ?env=name in the URL
			 *		3. location.host					- picks the environment matching the hostname
			 *		4. environments.@default			- picks the environment specified in the root node's "default" attribute
			 *		5. #fail							- fails if none of the above match
			 *			
			 *	> Flash	
			 *		
			 *		1. bootstrap.env					- set thru Constructor, and always defaults to "dev"
			 *		2. environments.@default			- picks the environment specified in the root node's "default" attribute
			 *		3. environments.environment[0]		- defaults to the first node found
			 */
			protected function setupEnvironment():void 
			{
				// variables
					var env				:String;
					var settings		:XML;
					var environments	:XML			= config.environments[0];
					
				// check that we have environments to choose from
					if ( ! environments || environments.environment.length() == 0)
					{
						log('No environment settings found in config !');
						cancel();
						return;
					}
					
				// if we have a host, we're running in the browser
					if (location.host)
					{
						// log
							log('running in the browser...')
							log('host is "' + location.host + '"');

						// flashvars.env or location.params.env
							env = flashvars.env || location.params.env;
							log('flashvars or location env is "' + env + '"')
							if (env)
							{
								log('choosing "' +env+ '" environment...')
								settings = environments.environment.(attribute('name') == env)[0];
							}
							
						// host
							if (settings == null)
							{
								log('choosing "' +location.host+ '" environment...')
								settings = environments.environment.(attribute('host') == location.host)[0];
							}
							
						// environments default
							if (settings == null)
							{
								log('choosing default environment...')
								settings = environments.environment.(attribute('name') == String(environments.@default))[0];
							}
							
						// fail
							if (settings == null)
							{
								log('An environment for "' +location.host + '" was not found in the application\'s config');
								cancel();
								return;
							}
					}
					
				// otherwise, we'll be in the authoring environment, or some other environment; perhaps AIR
					else
					{
						// log
							log('running in flash...')
							log('hardcoded env is "' + _env + '"');
							
						// bootstrap.env (if not explicitly set and this node exists, "dev" will always get chosen)
							if (_env)
							{
								log('choosing "' +_env+ '" environment...')
								settings = environments.environment.(attribute('name') == _env)[0];
							}
							
						// environments default
							if(settings == null)
							{
								log('choosing default environment...')
								settings = environments.environment.(attribute('name') == String(environments.@default))[0];
							}
							
						// first-found environment
							if(settings == null)
							{
								log('choosing first environment...')
								settings = environments.environment[0];
							}
					}
					
				// reset variables based on these choices
					_settings		= settings;
					_env			= settings.@name;				
				
				// by this point, we should have an environment
					log('chosen "' +_env+ '" environment: ' + settings.toXMLString());
				
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