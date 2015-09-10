package core.media.data 
{
	/**
	 * @see http://help.adobe.com/en_US/as3/dev/WSD30FA424-950E-43ba-96C8-99B926943FE7.html	
	 * @author Dave Stewart
	 */
	dynamic public class FLVMetadata extends VideoMetadata
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			/// An array of objects, one for each cue point embedded in the FLV file. Value is undefined if the FLV file does not contain any cue points.
			public var cuepoints		:Vector.<CuePoint>;

			/// AAC audio object type; 0, 1, or 2 are supported.
			public var aacaot			:Number;

			/// AVC IDC level number such as 10, 11, 20, 21, and so on.
			public var avclevel			:Number;

			/// AVC profile number such as 55, 77, 100, and so on.
			public var avcprofile		:Number;

			/// A string that indicates the audio codec (code/decode technique) that was used - for example “.Mp3” or “mp4a”
			public var audiocodecid		:String;

			/// A number that indicates the rate at which audio was encoded, in kilobytes per second.
			public var audiodatarate	:Number;

			/// A number that indicates what time in the FLV file "time 0" of the original FLV file exists. The video content needs to be delayed by a small amount to properly synchronize the audio.
			public var audiodelay		:Number;

			/// A Boolean value that is true if the FLV file is encoded with a keyframe on the last frame, which allows seeking to the end of a progressive -download video file. It is false if the FLV file is not encoded with a keyframe on the last frame.
			public var canSeekToEnd		:Boolean;

			/// An array that lists the available keyframes as timestamps in milliseconds. Optional.
			public var seekpoints		:Array;

			/// An array of key-value pairs that represent the information in the “ilst” atom, which is the equivalent of ID3 tags for MP4 files. iTunes uses these tags. Can be used to display artwork, if available.
			public var tags				:Array;

			/// Object that provides information on all the tracks in the MP4 file, including their sample description ID.
			public var trackinfo		:Object;

			/// A string that is the codec version that was used to encode the video. - for example, “avc1” or “VP6F”
			public var videocodecid		:String;

			/// A number that is the video data rate of the FLV file.
			public var videodatarate	:int;

			/// Framerate of the MP4 video.
			public var videoframerate	:int;

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function FLVMetadata(data:Object) 
			{
				super(data);
			}
			
			override protected function initialize():void 
			{
				for (var name:String in _data)
				{
					if (name.toLowerCase() === 'cuepoints')
					{
						if (_data[name])
						{
							var cuepoints:Array	= _data[name];
							if (cuepoints.length)
							{
								this.cuepoints = new Vector.<CuePoint>;
								for each (var obj:Object in cupoints) 
								{
									this.cuepoints.push(new CuePoint(obj));
								}
							}
						}
					}
					else
					{
						this[name] = data[name];
					}
				}				
			}
		
	}

}