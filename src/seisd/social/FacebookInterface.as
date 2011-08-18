package seisd.social{
	
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookSession;
	import com.facebook.graph.net.FacebookRequest;
	import flash.events.EventDispatcher;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import com.adobe.serialization.json.JSON;
	import seisd.social.events.FacebookEvent;
	
	/**
	 * ...
	 * @author Nicolas Baptista
	 */	
	public class FacebookInterface extends EventDispatcher{

		private var fotoUsuario:Loader;
		private var _appId:String;
		private var _appURL:String;
		private var _appApiKey:String;
		private var _appSecret:String;
		private var _sessionKey:String;
		private var _objectId:String;
		private var _objectData:String;
		private var _perms:String;
		private var _myProfile:Object
		private var _myFriends:Object;
		private var _accessToken:Object;
		private const DEFAULT_PERMS:String  = "user_birthday, read_stream, publish_stream";
		private const PHOTO:String			= "http://www.espacofashion.com.br/inverno2011/_content/images/colecao/lookbook/thumb/foto_2.jpg"

		public function FacebookInterface(id:String, url:String, api_key:String, secret:String, autoInit:Boolean = false) 
		{ 
			_appId     = id;
			_appURL    = url;
			_appApiKey = api_key;
			_appSecret = secret;
			
			if (autoInit)
			{
				init();
			}
		};
		
		/**
		* Initializes the connection with facebook's API
		*/		
		public function init():void
		{
			Facebook.init(_appId, start); 
		}
		
		/**
		* Dispatch events about the connection with facebook's API
		*/				
		private function start(success:Object, fail:Object):void
		{	
			if (success)
			{
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_READY_LOGGED, false, false, success));
				_sessionKey = success.sessionKey;
				_accessToken = success.accessToken
				myProfile();
			}
			else
			{
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_READY_NOT_LOGGED, false, false, fail));
			}
		}
		
		/**
		* Login on facebook
		*/				
		public function login():void
		{
			if (_perms == "")
			{
				Facebook.login(logon,{perms:DEFAULT_PERMS});
			}
			else
			{
				Facebook.login(logon,{perms:_perms});
			}
		}
		
		/**
		* Dispatch events about login on facebook
		*/				
		private function logon(success:Object, fail:Object):void
		{			
			if (success)
			{
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_LOGGED_IN, false, false, success));
				myProfile();
			}
			else
			{
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_NOT_LOGGED_IN, false, false, fail));
			}			
		}
		
		/**
		* Retrieve current logged user's profile
		*/				
		private function myProfile(success:Object = null, fail:Object = null):void
		{
			if (success == null && fail == null)
			{
				Facebook.api( "/me/", myProfile, null, "GET" );			
			}
			else if (success)
			{
				_myProfile = success;
				myFriends();
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_PROFILE_READY, false, false, success));
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_COMPLETE));
			}
			else
			{
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_PROFILE_FAIL, false, false, fail));
			}
		}
		
		/**
		* Return current logged user's profile
		*/			
		public function getMyProfile():Object
		{
			return _myProfile;
		}
		
		/**
		* Retrieve friends from the current logged user
		*/
		private function myFriends(success:Object = null, fail:Object = null):void
		{
			if (success == null && fail == null)
			{
				Facebook.api( "/me/friends/", myFriends, null, "GET" );			
			}
			else if (success)
			{
				_myFriends = success;
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_FRIENDS_READY, false, false, success));
			}
			else
			{
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_FRIENDS_FAIL, false, false, fail));
			}
		}		
		
		/**
		* Return current logged user's friends
		*/			
		public function getMyFriends():Object
		{
			return _myFriends;
		}		
		
		/**
		* Logout from the current facebook session
		*/			
		public function logout():void
		{	
			Facebook.logout(unlog);
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// START OF POST ON THE WALL
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////								
		
		/**
		 * Post on the specified user's wall.
		 * @param	_to User's id who will receive the post
		 * @param	_message Post body
		 * @param	_picture Image's URL
		 * @param	_link
		 * @param	_name
		 * @param	_caption
		 * @param	_description
		 * @param	_source
		 */
		public function postOnTheWall(_to:String, _message:String, _picture:String = "", _link:String = "", _name:String = "", _caption:String = "", _description:String = "", _source:String = ""):void 
		{		
			Facebook.api("/"+_to+"/feed", postOnTheWallResponse, {message:_message, picture:PHOTO}, "POST")
		}
		
		private function postOnTheWallResponse(success:Object = null, fail:Object = null):void 
		{
			if (success)
			{
				//_objectId = success.id;				
				//getObjectData(_objectId);
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_WALL_POST_SUCCESS, false, false, success));
			}
			else
			{
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_WALL_POST_FAIL, false, false, fail));
			}
		}
		
		public function get objectId():String
		{ 
			return _objectId; 
		}		

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// END OF POST ON THE WALL
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////						
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// START OF OBJECT DATA
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////				
		
		/**
		 * Retrieves information about a Facebook's object.
		 * Dispatches FB_OBJECT_DATA_READY on successfull retrieve or FB_OBJECT_DATA_FAIL on failure.
		 * 
		 * @param	id ID of object you want to retrieve information about
		 */		
		public function getObjectData(id:String = ""):void
		{
			Facebook.api("/"+id, getObjectDataResponse);
		}
		
		/**
		 * Retrieves information about a Facebook's object.
		 * 
		 * How to retrieve data from JSON object:
		 * 		From: success.from.name
		 * 		To: success.to.data[0].name
		 * 
		 * @param	success
		 * @param	fail
		 */
		private function getObjectDataResponse(success:Object = null, fail:Object = null):void
		{
			if (success)
			{
				//Turn the JSON object into an string
				_objectData = JSON.encode(success)				
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_OBJECT_DATA_READY, false, false, success));
			}
			else
			{
				this.dispatchEvent(new FacebookEvent(FacebookEvent.FB_OBJECT_DATA_FAIL, false, false, fail));
			}			
		}
		
		public function get objectData():String 
		{ 
			return _objectData;
		}		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// END OF OBJECT DATA
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
		
	    protected function unlog(response:Object):void {}

		public function get appId():String { return _appId; }		
		
		public function get perms():String { return _perms; }
		
		public function set perms(value:String):void 
		{
			_perms = value;
		}
		
		public function get access_token():Object { return _accessToken; }
		
	}
	
}