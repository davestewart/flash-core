package core.data.settings 
{
	import core.data.settings.Settings;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.VideoStreamSettings;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class CameraSettings extends Settings 
	{
					
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function CameraSettings() 
			{
				super('VideoSettings', true, 'width height quality fps format bandwidth keyframeInterval');
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get width():int { return _data.width; }
			public function set width(value:int):void 
			{
				set('width', value);
			}

			public function get height():int { return _data.height; }
			public function set height(value:int):void 
			{
				set('height', value);
			}

			public function get quality():int { return _data.quality; }
			public function set quality(value:int):void 
			{
				set('quality', value);
			}

			public function get fps():int { return _data.fps; }
			public function set fps(value:int):void 
			{
				set('fps', value);
			}

			public function get format():String { return _data.format; }
			public function set format(value:String):void 
			{
				if (/^(flv|mp4)$/.test(value))
				{
					set('format', value);
				}
				else
				{
					throw new Error('Invalid video format "' +value+ '"');
				}
			}

			public function get bandwidth():int { return _data.bandwidth; }
			public function set bandwidth(value:int):void 
			{
				set('bandwidth', value);
			}

			public function get keyframeInterval():int { return _data.keyframeInterval; }
			public function set keyframeInterval(value:int):void 
			{
				set('keyframeInterval', value);
			}

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}