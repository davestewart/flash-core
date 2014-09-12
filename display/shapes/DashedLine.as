package {
	import flash.geom.Point;
	import flash.display.LineScaleMode;
	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * Use as you wish. Commercial or otherwise. Give away. Sharing is caring.
	 * @author Oyvind Nordhagen - http://www.oyvindnordhagen.com
	 */
	public class DashedLine extends Shape {
		private var _width:uint;
		private var _color:uint;
		private var _dash:uint;
		private var _gap:uint;
		private var _thickness:uint;

		public function DashedLine ( width:uint, color:uint = 0, dash:uint = 3, gap:uint = 2, thickness:uint = 1 ) {
			_thickness = thickness;
			_gap = gap;
			_dash = dash;
			_color = color;
			_width = width;
			draw();
		}

		public function drawBetween ( point1:Point, point2:Point ):void {
			x = point1.x;
			y = point1.y;
			var dx:Number = point2.x - point1.x;
			var dy:Number = point2.y - point1.y;
			_width = Math.sqrt( dx * dx + dy * dy );
			rotation = Math.atan2( dy, dx ) * 180 / Math.PI;
			draw();
		}

		override public function get width ():Number {
			return _width;
		}

		override public function set width ( width:Number ):void {
			_width = width;
			draw();
		}

		public function get color ():uint {
			return _color;
		}

		public function set color ( color:uint ):void {
			_color = color;
			draw();
		}

		public function get dash ():uint {
			return _dash;
		}

		public function set dash ( dash:uint ):void {
			_dash = dash;
			draw();
		}

		public function get gap ():uint {
			return _gap;
		}

		public function set gap ( gap:uint ):void {
			_gap = gap;
			draw();
		}

		public function get thickness ():uint {
			return _thickness;
		}

		public function set thickness ( thickness:uint ):void {
			_thickness = thickness;
			draw();
		}

		private function draw ():void {
			var retainer:Number = _width;
			var pos:uint = 0;
			var dashPlusGap:uint = _dash + _gap;
			var g:Graphics = graphics;
			g.clear();
			g.moveTo( 0, 0 );
			g.lineStyle( _thickness, _color, 1, false, LineScaleMode.NONE );

			while (retainer > 0) {
				g.moveTo( pos, 0 );
				pos += _dash;
				g.lineTo( pos, 0 );
				pos += _gap;
				retainer -= dashPlusGap;
			}
		}
	}
}
