package core.utils {
	import core.tools.Identifier;
	import core.utils.Objects;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Elements
	{
		
		
		public static function replace(target:*, properties:String, Def:Class, ...params):*
		{
			return match(Objects.create(Def, params), target, properties);
		}

		public static function match(source:*, target:DisplayObject, properties:*):* 
		{
			
			// ---------------------------------------------------------------------------------------------------------
			// setup

				// variables
					var	src		:DisplayObject;
					var	trg		:DisplayObject;
					
				// parameters
					var props	:Array = properties is Array ? properties : String(properties).match(/\w+/g);
					
					
			// ---------------------------------------------------------------------------------------------------------
			// many elements passed in
			
				if (source is Array)
				{
					for each(src in source)
					{
						match(src, target, props);
					}
					return source[0]; // return the first item
				}
				
			
			// ---------------------------------------------------------------------------------------------------------
			// one element passed in

				// variables
					src		= source;
					trg		= target;
					
				// do the matching
					for each(var prop:String in props)
					{
						switch(prop)
						{
							// parent
								case 'parent':
									trg.parent.addChild(src);
									break;	
									
								case 'index':
									(src.parent || trg.parent).addChildAt(src, trg.parent.getChildIndex(trg));
									break;	
									
								case 'hide':
									trg.visible		= false;
									break;	
									
								case 'remove':
									trg.parent.removeChild(trg);
									break;	
									
								case 'replace':
									 match(src, trg, 'parent index remove');
									 break;
									 
							// position
								case 'pos':
								case 'position':
									src.x			= trg.x;
									src.y			= trg.y;
									break;	
									
							// scale
								case 'scale':
									src.scaleX		= trg.scaleX;
									src.scaleY		= trg.scaleY;
									break;	
									
							// size	
								case 'size':	
									src.width		= trg.width;
									src.height		= trg.height;
									break;	
									
							// bounds
								case 'bounds':
									src.x			= trg.x;
									src.y			= trg.y;
									src.width		= trg.width;
									src.height		= trg.height;
								break;	
									
							// size proportional	
								case 'WIDTH':	
									src.width		= trg.width;
									src.scaleY		= src.scaleX;
									break;
									
								case 'HEIGHT':	
									src.width		= trg.width;
									src.scaleX		= src.scaleY;
									break;
								
							// anything else
								default:
									src[prop]		= trg[prop];
						}
					}
					
				// return
					return source;
		}
		
		public static function align(source:DisplayObject, target:DisplayObject, align:String = ''):void 
		{
			// parameters
			align = align || '';
			
			// optimise if source and target are the same size
			if (source.width == target.width && source.height == target.height && align == '')
			{
				//source.x = source.y = 0;
				//return;
			}
			
			// vertical
			if (align.indexOf('top') !== -1)
			{
				source.y	= target.y;
			}
			else if (align.indexOf('bottom') !== -1)
			{
				source.y	= target.y + (target.height - source.height);
			}
			else
			{
				source.y	= (target.height - source.height) / 2;
			}
			
			// horizontal
			if (align.indexOf('left') !== -1)
			{
				source.x	= target.x;
			}
			else if (align.indexOf('right') !== -1)
			{
				source.x	= target.x + (target.width - source.width);
			}
			else
			{
				source.x	= (target.width - source.width) / 2;
			}
		}
		
		public static function fit(source:DisplayObject, target:DisplayObject, mode:String):void
		{
			// reset source scale
			source.scaleX = source.scaleY = 1;
			
			// exit early if no fitting
			if (mode == '' || mode == 'none' || mode == null)
			{
				return;
			}
			
			// source dimensions
			var width	:Number		= source.width;
			var height	:Number		= source.height;
			
			// aspect ratios
			var b		:Number		= width / height;
			var a		:Number		= target.width / target.height;
			
			// size
			switch (mode) 
			{
				case 'cover':
					if (a > b)
					{
						source.width	= target.width;
						source.height	= height * source.scaleX;
					}
					else
					{
						source.height	= target.height;
						source.width	= width * source.scaleY;
					}
					break;
					
				case 'fit':
					if (a > b)
					{
						source.height	= target.height;
						source.width	= width * source.scaleY;
					}
					else
					{
						source.width	= target.width;
						source.height	= height * source.scaleX;
					}
					break;
					
				case 'match':
				case 'scale':
					source.width		= target.width;
					source.height		= target.height;
					break;
			}
		}
		
		/**
		 * Draws a rectangle around the display object in case you can't see it on the stage
		 * @param	element
		 * @param	color
		 * @param	alpha
		 */
		public static function identify(element:DisplayObject, color:int = 0xFF0000, alpha:Number = 0.1, outside:Boolean = false):Identifier
		{
			return new Identifier(element, color, alpha, outside);
		}
		
		/**
		 * Lays out elements in a grid, regardless of their internal centerpoint offsets. Does not take into account object rotation though!
		 * @param	elements		An Array of display objects to be aligned
		 * @param	parent			A parent DisplayObject to attach and align to
		 * @param	useStage		A Boolean indicating whether to use the stage bounds (default) or the object bounds
		 * @param	vGutter			A Number specifying the vertical gutter between objects
		 * @param	hGutter			A Number specifying the horizontal gutter between rows
		 * @param	outsidePadding	A number specifying the padding 
		 */
		public static function layout(elements:Array, parent:DisplayObjectContainer, useStage:Boolean = true, vGutter:Number = 10, hGutter:Number = 10, outsidePadding:Number = 10):void 
		{
			// variables
				var point		:Point		= new Point(outsidePadding, outsidePadding);
				var offset		:Point		= new Point(0, 0);
				var height		:Number		= 0;
				var maxWidth	:Number		= useStage ? parent.stage.stageWidth : parent.width;
				var bounds		:Rectangle;
				
			// layout loop
				for each(var element:DisplayObject in elements) 
				{
					// if x > width, reset
						if (point.x + element.width + (outsidePadding * 2) > maxWidth)
						{
							point	= new Point(outsidePadding, point.y + height + hGutter);
							offset	= new Point(0, 0)
						}
						
					// add
						parent.addChild(element);
						
					// variables
						bounds		= element.getBounds(element);
					
					// debug
						//trace(element, local);
						
					// offset
						offset.x	= - bounds.x;
						offset.y	= - bounds.y;
						
					// move
						element.x	= point.x + offset.x;
						element.y	= point.y + offset.y;
						
					// max height of row
						if (bounds.height > height)
						{
							height = element.height;
						}
						
					// update
						point.x		+= element.width + vGutter;
				}
		}
		
		/**
		 * Gets the visible bounds of an object
		 * @see		http://blog.open-design.be/2010/01/26/getbounds-on-displayobject-not-functioning-properly/
		 * @param	displayObject
		 * @return
		 */
		public static function getRealBounds(displayObject:DisplayObject):Rectangle
		{
			// variables
				var bounds				:Rectangle;
				var boundsDispO			:Rectangle		= displayObject.getBounds( displayObject );
				var bitmapData			:BitmapData		= new BitmapData( int( boundsDispO.width + 0.5 ), int( boundsDispO.height + 0.5 ), true, 0 );
				var matrix				:Matrix			= new Matrix();
				
			// offset centerpoint
				matrix.translate( -boundsDispO.x, -boundsDispO.y);

			// draw bitmap of object's contents
				bitmapData.draw( displayObject, matrix, new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ) );

			// calculate bounds using bitmap color bounds
				bounds		= bitmapData.getColorBoundsRect( 0xFF000000, 0xFF000000 );
				bounds.x	+= boundsDispO.x;
				bounds.y	+= boundsDispO.y;
				bitmapData.dispose();
				
			// return
				return bounds;
		}
		
		public static function getScreenBounds(element:DisplayObject):Rectangle
		{
			var p1	:Point = element.localToGlobal(new Point(0, 0));
			var p2	:Point = element.localToGlobal(new Point(element.width, element.height));
			return new Rectangle(p1.x, p1.y, p2.x - p1.x, p2.y - p1.y);
		}

		/**
		 * Gets the string path to an item from the root
		 * @param	element
		 * @return
		 */
		public static function getPath(element:DisplayObject):String
		{
			var elements	:Array	= [element.name];
			while (element.parent)
			{
				element = element.parent;
				elements.push(element.name);
			}
			return elements.reverse().join('.');
		}
		
		/**
		 * Gets the string path to an item from the root
		 * @param	element
		 * @return
		 */
		public static function getHierarchy(element:DisplayObject):String
		{
			var elements	:Array	= [element + ' : ' + element.name];
			while (element.parent)
			{
				element = element.parent;
				elements.push(element + ' : ' + element.name);
			}
			return '\n > ' + elements.reverse().join('\n > ');
		}
		
		static public function getByPath(source:DisplayObjectContainer, path:String):DisplayObject 
		{
			// variables
			var target	:DisplayObject		= source;
			var names	:Array				= path.split('/');
			var name	:String;
			
			// get target
			while (names.length) 
			{
				name	= names.shift();
				target	= (target as DisplayObjectContainer).getChildByName(name);
				if ( ! target )
				{
					throw new Error('Failed to find element "' +name+ '" in element "' + getPath(target)) + '"';
				}
			}
			
			// return
			return target;		
		}
		
		static public function getBytes(src:DisplayObject, alpha:Boolean = false, color:int = 0x000000):BitmapData 
		{
			// variables
				var width		:int			= src.width;
				var height		:int			= src.height;
				var rect		:Rectangle		= new Rectangle(0, 0, width, height);
				var pt			:Point			= new Point(0, 0);
			
			// get and copy data
				var srcData		:BitmapData		= new BitmapData(width, height, alpha, color);
				var trgData		:BitmapData		= new BitmapData(width, height);

			// Copy pixels
				srcData.draw(src);
				trgData.copyPixels(srcData, rect, pt);

			// return data
				return trgData;
		}
		
		static public function getBitmap(src:DisplayObject, alpha:Boolean = false, color:int = 0x000000):Bitmap
		{
			return new Bitmap(getBytes(src, alpha, color));
		}
		
		public static function fullscreen(element:DisplayObject, onExitFullscreen:Function = null):void 
		{
			var stage:Stage = element.stage;
			if (stage && stage.displayState != StageDisplayState.FULL_SCREEN)
			{
				// set full screen
				// @see http://help.adobe.com/en_US/as3/dev/WS44B1892B-1668-4a80-8431-6BA0F1947766.html
				var rect:Rectangle			= getScreenBounds(element); 
				stage.fullScreenSourceRect	= rect; 
				stage.displayState			= StageDisplayState.FULL_SCREEN;
				
				// add onExit functionality
				if (onExitFullscreen is Function)
				{
					stage.addEventListener(Event.FULLSCREEN, function(event:Event):void 
					{ 
						Object(event.currentTarget).removeEventListener(event.type, arguments.callee);
						onExitFullscreen();
					});
				}
			}
		}

	}

}

