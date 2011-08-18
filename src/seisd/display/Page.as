package seisd.display
{
	
	import flash.events.Event;
	import seisd.navigation.core.NavigationEvent;
	import seisd.navigation.Navigation;
	
	
	/// @eventType	seisd.navigation.core.NavigationEvent.DEACTIVATED
	[Event(name = "deactive", type = "seisd.navigation.core.NavigationEvent")] 
	
	/// @eventType	seisd.navigation.core.NavigationEvent.ACTIVATED
	[Event(name = "active", type = "seisd.navigation.core.NavigationEvent")] 
	
	/// @eventType	seisd.navigation.core.NavigationEvent.ERROR_404
	[Event(name = "error404", type = "seisd.navigation.core.NavigationEvent")] 
	
	
	/**
	 * ...
	 * @author Vamoss, Harrison
	 */
	public class Page extends MovieClipBase
	{
		
		public var navPages:Navigation;
		
		
		/**
		 * Página base.
		 * Ao criar um novo projeto, crie ClientPage extends Page e utilize o overide activate e overide deactivate
		 */
		public function Page()
		{	
			addEventListener(NavigationEvent.ACTIVATED, activate);
			addEventListener(NavigationEvent.DEACTIVATED, deactivate);
		}
		
		/**
		 * Método chamado quando a página ativar
		 * @param	e
		 */
		protected function activate(e:NavigationEvent):void 
		{
			if (!navPages) navPages = e.navigation;
		}
		
		/**
		 * Método chamado quando a página desativar
		 * @param	e
		 */
		protected function deactivate(e:NavigationEvent):void 
		{
			//se quiser aplicar delay (ex: 2 segundos)
			//navigation.delay = 2
		}
	}
	
}