package core.media.video.flashywrappers 
{
	import cc.minos.codec.flv.*;
	import cc.minos.codec.mov.*;
	import core.events.MediaEvent;
	import core.media.video.VideoPlayer;
	import flash.display.DisplayObjectContainer;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.utils.ByteArray;
	
	/**
	 * This player is currently too unreliable to be used :(
	 * 
	 * @author Dave Stewart
	 */
	public class VideoPlayer extends core.media.video.VideoPlayer 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var bytes				:ByteArray;
				protected var frames			:Vector.<Frame>;
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoPlayer(width:int = 400, height:int = 300) 
			{
				super(width, height);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function loadBytes(bytes:ByteArray):void 
			{
				// variables
				var mp4:Mp4Codec	= new Mp4Codec();
				var flv:FlvCodec	= new FlvCodec
				
				// convert mp4 bytes to flv
				mp4.decode(bytes);
				this.bytes			= flv.encode(mp4);
				
				// grab flv keyframes for later
				var keyframes:Array	= flv.getKeyframes();
				frames				= new Vector.<Frame>;
				frames.push(new Frame(keyframes[0]));
				frames.push(new Frame(keyframes[1]));
				
				// event
				dispatchEvent(new MediaEvent(MediaEvent.LOADED));
			}
			
			override public function play():void 
			{
				// error if not bytes have been loaded
				if (bytes == null)
				{
					throw new Error('Cannot create / play stream as no bytes have been loaded');
				}
				
				// set up the stream
				setupStream();
				stream.play(null);
				
				// attach stream to video
				video.attachNetStream(stream);
				
				// event
				dispatchEvent(new MediaEvent(MediaEvent.STARTED));

				// variables
				var buffer:ByteArray;
				
				// create a buffer and write keyframe 1 to it
				buffer = new ByteArray();
				buffer.writeBytes(bytes, 0, frames[1].pos + 10240);
				
				// append buffer to stream
				stream.appendBytes(buffer);

				// seek just before first keyframe
				stream.seek(frames[0].time - 0.01);

				// create a new buffer and write the entire video
				buffer = new ByteArray();
				buffer.writeBytes(bytes, frames[0].pos);
				
				// append this new buffer to the stream
				stream.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
				stream.appendBytes(buffer);
				stream.appendBytesAction(NetStreamAppendBytesAction.END_SEQUENCE);			
			}							
		
	}

}

class Frame
{
	public var pos		:Number;
	public var time		:Number;
	
	public function Frame(frame:Object)
	{
		pos 	= frame.position;
		time	= frame.time;
	}
}