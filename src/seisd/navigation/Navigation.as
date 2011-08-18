package seisd.navigation
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import seisd.navigation.core.NavigationEvent;
	import seisd.utils.ArrayUtils;
	
	
	/// @eventType	seisd.navigation.core.NavigationEvent.DEACTIVATED
	[Event(name = "deactivated", type = "seisd.navigation.core.NavigationEvent")] 
	
	/// @eventType	seisd.navigation.core.NavigationEvent.ACTIVATED
	[Event(name = "activated", type = "seisd.navigation.core.NavigationEvent")] 
	
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class Navigation extends EventDispatcher
	{
		
		/// Lista de itens envolvidos com esta navegação
        public var list:Array = [];
		
		/// Item ativo
        public var current:*;
		
		/// Próximo item a ser ativo
		public var next:*;
		
		/// Item ativado anteriormente ao current;
		public var previous:*;
		
		/// Tempo (em segundos) de espera o evento NavigationEvent.DEACTIVATED e próximo NavigationEvent.ACTIVATED. Após executado, o delay volta a zero
		public var delay:Number = 0;
		
		/// Boolean para impedir que haja novas ativações. Só há novas ativações se esta variável for false. Se estiver no delay, há ativação do next
		public var locked:Boolean;
		
		/// Boolean para ficar dando trace nas mudança
		public var verbose:Boolean;
		
		
		/**
		 * Cria uma navegação, ou qualquer lista de itens que possuem apenas um item ativo por vez.
		 */
		public function Navigation()
        {
			addEventListener(NavigationEvent.ACTIVATED, propagateEvent);
			addEventListener(NavigationEvent.DEACTIVATED, propagateEvent);
        }
		
		/**
		 * Adiciona um item à navegação
		 * @param	eventDispatcher Um EventDispatcher para poder disparar os eventos de NavigationEvent.DEACTIVATED e NavigationEvent.ACTIVATED
		 */
		public function add(item:*):void
        {
			verboseEvent('ADD', item);
			list.push(item);
		}
		
		/**
		 * Remove um item da navegação
		 * @param	item
		 */
		public function remove(item:*):void
        {
			verboseEvent('REMOVE', item);
			ArrayUtils.remove(item, list);
		}
		
		
		
		
		
		
		
		
		
		
		/////////////////////
		///// ATIVAÇÕES /////
		/////////////////////
		
		/**
		 * Ativa um item
		 * @param	nameOrItem O name (string) do item ou o próprio item
		 * @return Retorna true se houve a ativação
		 */
		public function activate(nameOrItem:*):Boolean
        {
			if (nameOrItem is String) 
				return changeTo(getItemByName(nameOrItem));
			else
				return changeTo(nameOrItem);
        }
		
		/**
		 * Desativa o item ativo, se houver.
		 * @return Retorna true se havia um item ativo e desativou
		 */
		public function deactivate():Boolean
		{
			return changeTo(null);
		}
		
		/**
		 * Ativa o primeiro item que foi adicionado na navegação
		 * @return true se houve a ativação
		 */
		public function activateFirstOnList():Boolean
		{
			return changeTo(list[0]);
		}
		
		/**
		 * Ativa o próximo item da list. Se não houver nenhum ativado, ativa o primeiro
		 * @param	looping true para ir do último ao primeiro item fechando o clico de itens, bom para galerias de fotos
		 * @return Retorna true se houve a ativação, false se o item a ser ativado é o que já está ativado ou não existe
		 */
		public function activateNextOnList(looping:Boolean = true):Boolean
		{	
			if (current)
			{
				var next:uint = list.indexOf(current) + 1;
				if (next > list.length - 1) 
				{
					if (looping) 
						return changeTo(list[0]);
					else
						return false;
				}
				else
				{
					return changeTo(list[next]);
				}
			}
			else
			{
				return changeTo(list[0]);
			}
		}
		
		/**
		 * Ativa o item anterior da list. Se não houver nenhum ativado, ativa o último se o looping for true
		 * @param	looping true para ir do último ao primeiro item fechando o ciclo de itens, bom para galerias de fotos
		 * @return Retorna true se houve a ativação, false se o item a ser ativado é o que já está ativado ou não existe
		 */
		public function activatePreviousOnList(looping:Boolean = true):Boolean
		{
			if (current)
			{
				if (current == list[0])
				{
					if (looping)
						return changeTo(list[list.length - 1]);	
					else 
						return false;
				}
				else
				{
					var previous:uint = list.indexOf(current) - 1;
					return changeTo(list[previous]);
				}
			}
			else
			{
				if (looping)
					return changeTo(list[list.length - 1]);
				else
					return false;
			}
		}
		
		/**
		 * Ativa um item aleatório da list diferente do atual.
		 * @return true se houve a ativação
		 */
		public function activateRandomOnList():Boolean 
		{
			var randomIndex:uint;
			
			do { randomIndex = Math.floor(Math.random() * list.length);	}
			while (randomIndex == current) 
			
			return changeTo(list[randomIndex]);
		}
		
		
		
		
		
		
		
		//////////////////////////
		///// ATIVAÇÕES CORE /////
		//////////////////////////
		
		/// @private Função chave da navegação. Troca um item respeitando os critérios da navegação. 
		private function changeTo(item:*):Boolean
		{
			if (locked) return false;
			
			if (item == null) 
			{
				deactivateItem(current);
				current = null;
				return true;
			}
			else if (has(item) && item != current)
			{
				if (next) 
				{
					verboseEvent('NEXT', item);
					next = item;
				}
				else
				{
					if (current) 
					{
						next = item;
						deactivateItem(current);
						
						if (delay) 
						{
							var timerToNext:Timer = new Timer(delay * 1000, 1);
								timerToNext.addEventListener(TimerEvent.TIMER_COMPLETE, activateWaitingItem);
								timerToNext.start();
						}
						else
						{
							activateItem(item);
						}
					}
					else
					{
						activateItem(item);
					}
				}
				
				return true;
			}
			else
			{
				return false;
			}
			
		}
		
		/// @private Desativa um item.
		private function deactivateItem(item:*):Boolean
		{
			if (has(item))
			{
				verboseEvent('DEACTIVATED', item);
				
				dispatchEvent(new NavigationEvent(NavigationEvent.DEACTIVATED, this));
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/// @private Função de resposta após passar o delay da troca de item
		private function activateWaitingItem(e:TimerEvent):void 
		{
			delay = 0;
			activateItem(next);
		}
		
		/// @private Ativa um item.
		private function activateItem(item:*):Boolean
		{
			if (has(item))
			{
				verboseEvent('ACTIVATED', item);
				
				next = null;
				previous = current;
				current = item;
				
				dispatchEvent(new NavigationEvent(NavigationEvent.ACTIVATED, this));
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		
		
		
		
		
		
		
		
		///////////////////////////////
		///// OUTRAS FUNÇÕES CORE /////
		///////////////////////////////
		
		/// @private Propaga o evento da navegação para o item em questão criando o flow da navegação.
		private function propagateEvent(e:NavigationEvent):void 
		{
			if (current is EventDispatcher) EventDispatcher(current).dispatchEvent(e);
		}
		
		/// @private Dá trace em um evento se o verbose estiver ativo
		private function verboseEvent(event:String, item:*):void 
		{	
			if (verbose) trace('[navigation] ' + event + ': ' + ((item.name) ? item.name + ' ' : '') + item);
		}
		
		
		
		
		
		
		
		
		
		
		/////////////////
		///// ÚTEIS /////
		/////////////////
		
		/// Verifica se existe o item
		public function has(item:*):Boolean
		{
			return ArrayUtils.has(item, list);
		}
		
		/// Retorna um item da list baseado no name dele ou null se o item não existir na list
		public function getItemByName(name:String):*
		{
			for each (var item:* in list) 
				if (item.name && item.name == name) return item;
			
			return null;
		}
		
		/// Retorna o index do item ou null se ele não existir
		public function indexOf(item:*):uint
		{
			return has(item) ? list.indexOf(item) : null;
		}
		
		/// Retorna o index do current
		public function get currentIndex():uint
		{
			return indexOf(current);
		}
		
		
		
	}
	
}