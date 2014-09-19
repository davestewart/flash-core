package core.services {
	import com.greensock.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import com.greensock.plugins.*;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	/**
	 * Easily handles loading multiple data sources
	 * 
	 * Wraps LoaderMax
	 * 
	 * @author Dave Stewart
	 */
	public class Loader extends EventDispatcher 
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
		
			public function Loader(name:String = 'loader') 
			{
				this.name = name;
				initialize();
			}
			
			protected function initialize():void
			{
				queue = new LoaderMax({name:name, onProgress:onProgress, onComplete:onComplete, onError:onError});
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			// starting and stopping
			
				public function clear():void 
				{
					queue.empty();
				}
				
				public function load():void 
				{
					//trace('Starting load of "' + name + '" (' +queue.getChildren().length+ ' items)');
					queue.load();
				}
				
			// loading
			
				public function addMany(urls:*):Loader 
				{
					if (urls is XMLList || urls is Array)
					{
						for each(var url:String in urls)
						{
							add(url);
						}
					}
					return this;
				}
				
				public function add(url:String, name:String = null):*
				{
					return /\.xml$/.test(url)
						? addXML(url, name)
						: addImage(url, name);
				}
							
				public function addImage(url:String, name:String = null, onComplete:Function = null):ImageLoader
				{
					//trace('Adding: ' + url);
					var loader:ImageLoader = new ImageLoader(url, { name:name, onComplete:onComplete } );
					return queue.append(loader) as ImageLoader;
				}
				
				public function addXML(url:String, name:String = null):XMLLoader
				{
					var loader:XMLLoader = new XMLLoader(url, { name:name } );
					return queue.append(loader) as XMLLoader
				}
				
				public function addJSON(url:String, name:String = null):DataLoader
				{
					var loader:DataLoader= new DataLoader(url, { name:name } );
					return queue.append(loader) as DataLoader
				}
				
			// retrieving data
				
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