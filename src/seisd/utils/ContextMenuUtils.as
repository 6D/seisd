package seisd.utils
{
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class ContextMenuUtils   
	{
		
		/**
		 * Cria um menu de contexto (botão direito) para um objeto com apenas os itens necessários e um link
		 * Normalmente usado para os créditos do site
		 * @param	object Normalmente a classe Main
		 * @param	label
		 * @param	url
		 */
		public static function init(object:InteractiveObject, label:String, url:String):void
		{
			var item:ContextMenuItem = new ContextMenuItem(label);
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void { navigateToURL(new URLRequest(url), '_blank') } );
			
			var contextMenu:ContextMenu = new ContextMenu();
				contextMenu.hideBuiltInItems();
				contextMenu.customItems.push(item);
			
			object.contextMenu = contextMenu;
		}
		
	}
	
}