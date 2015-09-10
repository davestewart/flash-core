package core.display.waveform 
{
	/**
	 * Example of extended Waveform class, using an overridden drawSample() method to cache and aggregate samples
	 * 
	 * @author Dave Stewart
	 */
	public class BarWaveform extends Waveform 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var _barWidth			:uint;
				protected var _gutterWidth		:uint;
			
			// variables
				protected var cellWidth			:uint;
				protected var resWidth			:Number;
				protected var trgWidth			:Number;
				protected var curWidth			:Number;
				protected var barIndex			:uint;
				protected var values			:Array;
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function BarWaveform(width:int, height:int, barWidth:uint = 10, gutterWidth:int = 1, channel:String = 'left')
			{
				this.gutterWidth	= gutterWidth;
				this.barWidth		= barWidth;
				super(width, height, width, channel);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get barWidth():uint { return _barWidth; }
			public function set barWidth(value:uint):void 
			{
				if (value < 1)
				{
					value = 1;
				}
				_barWidth		= value;
				cellWidth		= _barWidth + _gutterWidth;
				invalidate();
			}
		
			public function get gutterWidth():uint { return _gutterWidth; }
			public function set gutterWidth(value:uint):void 
			{
				_gutterWidth	= value;
				cellWidth		= _barWidth + _gutterWidth;
				invalidate();
			}
		
			public function get numBars():int 
			{
				return barIndex;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function draw():void 
			{
				// variables
				resWidth	= _width / _resolution;
				curWidth	= 0;
				trgWidth	= 0;
				barIndex	= 0;
				
				// values
				values		= [];
				
				// reset rect
				rect.width	= barWidth;
				
				// draw
				super.draw();
			}
		
			override protected function drawSample(value:Number, stepIndex:int, ratio:Number):void 
			{
				// check to see if we've hit the threshold to create a new bar
				if (curWidth > trgWidth || stepIndex == numSteps)
				{
					// update x
					rect.x			= cellWidth * (barIndex - 1);
					
					// draw group
					drawGroup(values, barIndex);
					
					// reset
					barIndex++;
					trgWidth		+= cellWidth;
					values			= [];
				}
				
				// add the current value to the store
				else
				{
					values.push(value);
				}
				
				// update the current width
				curWidth += resWidth;
			}
			
			protected function drawGroup(values:Array, index:int):void 
			{
				// value
				var value:Number	= Math.abs(average(values));
				
				// coords
				rect.y				= mid - (value * height * 2);
				rect.height			= value * height * 4;
				
				// draw
				buffer.fillRect(rect, 0xFFFFFF);
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}

function average(values:Array):Number
{
	var total:Number = 0;
	for (var i:int = 0; i < values.length; i++) 
	{
		total += Math.abs(values[i]);
	}
	return total / values.length;
}