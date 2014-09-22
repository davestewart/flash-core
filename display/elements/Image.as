package core.display.elements 
{
	import com.greensock.layout.AutoFitArea;
	import com.greensock.layout.ScaleMode;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	/**
	 * Creates an Image element, optionally 
	 * 
	 * @author Dave Stewart
	 */
	public class Image extends Element 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// consts
				public static const	COVER	:String		= 'Image.COVER';
				public static const	FIT		:String		= 'Image.FIT';
		
			// properties
				protected var loader	:Loader;
				protected var image		:DisplayObject;
				protected var area		:AutoFitArea;
				
			// variables
				protected var _src		:*;
				protected var _bounds	:Rectangle;
				protected var _mode		:String;
				protected var _crop		:Boolean;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Image(src:*, parent:DisplayObjectContainer = null, mode:String = '', crop:Boolean = true)
			{
				_src		= src;
				_mode		= mode;
				_crop		= crop;
				_bounds		= parent ? parent.getBounds(parent) : null;
				super(parent);
			}
		
			override protected function initialize():void 
			{
				// load the image
					if (_src is String)
					{
						// load the image
							var loader:Loader = new Loader();
							loader.load(new URLRequest(_src));
							loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
							
						// assign the loader to the image variable
							image = loader as DisplayObject;
							addChild(image);
					}
					
				// place the image
					else if (_src is DisplayObject) 
					{
						image = _src as DisplayObject;
						addChild(image);
						update();
					}
					
				// name
					image.name = 'image';
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function reset():void 
			{
				image.x = image.y = 0;
				image.scaleX = image.scaleY = 1;
				if (area)
				{
					area.destroy();
					area = null;
				}
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get mode():String { return _mode; }
			public function set mode(value:String):void 
			{
				_mode = value;
				update();
			}
			
			public function get crop():Boolean { return _crop; }
			public function set crop(value:Boolean):void 
			{
				_crop = value;
				update();
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function update():void 
			{
				if (_bounds)
				{
					area = new AutoFitArea(this, _bounds.x, _bounds.y, _bounds.width, _bounds.height);
					switch (mode) 
					{
						case COVER:
							area.attach(image, { scaleMode:ScaleMode.PROPORTIONAL_OUTSIDE, crop:crop } );
							break;
							
						case FIT:
							area.attach(image, { scaleMode:ScaleMode.PROPORTIONAL_INSIDE, crop:crop } );
							break;
							
						default:
							reset();
					}
				}
				else
				{
					reset();
				}
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onLoaderComplete(event:Event):void 
			{
				((event.target as LoaderInfo).content as Bitmap).smoothing = true;
				update();
			}
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}