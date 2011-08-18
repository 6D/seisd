package seisd.navigation.core
{
	import flash.events.Event;
	import seisd.navigation.Navigation;
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class NavigationEvent extends Event
	{
		
		public static const ACTIVATED:String = 'activated';
		public static const DEACTIVATED:String = 'deactivated';
		public static const ERROR_404:String = 'error404';
		
		
		
		public var navigation:Navigation;
		
		
		public function NavigationEvent(type:String, navigation:Navigation) 
		{
			super(type, false, false);
			this.navigation = navigation;
		}
		
		public override function clone():Event
		{
			return new NavigationEvent(type, navigation);
		}
		
		
		
	}

}