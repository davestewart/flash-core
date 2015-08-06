package core.media.video.flashywrappers 
{
	import cc.minos.codec.flv.*;
	import cc.minos.codec.mov.*;
	import core.media.video.VideoPlayer;
	import flash.display.DisplayObjectContainer;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoPlayer extends core.media.video.VideoPlayer 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var bytes				:ByteArray;
				protected var keyframes			:Vector.<Frame>;
				
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
				var mp4:Mp4Codec	= new Mp4Codec();;
				var flv:FlvCodec	= new FlvCodec();
				
				// convert mp4 bytes to flv
				mp4.decode(bytes);
				this.bytes			= flv.encode(mp4);
				
				// grab keyframes for later
				var keys:Array		= flv.getKeyframes();
				keyframes			= new Vector.<Frame>;
				keyframes.push(new Frame(keys[0]));
				keyframes.push(new Frame(keys[1]));
			}
			
			override public function play():void 
			{
				// set up the stream
				_stream			= new NetStream(connection);
				_stream.client	= {};
				_stream.play(null);
				
				// attach stream to video
				video.attachNetStream(stream);

				// variables
				var buffer:ByteArray;
				
				// create a buffer and write keyframe 1 to it
				buffer = new ByteArray();
				buffer.writeBytes(bytes, 0, keyframes[1].pos + 10240);
				
				// append buffer to stream
				stream.appendBytes(buffer);

				// seek just before first keyframe
				stream.seek(keyframes[0].time - 0.01);

				// create a new buffer and write the entire video
				buffer = new ByteArray();
				buffer.writeBytes(bytes, keyframes[0].pos);
				
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