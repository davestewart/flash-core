package core.display.elements
{

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	/**
	 * Core site Preloader clip. Override this in your application to 
	 * @author Dave Stewart
	 */
	public class Preloader extends MovieClip 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// stage instances
				
			
			// properties

				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Preloader() 
			{
				// setup loader
					addEventListener(Event.ENTER_FRAME, onEnterFrame);
					loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
					loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					
				// show loader
					initialize();
					build();
			}
			
			protected function initialize():void 
			{
				if (stage)
				{
					stage.scaleMode	= StageScaleMode.NO_SCALE;
					stage.align		= StageAlign.TOP_LEFT;
				}
			}
		
			protected function build():void 
			{
				
			}
		

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		

			protected function update(ratio:Number):void
			{
				trace('Loaded ' + int(ratio * 100) + '%');
			}
			
			protected function complete():void 
			{
				addChild(new Main());
			}
			
			protected function error(event:IOErrorEvent):void 
			{
				// add text
					var tf:TextField	= new TextField();
					tf.width			= stage.stageWidth;
					tf.height			= stage.stageHeight;
					tf.multiline		= true;
					tf.text				= event.text;
					addChild(tf);
					
				// debug
					trace(event.text);
			}
		
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers

			private function onProgress(event:ProgressEvent):void 
			{
				update(event.bytesLoaded / event.bytesTotal);
			}
			
			private function onEnterFrame(event:Event):void 
			{
				if (currentFrame == totalFrames) 
				{
					stop();
					onComplete();
				}
			}
						
			private function onIOError(event:IOErrorEvent):void 
			{
				error(event);
			}
			
			private function onComplete():void 
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				complete();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
	}
	
}