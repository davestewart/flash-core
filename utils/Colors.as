package core.utils
{
	public class Colors
	{
		
		public static function rgbToHex(r:uint, g:uint, b:uint):uint
		{
			var hex:uint = (r << 16 | g << 8 | b);
			return hex;
		}
		
		public static function hexToRgb(hex:uint):Array
		{
			var rgb:Array = [];
			
			var r:uint = hex >> 16 & 0xFF;
			var g:uint = hex >> 8 & 0xFF;
			var b:uint = hex & 0xFF;
			
			rgb.push(r, g, b);
			return rgb;
		}
		
		public static function rgbToHsv(r:Number, g:Number, b:Number):Array
		{
			var max:uint = Math.max(r, g, b);
			var min:uint = Math.min(r, g, b);
			
			var hue:Number = 0;
			var saturation:Number = 0;
			var value:Number = 0;
			
			var hsv:Array = [];
			
			//get Hue
			if(max == min){
				hue = 0;
			}else if(max == r){
				hue = (60 * (g-b) / (max-min) + 360) % 360;
			}else if(max == g){
				hue = (60 * (b-r) / (max-min) + 120);
			}else if(max == b){
				hue = (60 * (r-g) / (max-min) + 240);
			}
			
			//get Value
			value = max;
			
			//get Saturation
			if(max == 0){
				saturation = 0;
			}else{
				saturation = (max - min) / max;
			}
			
			hsv = [Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];
			return hsv;
		}
		
		public static function hsvToRgb(h:Number, s:Number, v:Number):Array
		{
			var r:Number = 0;
			var g:Number = 0;
			var b:Number = 0;
			var rgb:Array = [];
			
			var tempS:Number = s / 100;
			var tempV:Number = v / 100;
			
			var hi:int = Math.floor(h/60) % 6;
			var f:Number = h/60 - Math.floor(h/60);
			var p:Number = (tempV * (1 - tempS));
			var q:Number = (tempV * (1 - f * tempS));
			var t:Number = (tempV * (1 - (1 - f) * tempS));
			
			switch(hi){
				case 0: r = tempV; g = t; b = p; break;
				case 1: r = q; g = tempV; b = p; break;
				case 2: r = p; g = tempV; b = t; break;
				case 3: r = p; g = q; b = tempV; break;
				case 4: r = t; g = p; b = tempV; break;
				case 5: r = tempV; g = p; b = q; break;
			}
			
			rgb = [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
			return rgb;
		}
		
		public static function getAnalogousFromHex(c:uint,rot:Number):uint
		{
			var r:Number=extractRedFromHex(c);
			var g:Number=extractGreenFromHex(c);
			var b:Number = extractBlueFromHex(c); 
			
			var hsv:Array = rgbToHsv(r, g, b);
			var h:Number = hsv[0];
			var s:Number = hsv[1];
			var v:Number = hsv[2];
			
			h += rot;
			
			if (h < 0) { h = 359 - h }
			else if (h > 359) { h = h - 359 };
			
			var rgb:Array = hsvToRgb(h, s, v);
			
			return rgbToHex(rgb[0], rgb[1], rgb[2]);
		}
		
		public static function hexTriad(c:uint):Array
		{
			var c1:uint = c;
			var c2:uint = getAnalogousFromHex(c, 120);
			var c3:uint = getAnalogousFromHex(c, 240);
			
			var triad:Array = [c1, c2, c3];
			
			return triad;
		}
		
		public static function hexTetrad(c:uint):Array
		{
			var c1:uint = c;
			var c2:uint = getAnalogousFromHex(c, 90);
			var c3:uint = getAnalogousFromHex(c, 180);
			var c4:uint = getAnalogousFromHex(c, 270);
			
			var tetrad:Array = [c1, c2, c3, c4];
			
			return tetrad;
		}
		
		public static function hexToValue(hex:String):int
		{
			var matches	:Array = hex.match(/#?([\da-f]{6}$)/i);
			if (matches)
			{
				return parseInt(matches[1], 16)
			}
			return -1;
		}
		
		public static function invertHex(c:uint):uint
		{
			var r:Number=extractRedFromHex(c);
			var g:Number=extractGreenFromHex(c);
			var b:Number=extractBlueFromHex(c);
			
			r = (255 - r);
			g = (255 - g);
			b = (255 - b);
			
			return rgbToHex(r, g, b);
		}
		public static function hexHue(c:uint,a:Number):uint
		{
			var r:Number=extractRedFromHex(c);
			var g:Number=extractGreenFromHex(c);
			var b:Number = extractBlueFromHex(c); 
			
			var hsv:Array = rgbToHsv(r, g, b);
			var h:Number = hsv[0];
			var s:Number = hsv[1];
			var v:Number = hsv[2];
			
			h = a;
			
			if (h < 0) { h = 359 - h }
			else if (h > 359) { h = h - 359 };
			
			var rgb:Array = hsvToRgb(h, s, v);
			
			return rgbToHex(rgb[0], rgb[1], rgb[2]);
		}
		public static function hexBrightness(c:uint,a:Number):uint
		{
			var r:Number=extractRedFromHex(c);
			var g:Number=extractGreenFromHex(c);
			var b:Number=extractBlueFromHex(c);
			
			var hsv:Array = rgbToHsv(r,g,b);
			
			if (a < 0){a = 0};
			if (a > 1){a = 1};
			
			a *= 100;
			
			hsv[2] = a;
			
			
			var rgb:Array = hsvToRgb(hsv[0],hsv[1],hsv[2]);
			
			return rgbToHex(rgb[0],rgb[1],rgb[2]);
		}
		
		public static function hexSaturation(c:uint,a:Number):uint
		{
			var r:Number=extractRedFromHex(c);
			var g:Number=extractGreenFromHex(c);
			var b:Number=extractBlueFromHex(c);
			
			var hsv:Array = rgbToHsv(r,g,b);
			
			if (a < 0){a = 0};
			if (a > 1){a = 1};
			
			a *= 100;
			
			hsv[1] = a;
			
			var rgb:Array = hsvToRgb(hsv[0],hsv[1],hsv[2]);
			
			return rgbToHex(rgb[0],rgb[1],rgb[2]);
		}
		
		public static function hexToString(c:uint,t:Boolean):String
		{
			//return uint in form 0xFFFFFF or #FFFFFF as string
			var r:String=extractRedFromHex(c).toString(16).toUpperCase();
			var g:String=extractGreenFromHex(c).toString(16).toUpperCase();
			var b:String=extractBlueFromHex(c).toString(16).toUpperCase();
			var hs:String="";
			var zero:String="0";
			
			if(r.length==1){r=zero.concat(r)};
			if(g.length==1){g=zero.concat(g)};
			if(b.length==1){b=zero.concat(b)};
			
			if (t){hs="0x"+r+g+b} else {hs="#"+r+g+b};
			
			return hs;
		}
		
		public static function hexString(hex:String):uint
		{
			hex = hex.replace('#', '');
			if (hex.substr(0, 2) != "0x")
			{
				hex = "0x" + hex;
			}
			return new uint(hex);
		}
		
		public static function hexToGreyScale(c:uint):uint
		{
			var r:Number=extractRedFromHex(c);
			var g:Number=extractGreenFromHex(c);
			var b:Number=extractBlueFromHex(c);
			
			var av:Number = (r + g + b) / 3;
			
			r = g = b = av;
			
			return rgbToHex(r, g, b);
		}
		
		public static function colouriseHex(c:uint,r:Number,g:Number,b:Number):uint
		{
			if (r>1){r=1}
			else if (r<-1){r=0};
			if (g>1){g=1}
			else if (g<-1){g=0};
			if (b>1){b=1}
			else if (b<-1){b=-1};
			
			var rE:Number=extractRedFromHex(c);
			var gE:Number=extractGreenFromHex(c);
			var bE:Number=extractBlueFromHex(c);
			
			rE = rE * r;
			gE = gE * g;
			bE = bE * b;
			
			if (r>255){r=255};
			if (g>255){g=255};
			if (b>255){b=255};
			if (r<0){r=0};
			if (g<0){g=0};
			if (b<0){b=0};
			
			return rgbToHex(rE, gE, bE);
		}
		
		public static function rgbHexToARgbHex(rgb:uint, newAlpha:uint):uint
		{
			//newAlpha has to be in the 0 to 255 range
			var argb:uint = 0;
			argb += (newAlpha<<24);
			argb += (rgb);
			return argb;
		}
		
		public static function extractRedFromHex(c:uint):uint
		{
			return (( c >> 16 ) & 0xFF);
		}
		
		public static function extractGreenFromHex(c:uint):uint
		{
			return ( (c >> 8) & 0xFF );
		}
		
		public static function extractBlueFromHex(c:uint):uint
		{
			return ( c & 0xFF );
		}
	}
}