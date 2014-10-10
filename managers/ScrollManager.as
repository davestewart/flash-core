package managers 

{
	import fl.controls.ScrollBar;
	import fl.events.ScrollEvent;
	import flash.display.DisplayObjectContainer;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * Handles scrolling of entire application. Is instantiated from Main.as
	 * @requires	A scrollbar component instance
	 * @author		Dave Stewart
	 */
	public class ScrollManager
	{
		// ---------------------------------------------------------------------------------------------------------------------
		// variables
		
			protected static var _instance		:ScrollManager;
			
			protected var scrollBar				:ScrollBar;
			protected var stage					:Stage;
			protected var content				:Array;
			
			protected var pageSize				:Number;
			protected var scroll				:Number;
			protected var maxScroll				:Number;
			
			protected var _active				:Boolean;
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// instantiation
		
			/**
			 * The constructor, which requires a scrollbar element on the stage, plus content to scroll
			 * @param	scrollBar
			 * @param	... elements
			 */
			public function ScrollManager(scrollBar:ScrollBar, ... elements)
			{
				// scrollbar
					this.scrollBar		= scrollBar;

				// variables
					content				= new Array();
					stage				= scrollBar.stage
					scroll				= 0;
					_active				= true;
					
				// set content
					for (var i:int = 0; i < elements.length; i++) 
					{
						content.push(elements[i]);
					}
					
				// events
					stage.addEventListener(Event.RESIZE, onStageResize);
					stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
					scrollBar.addEventListener(ScrollEvent.SCROLL, onScrollBarScroll)
					scrollBar.lineScrollSize = 100;
					
				// update
					update();
			}
			
			
			public static function get instance():ScrollManager 
			{
				return ScrollManager._instance;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// content and properties
			
			/**
			 * Sets the content that the scrollbar will scroll
			 * @param	... elements
			 */
			public function setContent(... elements):void 
			{
				_active = true;
				for (var i:int = 0; i < elements.length; i++) 
				{
					content.push(elements[i]);
				}
			}
			
			/**
			 * update all content sizes and scrollbars
			 */
			public function update():void 
			{
				// page parameters
					pageSize		= stage.stageHeight;
					maxScroll		= contentHeight - pageSize;
					
				// reset positions of elements if already scrolled too far
					if (scroll > maxScroll)
					{
						scroll = maxScroll;
						scrollContent();
					}
					
				// reset positions of elements if no scrolling
					if (maxScroll <= 0)
					{
						maxScroll	= 0;
						scroll		= 0;
						scrollContent();
					}

				// update scrollbar parameters
					scrollBar.setScrollProperties(pageSize, 0, maxScroll, 20);
				
				// position
					scrollBar.x = stage.stageWidth - scrollBar.width;
					scrollBar.setSize(scrollBar.width, stage.stageHeight);
			}
			
			public function set active(state:Boolean):void 
			{
				_active = state;
				visible = state;
			}
			
			public function set visible(state:Boolean):void 
			{
				scrollBar.visible = state;;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// utilities
		
			/**
			 * Moves the content layers to achieve scrolling
			 */
			protected function scrollContent():void 
			{
				for (var i:int = 0; i < content.length; i++) 
				{
					content[i].y = -scroll;
				}
			}
			
			/**
			 * Gets the current content height
			 */
			protected function get contentHeight():Number
			{
				var contentHeight:Number			= 0;
				for (var i:int = 0; i < content.length; i++) 
				{
					var element		:DisplayObject	= content[i];
					var bounds		:Rectangle		= element.getBounds(element);
					var height		:Number			= bounds.y + bounds.height;
					if (height > contentHeight)
					{
						contentHeight = height;
					}
				}
				return contentHeight;
			}
			
		// ---------------------------------------------------------------------------------------------------------------------
		// handlers
			
			protected function onStageResize(event:Event):void 
			{
				update();
			}
			
			protected function onMouseWheel(event:MouseEvent):void 
			{
				if (_active)
				{
					scroll -= event.delta * 10;
					if (scroll < 0)
					{
						scroll = 0;
					}
					if (scroll > maxScroll)
					{
						scroll = maxScroll;
					}
					
					scrollContent();
					scrollBar.setScrollPosition(scroll);
				}
			}
			
			protected function onScrollBarScroll(event:ScrollEvent):void 
			{
				scroll = event.position;
				scrollContent();
			}
			
	}

}