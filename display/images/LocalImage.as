package core.display.images {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class LocalImage extends Sprite 
	{`
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// instances
				protected var loader	:Loader;
			
			// properties
				protected var fileRef	:FileReference;
				
			// variables
				protected var _data		:ByteArray;
				protected var _loaded	:Boolean;
				
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function LocalImage(select:Boolean = true) 
			{
				// fileref
					fileRef = new FileReference();
					fileRef.addEventListener(Event.SELECT, onSelect);
					fileRef.addEventListener(Event.CANCEL, onCancel);
					fileRef.addEventListener(Event.COMPLETE, onFileComplete);
					fileRef.addEventListener(IOErrorEvent.IO_ERROR, onFileError);
					
				// loader
					loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
					addChild(loader);
					
				// properties
					cacheAsBitmap = true;

				// start
					if (select)
					{
						this.select();
					}
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function select():void
			{
				fileRef.browse([new FileFilter("Image files (*.jpg, *.jpeg, *.png)", "*.jpg;*.jpeg;*.png;")]);
			}
			
			public function unload():void 
			{
				_loaded = false;
				loader.unload();
			}
			
			public function reset():void 
			{
				unload();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get loaded():Boolean { return _loaded; }
			
			public function get bitmapData():BitmapData
			{
				return (loader.content as Bitmap).bitmapData
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			// file ref
				protected function onSelect(event:Event):void
				{
					fileRef.load();
				}

				protected function onCancel(event:Event):void
				{
					trace("File browse canceled");
				}

				protected function onFileComplete(event:Event):void
				{
					event.stopImmediatePropagation();
					loader.loadBytes(fileRef.data);
				}

				protected function onFileError(event:IOErrorEvent):void
				{
					trace("Error loading file: " + event.text);
				}		

			// loader
				
				protected function onLoaderComplete(event:Event):void
				{
					//trace('loaded:' + event);
				}
				
				protected function onLoaderInit(event:Event):void 
				{
					(loader.content as Bitmap).smoothing = true;
					//trace('init:' + event);
					dispatchEvent(new Event(Event.COMPLETE));
				}

				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
		
			
	}

}