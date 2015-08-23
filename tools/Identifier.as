package core.tools 
{

	import core.display.elements.Element;
	import core.utils.Elements;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Identifier extends Element 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// stage instances
				protected var tf			:TextField;
				
				
			// properties
				protected var _source		:DisplayObject;
				protected var _bounds		:Rectangle;
				protected var _color		:Number;
				protected var _alpha		:Number;
				protected var _outside		:Boolean;
				protected var _parent		:DisplayObjectContainer;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Identifier(source:DisplayObject, color:Number = 0xFF0000, alpha:Number = 0.1, outside:Boolean = false):void 
			{
				// parameters
				_source		= source;
				_alpha		= alpha;
				_color		= color;
				_outside	= outside;
				super();
			}
			
			override protected function initialize():void 
			{
				// properties
					name		= source.name + '__identifier';
					_bounds		= source.getBounds(_parent);
					_parent		= _outside || (! source is DisplayObjectContainer) ? source.parent : source as DisplayObjectContainer
					
				// debug
					trace('Identify: ' +source + ' ' + _bounds);
			}
		
			override protected function build():void 
			{
				// properties
					mouseEnabled					= false;
										
				// add textfield
					tf								= new TextField();
					tf.defaultTextFormat			= new TextFormat('_sans', 10, 0xFFFFFF);
					tf.backgroundColor				= color;
					tf.background					= true;
					tf.autoSize						= 'left';
					tf.text							= ' ' + source.name + ' ' + String(source) + ' ';
					addChild(tf);
					
				// make source visible		
					source.alpha					= 1;
					source.visible					= true;
					
				// events
					addEventListener(MouseEvent.CLICK, onClick);

				// add rect
					_parent.addChild(this);
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function removeDuplicates():void
			{
				if (source is DisplayObjectContainer)
				{
					var target:DisplayObject = (source as DisplayObjectContainer).getChildByName(source.name + '__identifier');
					if (target)
					{
						(source as DisplayObjectContainer).removeChild(target);
					}
				}
			}
		
			public function showParents():void 
			{
				var parent:DisplayObjectContainer = source as DisplayObjectContainer;
				while (parent.parent)
				{
					parent.parent.visible	= true;
					parent.parent.alpha		= 1;
					parent					= parent.parent;
				}
			}
		
			override public function invalidate():void 
			{
				initialize();
				super.invalidate();
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get color():Number { return _color; }
			public function set color(value:Number):void 
			{
				_color = value;
				invalidate();
			}
			
			override public function get alpha():Number { return _color; }
			override public function set alpha(value:Number):void 
			{
				_alpha = value;
				invalidate();
			}
			
			public function get source():DisplayObject { return _source; }
			
			public function get bounds():Rectangle { return _bounds; }
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			override protected function draw():void 
			{
				// outline
					graphics.clear();
					graphics.lineStyle(0.25, color);
					graphics.beginFill(color, 0.1);
					graphics.drawRect(bounds.x - 0.5, bounds.y - 0.5, bounds.width + 0.5, bounds.height + 0.5);
				
			}		
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onClick(event:MouseEvent):void 
			{
				trace('Hierarchy: ' + Elements.getHierarchy(source));
			}
			
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}

