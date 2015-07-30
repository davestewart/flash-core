package core.display.elements 
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.ColorTransformPlugin;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import flash.events.Event;
	
	/**
	 * Core Document class, mainly to get started quickly with development tests
	 * 
	 * @author Dave Stewart
	 */
	public class Document extends Sprite 
	{

		public function Document(align:Boolean = false):void 
		{
			// sort stage
				stage.align				= align ? StageAlign.TOP_LEFT : '';
				stage.scaleMode			= StageScaleMode.NO_SCALE;
				stage.stageFocusRect    = false;
				
			// TweenLite plugins
				TweenPlugin.activate([AutoAlphaPlugin, TintPlugin, ColorTransformPlugin]);
			
			// attach monsterdebugger
				MonsterDebugger.initialize(this);
		}

	}

}