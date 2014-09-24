package core.managers 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.plugins.*;
	import core.managers.AssetManager;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Easily handles loading multiple data sources
	 * 
	 * Wraps LoaderMax
	 * 
	 * @author Dave Stewart
	 */
	public class AssetManager extends EventDispatcher 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// stage instances
				
			
			// properties
				public var name			:String;
				public var queue		:LoaderMax;
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function AssetManager(name:String = 'loader') 
			{
				this.name = name;
				initialize();
			}
			
			protected function initialize():void
			{
				queue = new LoaderMax({name:name, onProgress:onProgress, onComplete:onComplete, onError:onError});
			}
			
			/**
			 * Convenience method to load one or many URLs in one shot
			 * 
			 * @param	url
			 * @param	callback
			 * @return
			 */
			static public function load(src:*, onComplete:Function, onProgress:Function = null):AssetManager
			{
				// variables
					var name	:String			= 'asset';
					var loader	:AssetManager	= new AssetManager();
					
				// callbacks
					function onOneComplete(event:LoaderEvent):void
					{
						onComplete(loader.queue.getContent(src));
					}
					
					function onManyComplete(event:Event):void
					{
						onComplete(loader);
					}
					
				// setup
					src is Array
						? loader
							.addMany(src)
							.addEventListener(Event.COMPLETE, onManyComplete)
						: loader
							.add(src, name, onOneComplete);
						
				// progress
					if (onProgress != null)
					{
						loader.addEventListener(LoaderEvent.PROGRESS, onProgress); 
					}
				
				// load
					return loader.load();
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			// starting and stopping
			
				public function clear():AssetManager 
				{
					queue.empty();
					return this;
				}
				
				public function load():AssetManager 
				{
					//trace('Starting load of "' + name + '" (' +queue.getChildren().length+ ' items)');
					queue.load();
					return this;
				}
				
			// loading
			
				public function addMany(urls:*):AssetManager 
				{
					if (urls is XMLList || urls is Array)
					{
						for each(var url:String in urls)
						{
							add(url, '');
						}
					}
					return this;
				}
				
				public function add(url:String, name:String = null, onComplete:Function = null):*
				{
					return /\.xml$/.test(url)
						? addXML(url, name, onComplete)
						: /\.json$/.test(url)
							? addJSON(url, name, onComplete)
							: addImage(url, name, onComplete);
				}
							
				public function addImage(url:String, name:String = null, onComplete:Function = null):ImageLoader
				{
					//trace('Adding: ' + url);
					var loader:ImageLoader = new ImageLoader(url, { name:name, onComplete:onComplete } );
					return queue.append(loader) as ImageLoader;
				}
				
				public function addXML(url:String, name:String = null, onComplete:Function = null):XMLLoader
				{
					var loader:XMLLoader = new XMLLoader(url, { name:name, onComplete:onComplete } );
					return queue.append(loader) as XMLLoader;
				}
				
				public function addJSON(url:String, name:String = null, onComplete:Function = null):DataLoader
				{
					var loader:DataLoader= new DataLoader(url, { name:name, onComplete:onComplete } );
					return queue.append(loader) as DataLoader;
				}
				
			// retrieving data
			
				public function get(src:*):*
				{
					return typeof src == 'number'
						? queue.content[src]
						: queue.getContent(src);
				}
				
				public static function getBitmap(url:String):Bitmap 
				{
					var content:* = LoaderMax.getContent(url);
					if (content && content.rawContent)
					{
						var bitmap:Bitmap = content.rawContent as Bitmap
						return new Bitmap(bitmap.bitmapData, 'auto', true);
					}
					return null;
				}
				
				public function getImage(name:String):Bitmap
				{
					var content:* = queue.getContent(name);
					if (content && content.rawContent)
					{
						var bitmap:Bitmap = content.rawContent as Bitmap
						return new Bitmap(bitmap.bitmapData, 'auto', true);
					}
					return null;
				}
			
				public function getJSON(name:String):Object 
				{
					// grab data
						var data:String = queue.getContent(name);
						
					// return
						return JSON.parse(data);
				}

				public function getXML(name:String):XML 
				{
					// grab data
						var data:String = queue.getContent(name);
						
					// remove doctype and xmlns
						data = data
							.replace(/<!DOCTYPE.*?>/, '')
							.replace(/<html.+?>/i, '<html>');
						
					// return
						return new XML(data)
				}

				public function getHTML(name:String):XML 
				{
					return getXML(name).body[0];
				}

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers

			public function onProgress(event:LoaderEvent):void 
			{
				//trace('"' + name + '" progress: ' + Math.floor(event.target.progress * 100) + '%');
				dispatchEvent(event);
			}
			 
			public function onComplete(event:LoaderEvent):void 
			{
				//trace(this, event.target + " is complete!");
				dispatchEvent(new Event(Event.COMPLETE));
			}
			  
			public function onError(event:LoaderEvent):void 
			{
				trace("error occured with " + event.target + ": " + event.text);
			}
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}