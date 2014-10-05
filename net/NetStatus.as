package core.net {
	
	import core.net.NetStatus;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class NetStatus 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: strings
		
			// NetConnection
		
				public static const NetConnection_Call_BadVersion				:String = "NetConnection.Call.BadVersion";
				public static const NetConnection_Call_Failed					:String = "NetConnection.Call.Failed";
				public static const NetConnection_Call_Prohibited				:String = "NetConnection.Call.Prohibited";
				
				public static const NetConnection_Connect_AppShutdown			:String = "NetConnection.Connect.AppShutdown";
				public static const NetConnection_Connect_Closed				:String = "NetConnection.Connect.Closed";
				public static const NetConnection_Connect_Failed				:String = "NetConnection.Connect.Failed";
				public static const NetConnection_Connect_IdleTimeout			:String = "NetConnection.Connect.IdleTimeout";
				public static const NetConnection_Connect_InvalidApp			:String = "NetConnection.Connect.InvalidApp";
				public static const NetConnection_Connect_NetworkChange			:String = "NetConnection.Connect.NetworkChange";
				public static const NetConnection_Connect_Rejected				:String = "NetConnection.Connect.Rejected";
				public static const NetConnection_Connect_Success				:String = "NetConnection.Connect.Success";
				
			// NetGroup
			
				public static const NetGroup_Connect_Failed						:String = "NetGroup.Connect.Failed";
				public static const NetGroup_Connect_Rejected					:String = "NetGroup.Connect.Rejected";
				public static const NetGroup_Connect_Success					:String = "NetGroup.Connect.Success";
				public static const NetGroup_LocalCoverage_Notify				:String = "NetGroup.LocalCoverage.Notify";
				public static const NetGroup_MulticastStream_PublishNotify		:String = "NetGroup.MulticastStream.PublishNotify";
				public static const NetGroup_MulticastStream_UnpublishNotify	:String = "NetGroup.MulticastStream.UnpublishNotify";
				public static const NetGroup_Neighbor_Connect					:String = "NetGroup.Neighbor.Connect";
				public static const NetGroup_Neighbor_Disconnect				:String = "NetGroup.Neighbor.Disconnect";
				public static const NetGroup_Posting_Notify						:String = "NetGroup.Posting.Notify";
				public static const NetGroup_Replication_Fetch_Failed			:String = "NetGroup.Replication.Fetch.Failed";
				public static const NetGroup_Replication_Fetch_Result			:String = "NetGroup.Replication.Fetch.Result";
				public static const NetGroup_Replication_Fetch_SendNotify		:String = "NetGroup.Replication.Fetch.SendNotify";
				public static const NetGroup_Replication_Request				:String = "NetGroup.Replication.Request";
				public static const NetGroup_SendTo_Notify						:String = "NetGroup.SendTo.Notify";
				
			// NetStream
			
				public static const NetStream_Buffer_Empty						:String = "NetStream.Buffer.Empty";
				public static const NetStream_Buffer_Flush						:String = "NetStream.Buffer.Flush";
				public static const NetStream_Buffer_Full						:String = "NetStream.Buffer.Full";
				
				public static const NetStream_Connect_Closed					:String = "NetStream.Connect.Closed";
				public static const NetStream_Connect_Failed					:String = "NetStream.Connect.Failed";
				public static const NetStream_Connect_Rejected					:String = "NetStream.Connect.Rejected";
				public static const NetStream_Connect_Success					:String = "NetStream.Connect.Success";
				
				public static const NetStream_DRM_UpdateNeeded					:String = "NetStream.DRM.UpdateNeeded";
				public static const NetStream_Failed							:String = "NetStream.Failed";
				public static const NetStream_MulticastStream_Reset				:String = "NetStream.MulticastStream.Reset";
				public static const NetStream_Pause_Notify						:String = "NetStream.Pause.Notify";
				
				public static const NetStream_Play_Failed						:String = "NetStream.Play.Failed";
				public static const NetStream_Play_FileStructureInvalid			:String = "NetStream.Play.FileStructureInvalid";
				public static const NetStream_Play_InsufficientBW				:String = "NetStream.Play.InsufficientBW";
				public static const NetStream_Play_NoSupportedTrackFound		:String = "NetStream.Play.NoSupportedTrackFound";
				public static const NetStream_Play_PublishNotify				:String = "NetStream.Play.PublishNotify";
				public static const NetStream_Play_Reset						:String = "NetStream.Play.Reset";
				public static const NetStream_Play_Start						:String = "NetStream.Play.Start";
				public static const NetStream_Play_Stop							:String = "NetStream.Play.Stop";
				public static const NetStream_Play_StreamNotFound				:String = "NetStream.Play.StreamNotFound";
				public static const NetStream_Play_Transition					:String = "NetStream.Play.Transition";
				public static const NetStream_Play_UnpublishNotify				:String = "NetStream.Play.UnpublishNotify";
				
				public static const NetStream_Publish_BadName					:String = "NetStream.Publish.BadName";
				public static const NetStream_Publish_Idle						:String = "NetStream.Publish.Idle";
				public static const NetStream_Publish_Start						:String = "NetStream.Publish.Start";
				
				public static const NetStream_Record_AlreadyExists				:String = "NetStream.Record.AlreadyExists";
				public static const NetStream_Record_Failed						:String = "NetStream.Record.Failed";
				public static const NetStream_Record_NoAccess					:String = "NetStream.Record.NoAccess";
				public static const NetStream_Record_Start						:String = "NetStream.Record.Start";
				public static const NetStream_Record_Stop						:String = "NetStream.Record.Stop";
				
				public static const NetStream_SecondScreen_Start				:String = "NetStream.SecondScreen.Start";
				public static const NetStream_SecondScreen_Stop					:String = "NetStream.SecondScreen.Stop";
				
				public static const NetStream_Seek_Failed						:String = "NetStream.Seek.Failed";
				public static const NetStream_Seek_InvalidTime					:String = "NetStream.Seek.InvalidTime";
				public static const NetStream_Seek_Notify						:String = "NetStream.Seek.Notify";
				
				public static const NetStream_Step_Notify						:String = "NetStream.Step.Notify";
				public static const NetStream_Unpause_Notify					:String = "NetStream.Unpause.Notify";
				public static const NetStream_Unpublish_Success					:String = "NetStream.Unpublish.Success";
				public static const NetStream_Video_DimensionChange				:String = "NetStream.Video.DimensionChange";
				
			// SharedObject
			
				public static const SharedObject_BadPersistence					:String = "SharedObject.BadPersistence";
				public static const SharedObject_Flush_Failed					:String = "SharedObject.Flush.Failed";
				public static const SharedObject_Flush_Success					:String = "SharedObject.Flush.Success";
				public static const SharedObject_UriMismatch					:String = "SharedObject.UriMismatch";
								

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: types
		
			public static const TYPES	:Object =
			{
				"NetConnection.Call.BadVersion"				: ERROR,
				"NetConnection.Call.Failed"					: ERROR,
				"NetConnection.Call.Prohibited"				: ERROR,
				"NetConnection.Connect.AppShutdown"			: ERROR,
				"NetConnection.Connect.Closed"				: STATUS,
				"NetConnection.Connect.Failed"				: ERROR,
				"NetConnection.Connect.IdleTimeout"			: STATUS,
				"NetConnection.Connect.InvalidApp"			: ERROR,
				"NetConnection.Connect.NetworkChange"		: STATUS,
				"NetConnection.Connect.Rejected"			: ERROR,
				"NetConnection.Connect.Success"				: STATUS,
				"NetGroup.Connect.Failed"					: ERROR,
				"NetGroup.Connect.Rejected"					: ERROR,
				"NetGroup.Connect.Success"					: STATUS,
				"NetGroup.LocalCoverage.Notify"				: STATUS,
				"NetGroup.MulticastStream.PublishNotify"	: STATUS,
				"NetGroup.MulticastStream.UnpublishNotify"	: STATUS,
				"NetGroup.Neighbor.Connect"					: STATUS,
				"NetGroup.Neighbor.Disconnect"				: STATUS,
				"NetGroup.Posting.Notify"					: STATUS,
				"NetGroup.Replication.Fetch.Failed"			: STATUS,
				"NetGroup.Replication.Fetch.Result"			: STATUS,
				"NetGroup.Replication.Fetch.SendNotify"		: STATUS,
				"NetGroup.Replication.Request"				: STATUS,
				"NetGroup.SendTo.Notify"					: STATUS,
				"NetStream.Buffer.Empty"					: STATUS,
				"NetStream.Buffer.Flush"					: STATUS,
				"NetStream.Buffer.Full"						: STATUS,
				"NetStream.Connect.Closed"					: STATUS,
				"NetStream.Connect.Failed"					: ERROR,
				"NetStream.Connect.Rejected"				: ERROR,
				"NetStream.Connect.Success"					: STATUS,
				"NetStream.DRM.UpdateNeeded"				: STATUS,
				"NetStream.Failed"							: ERROR,
				"NetStream.MulticastStream.Reset"			: STATUS,
				"NetStream.Pause.Notify"					: STATUS,
				"NetStream.Play.Failed"						: ERROR,
				"NetStream.Play.FileStructureInvalid"		: ERROR,
				"NetStream.Play.InsufficientBW"				: WARNING,
				"NetStream.Play.NoSupportedTrackFound"		: STATUS,
				"NetStream.Play.PublishNotify"				: STATUS,
				"NetStream.Play.Reset"						: STATUS,
				"NetStream.Play.Start"						: STATUS,
				"NetStream.Play.Stop"						: STATUS,
				"NetStream.Play.StreamNotFound"				: ERROR,
				"NetStream.Play.Transition"					: STATUS,
				"NetStream.Play.UnpublishNotify"			: STATUS,
				"NetStream.Publish.BadName"					: ERROR,
				"NetStream.Publish.Idle"					: STATUS,
				"NetStream.Publish.Start"					: STATUS,
				"NetStream.Record.AlreadyExists"			: STATUS,
				"NetStream.Record.Failed"					: ERROR,
				"NetStream.Record.NoAccess"					: ERROR,
				"NetStream.Record.Start"					: STATUS,
				"NetStream.Record.Stop"						: STATUS,
				"NetStream.SecondScreen.Start"				: STATUS,
				"NetStream.SecondScreen.Stop"				: STATUS,
				"NetStream.Seek.Failed"						: ERROR,
				"NetStream.Seek.InvalidTime"				: ERROR,
				"NetStream.Seek.Notify"						: STATUS,
				"NetStream.Step.Notify"						: STATUS,
				"NetStream.Unpause.Notify"					: STATUS,
				"NetStream.Unpublish.Success"				: STATUS,
				"NetStream.Video.DimensionChange"			: STATUS,
				"SharedObject.BadPersistence"				: ERROR,
				"SharedObject.Flush.Failed"					: ERROR,
				"SharedObject.Flush.Success"				: STATUS,
				"SharedObject.UriMismatch"					: ERROR
			};


		// ---------------------------------------------------------------------------------------------------------------------
		// { region: type constants
		
			public static const ERROR	:String				= 'error';
			public static const STATUS	:String				= 'status';
			public static const WARNING	:String				= 'warning';
				
			public static function getType(value:String):String
			{
				return TYPES[value];
			}
		
			
	}

}
