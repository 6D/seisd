package seisd.social.events
{
	import flash.events.Event;
	
	public class FacebookEvent extends Event
	{
		/**
		* App connected and user logged in
		*/			
		public static const FB_READY_LOGGED:String = "fbReadyLogged";
		
		/**
		* App connect but not logged in
		*/			
		public static const FB_READY_NOT_LOGGED:String = "fbReadyNotLogged";
		
		/**
		* User logged in
		*/			
		public static const FB_LOGGED_IN:String = "fbLoggedIn";
		
		/**
		* Fail in login
		*/			
		public static const FB_NOT_LOGGED_IN:String = "fbNotLoggedIn";
		
		/**
		* Logged user's profile loaded
		*/			
		public static const FB_PROFILE_READY:String = "fbProfileReady";
		
		/**
		* Fail while loading logged user's profile
		*/			
		public static const FB_PROFILE_FAIL:String = "fbProfileFail";
		
		/**
		* Friends names and id's from the current logged user
		*/			
		public static const FB_FRIENDS_READY:String = "fbFriendsReady";
		
		/**
		* 
		*/			
		public static const FB_FRIENDS_FAIL:String = "fbFriendsFail";		
		
		/**
		* Dispatched on wall post 
		*/			
		public static const FB_WALL_POST_SUCCESS:String = "fbWallPostSuccess";
		
		/**
		* Dispatched if a wall post fail.
		*/			
		public static const FB_WALL_POST_FAIL:String = "fbWallPostFail";				
		
		/**
		* Dispatched after user request information about a Facebook's object. Automatically dispatched after FB_WALL_POST_SUCCESS.
		*/			
		public static const FB_OBJECT_DATA_READY:String = "fbObjectDataReady";
		
		/**
		* Dispatched if the request about a Facebook's object fail.
		*/			
		public static const FB_OBJECT_DATA_FAIL:String = "fbObjectDataFail";			

		/**
		* All set
		*/			
		public static const FB_COMPLETE:String = "fbComplete";		
		
		protected var _responseData:Object;		
		

		public function FacebookEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, responseData:Object = null)
		{
			super(type, bubbles, cancelable);
			_responseData = responseData;
		}
		
		public function get responseData():Object
		{ 
			return _responseData; 
		}
		
		public function set responseData(value:Object):void 
		{
			_responseData = value;
		}

        override public function toString():String
        {
            return formatToString( "FacebookEvent", "type", "bubbles", "cancelable", "responseData" );
        }		
		

	}
}