package core.media.data 
{
	import core.utils.Objects;
	/**
	 * ...
	 * @author Dave Stewart
	 */
	dynamic public class ID3 extends Metadata
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			/// The name of the album; corresponds to the ID3 2.0 tag TALB.
			public var album		:String;

			/// The name of the artist; corresponds to the ID3 2.0 tag TPE1.
			public var artist		:String;

			/// A comment about the recording; corresponds to the ID3 2.0 tag COMM.
			public var comment		:String;

			/// The genre of the song; corresponds to the ID3 2.0 tag TCON.
			public var genre		:String;

			/// The name of the song; corresponds to the ID3 2.0 tag TIT2.
			public var songName		:String;

			/// The track number; corresponds to the ID3 2.0 tag TRCK.
			public var track		:String;

			/// The year of the recording; corresponds to the ID3 2.0 tag TYER.
			public var year			:String;				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function ID3(data:Object = null) 
			{
				// accessible tags
				super(data);
				
				// ID3 tags
				this.album			= data.album;
				this.artist			= data.artist;
				this.comment		= data.comment;
				this.genre			= data.genre;
				this.songName		= data.songName;
				this.track			= data.track;
				this.year			= data.year;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			public function toString():String
			{
				return Objects.formatToString(this, 'ID3', 'artist songName album year genre comment')
			}
		
	}

}