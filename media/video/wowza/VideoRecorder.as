package core.media.video.wowza 
{
	import core.events.MediaEvent;
	import core.media.video.VideoRecorder;
	import core.utils.Strings;
	import flash.events.NetStatusEvent;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.net.NetConnection;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoRecorder extends core.media.video.VideoRecorder 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				
				
			// variables
				
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoRecorder(width:int=320, height:int=180, connection:NetConnection=null) 
			{
				super(width, height, connection);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			override public function _record(append:Boolean = false):Boolean
			{
				// variables
					_url = Strings.guid();
					
				// append
					if (append )
					{
						// TODO connect to server
						stream.publish(format + ':' + url, 'append');
					}
					else
					{
						// setup stream
							parent.setupStream();
							
						// add h264 settings
							if (format == 'mp4')
							{
								var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
								h264Settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_3_1);
								stream.videoStreamSettings = h264Settings;
							}

						// publish the stream by name
							stream.publish(format + ':' + url, append ? 'append' : 'record'); // can also have "live" and "default", but "record" has NetStream events we can bind to
							
						// add custom metadata to the header of the .flv file
							var metaData:Object	= 
							{
								description : 'Recorded using WebcamRecording example.'
							};
							stream.send('@setDataFrame', 'onMetaData', metaData);
						
						// TODO implement proper handlers for permissions: http://help.adobe.com/en_US/as3/dev/WSfffb011ac560372f3fa68e8912e3ab6b8cb-8000.html#WS5b3ccc516d4fbf351e63e3d118a9b90204-7d37
						
						// attach the camera and microphone to the server
							stream.attachCamera(webcam.camera);
							//stream.attachAudio(microphone);
					}
					
				// return
					return true;
			}
			
			public function _pause():void 
			{
				stream.publish('null');
			}

			public function _stop():void
			{
				// variables
					var intervalId:Number;
				
				// this function gets called every 250 ms to monitor the progress of flushing the video buffer.
				// Once the video buffer is empty we close publishing stream
					function onBufferFlush():void
					{
						log('Waiting for buffer to empty...');
						dispatchEvent(new MediaEvent(MediaEvent.PROCESSING));

						if (stream.bufferLength == 0)
						{
							log('Buffer emptied!');
							clearInterval(intervalId);
							onRecordComplete();
						}
					}

				// stop streaming video and audio to the publishing NetStream object
					stream.attachCamera(null);
					
				// disabled audio so that mp4 will record
					stream.attachAudio(null); 

				// After stopping the publishing we need to check if there is video content in the NetStream buffer. 
				// If there is data we are going to monitor the video upload progress by calling flushVideoBuffer every 250ms.
					stream.bufferLength > 0
						? intervalId = setInterval(onBufferFlush, 250)
						: onRecordComplete();		
			}
							
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function _onRecordComplete():void
			{
				// debug
					log('Finished recording!')
					
				// after we have hit "Stop" recording, and after the buffered video data has been
				// sent to the Wowza Media Server, close the publishing stream
					stream.publish('null');
					stream.close();
					
				// event
					dispatchEvent(new MediaEvent(MediaEvent.PROCESSED));
					dispatchEvent(new MediaEvent(MediaEvent.FINISHED));

			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		

					
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
		
	}

}