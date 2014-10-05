package core.utils {
	import core.utils.Objects;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
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
									
							// index
								case 'index':
									(src.parent || trg.parent).addChildAt(src, trg.parent.getChildIndex(trg));
									break;	
									
							// hide
								case 'hide':
									trg.visible		= false;
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
		
		/**
		 * Draws a rectangle around the display object in case you can't see it on the stage
		 * @param	element
		 * @param	color
		 * @param	alpha
		 */
		public static function identify(element:DisplayObjectContainer, color:int = 0xFF0000, alpha:Number = 0.1, lineThickness:Number = 0.1):void
		{
			// remove prior rect  object
				var rect:Sprite = element.getChildByName('__rect') as Sprite;
				if (rect)
				{
					element.removeChild(rect);
				}
				
			// new bounds
				var bounds:Rectangle		= element.getBounds(element);
					
			// create rect	
				rect						= new Sprite();
				rect.name					= '__rect';
				rect.mouseEnabled			= false;
				
				rect.graphics.lineStyle(lineThickness, color);
				rect.graphics.beginFill(color, alpha);
				rect.graphics.drawRect(bounds.x - 1, bounds.y - 1, bounds.width + 2, bounds.height + 2);
				
			// add rect
				element.alpha				= 1;
				element.visible				= true;
				element.addChild(rect);
				
			// add textfield
				var tf:TextField			= new TextField();
				tf.textColor				= color;
				tf.autoSize					= 'left';
				tf.defaultTextFormat		= new TextFormat('_sans', 10, 0xFFFFFF);
				tf.backgroundColor			= color;
				tf.background				= true;
				tf.text						= ' ' + element.name + ' ' + String(element) + ' ';
				rect.addChild(tf);
				
			// make parents visible
				/*
				while (element.parent)
				{
					element.parent.visible	= true;
					element.parent.alpha	= 1;
					element					= element.parent;
				}
				*/
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
		


	}

}