package seisd.navigation
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import seisd.navigation.core.NavigationEvent;
	import seisd.navigation.Navigation;
	
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class NavigationSWFAddress 
	{
		
		
		public static var navList:Object = {}
		
		
		
		/**
		 * Navigation que trabalhar em conjunto com o SWFAddress. Utiliza a propriedade name dos itens para definir a url
		 * Esta classe não trabalha com / (barra) nem no início, nem no final
		 */
		public function NavigationSWFAddress()
		{
            throw new IllegalOperationError('NavigationSWFAddress cannot be instantiated.');
		}
		
		/**
		 * Adiciona uma uma navegação com um prefixo
		 * @param	navigation 
		 * @param	prefix Prefixo para a url. NÃO utilize barras no ínicio nem no fim
		 * Se for a raiz do site, deixe vazio. Exemplos: 'galeria/fotos', 'contato', '', 'home'
		 */
		public static function add(navigation:Navigation, prefix:String = ''):void 
		{
			navList[trimSlashes(prefix)] = navigation;
			
			navigation.addEventListener(NavigationEvent.DEACTIVATED, updateURL);
			navigation.addEventListener(NavigationEvent.ACTIVATED, updateURL);
			
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, readURL);
		}
		
		/**
		 * Lê a url e ativa as navegações de acordo com a leitura
		 */
		public static function readURL(e:Event = null):void 
		{
			var path:Array = SWFAddress.getPathNames();
			
			//por padrão, quando não há nada na url, ativa o primeiro item da primeira navegação, se houver
			if (path.length == 0 && navList[''])
			{
				navList[''].activateFirstOnList();
				return;
			}
			
			//ativa item a item de cada nível da navegação da esquerda para a direita
			for (var i:int = 0; i < path.length; i++) 
			{
				var prefix:String = path.slice(0, i).join('/');
				var nav:Navigation = navList[prefix];
				
				if (nav && nav.getItemByName(path[i]))
				{
					nav.activate(path[i]);
				}
				else
				{
					//TODO
					//erro 404, atualiza o url para cortar o que vier depois e manter a url coerente
					//há um problema aí com a inicialização do swfaddress que poderá cortar a url antes da navegação ser criada, melhorar
					//SWFAddress.setValue(prefix);
					return;
				}
			}
		}
		
		/**
		 * Atualiza a url de acordo com os itens ativos das navegações
		 * @param	e
		 */
		public static function updateURL(e:Event = null):void 
		{
			var url:String = '';
			
			switch (e.type) 
			{
				case NavigationEvent.ACTIVATED:
					while (
						navList[url] && 
						navList[url].current &&
						navList[url].current.name &&
						navList[url].current.name != ''
						)
					{
						url += '/' + navList[url].current.name;
						url = trimSlashes(url);
					}
				break;
				case NavigationEvent.DEACTIVATED:
					if (!navList[url].next)
					{
						while (
							navList[url] && 
							navList[url].current &&
							navList[url].current.name &&
							navList[url].current.name != '' &&
							navList[url].current != NavigationEvent(e).navigation.current
							)
						{
							url += '/' + navList[url].current.name;
							url = trimSlashes(url);
						}
					}
					else return;
				break;
			}
			
			SWFAddress.setValue(url);
		}
		
		
		
		
		
		
		
		/////////////////
		///// ÚTEIS /////
		/////////////////
		
		/// Elimina as barras iniciais e finais dos prefixos
		private static function trimSlashes(prefix:String):String 
		{
			while (prefix.substr(0, 1) == '/') prefix = prefix.substr(1);
			while (prefix.substr(-1, 1) == '/') prefix = prefix.substr(0, -1);
			
			return prefix;
		}
		
		
	}
	
}