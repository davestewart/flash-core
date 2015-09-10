package core.display.waveform 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import core.display.elements.Invalidatable;
	
	/**
	 * ...
	 * @author Dave Stewart
	 * 
	 * @see http://philippseifried.com/blog/2011/10/13/dynamic-audio-in-as3-part-2-basics/
	 * @see http://www.marinbezhanov.com/web-development/14/actionscript-3-sound-extract-demystified-or-how-to-draw-a-waveform-in-flash/
	 */
	public class Waveform extends Invalidatable 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// dimensions
				protected var _width			:uint;
				protected var _height			:uint;
				
			// bitmap
				protected var buffer			:BitmapData;
				protected var bitmap			:Bitmap;

			// sound
				protected var bytes				:ByteArray;
				protected var length			:Number;
				
			// properties
				protected var _channel			:String;
				protected var _resolution		:int;
				
			// drawing
				protected var numSteps			:uint;
				protected var stepSize			:uint;
				protected var stepIndex			:uint;
				
			// variables
				protected var rect				:Rectangle;
				protected var mid				:int;
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Waveform(width:uint, height:uint, resolution:int = -1, channel:String = 'left') 
			{
				// parameters
				_height				= height;
				_width				= width;
				
				// build
				bitmap				= new Bitmap();
				addChild(bitmap);
				
				// parameters
				this.resolution		= resolution > 0 ? resolution : _width;
				this.channel		= channel;
				
				// initialize
				initialize();
			}
			
			protected function initialize():void 
			{
				rect	= new Rectangle(0, 0, 1, 0);
				mid		= height / 2;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		

		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function set sound(sound:Sound):void 
			{
				// get bytes
				bytes			= new ByteArray();
				length			= Math.floor((sound.length / 1000) * 44100);
				sound.extract(bytes, length, 0);
				
				// update
				updateSteps();
				draw();
			}
		
			override public function get width():Number{ return _width; }
			override public function set width(value:Number):void 
			{
				_width = value;
				invalidate();
			}
		
			override public function get height():Number{ return _height; }
			override public function set height(value:Number):void 
			{
				_height	= value;
				mid		= value / 2;
				invalidate();
			}
			
			public function get resolution():int { return _resolution; }
			public function set resolution(value:int):void 
			{
				if (value < 1)
				{
					value = 1;
				}
				_resolution = value;
				updateSteps();
				invalidate();
			}
			
			public function get channel():String { return _channel; }
			public function set channel(value:String):void 
			{
				if (! /^(left|right|both)$/.test(value) )
				{
					throw Error('property "channel" must be one of "left", "right" or "both"');
				}
				_channel = value;
				invalidate();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function updateSteps():void 
			{
				if (bytes)
				{
					// update stepSize
					stepSize	= Math.floor(length / _resolution);
					
					// ensure step is a factor of 4 (so we align on starts of Numbers in bytearray)
					while (stepSize % 4 > 0)
					{
						stepSize--;
					}
					
					// update resolution in accordance with new sample size
					numSteps	= Math.floor(length / stepSize);
					
					// debug
					//trace(length, _resolution, numSteps, stepSize);
				}
			}

			
			protected function updateBitmap():void 
			{
				buffer = new BitmapData(_width, _height, false, 0);
			}
		
			override protected function draw():void 
			{
				if(bytes)
				{
					// variables
					var left		:Number;
					var right		:Number;
					var value		:Number;
					var ratio		:Number;
					
					// resets
					stepIndex				= 0;
					bytes.position			= 0;
					rect.x					= 0;
					
					// bitmap
					updateBitmap();
					buffer.lock()
					
					// fill background
					drawBackground();
					
					// consume bytes
					while (bytes.bytesAvailable)
					{
						// variables
						ratio			= stepIndex / numSteps;
						
						// read data
						left			= bytes.readFloat();
						right			= bytes.readFloat();
						
						// update position
						bytes.position	= stepIndex * stepSize * 8;
						
						// draw
						if (channel == 'left')
						{
							drawSample(left, stepIndex, ratio);
						}
						else if (channel == 'right')
						{
							drawSample(right, stepIndex, ratio);
						}
						else
						{
							drawSample(left, stepIndex, ratio);
							drawSample(right, stepIndex, ratio);
						}
						
						// values
						stepIndex++;
					}
					
					// update bitmap
					buffer.unlock();
					bitmap.bitmapData = buffer;
					
					// update
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
			
			protected function drawBackground():void 
			{
				buffer.fillRect(buffer.rect, 0x000000);
			}
		
			protected function drawSample(value:Number, stepIndex:int, ratio:Number):void 
			{
				// height
				value *= height;
				
				// x
				rect.x = ratio * width;
				
				// size
				if (value > 0) 
				{
					rect.y			= mid - value;
					rect.height		= value;
				}
				else 
				{
					rect.y			= mid;
					rect.height		= -value;
				}
				
				// draw
				buffer.fillRect(rect, 0xFFFFFF);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}