package core.utils 
{
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Numbers 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: rotations
		
			/**
			 * Finds shortest rotation distance between 2 angles (radians)
			 * @see	http://stackoverflow.com/questions/1878907/the-smallest-difference-between-2-angles/2007279#2007279
			 * @param	a	Angle in radians
			 * @param	b	Angle in radians
			 * @return		Angle in radians
			 */
			public static function distRad(a:Number, b:Number):Number
			{
				return Math.atan2(Math.sin(a - b), Math.cos(a - b));
			}

			/**
			 * Finds shortest rotation distance between 2 angles (degrees)
			 * Normalises input to 360 degrees
			 * @param	a	Angle in degrees
			 * @param	b	Angle in degrees
			 * @return		Angle in degrees
			 */
			public static function distDeg(a:Number, b:Number):Number
			{
				var rad:Number = Math.PI / 180;
				a = a % 360;
				b = b % 360;
				a *= rad;
				b *= rad;
				return Math.atan2(Math.sin(a - b), Math.cos(a - b)) * (180 / Math.PI);
			}

			/**
			 * Finds the unsigned shortest rotation distance between 2 angles (degrees or radians)
			 * Normalises input to 360 degrees
			 * @param	a	Angle in degrees or radians
			 * @param	b	Angle in degrees or radians
			 * @return		Angle in degrees
			 */
			public static function distDegUnsigned(a:Number, b:Number):Number 
			{
				a = a % 360;
				b = b % 360;
				var v:Number = Math.abs(a - b);
				return Math.min(360 - v, v);
			}		
			
	}

}