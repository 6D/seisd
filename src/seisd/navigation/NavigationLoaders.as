package seisd.navigation 
{
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import seisd.navigation.core.NavigationEvent;
	import seisd.navigation.Navigation;
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class NavigationLoaders extends Navigation 
	{
		
		
		/**
		 * LoaderMax interno
		 */
		public var loaderMax:LoaderMax;
		
		/**
		 * Um navigation com seus itens baseado em LoaderCore (ImageLoader, MP3Loader...)
		 * @param	config
		 */
		public function NavigationLoaders() 
		{
			super();
			loaderMax = new LoaderMax();
		}
		
		/**
		 * Todo item deve ser um LoaderCore (ImageLoader, MP3Loader...) que será automaticamente adicionado no loadermax interno
		 * Ele é automaticamente priorizado no queue do loading se ficar ativo.
		 * @param	item
		 */
		override public function add(item:*):void 
		{	
			super.add(item);
			
			item.addEventListener(NavigationEvent.ACTIVATED, prioritizeMe);
			loaderMax.append(LoaderCore(item));
		}
		
		/// Privado. Prioriza um item caso ela se torne ativo.
		private function prioritizeMe(e:NavigationEvent):void 
		{
			if (LoaderCore(current).status != LoaderStatus.COMPLETED) current.prioritize();
		}
		
		/**
		 * Elimina o loaderMax interno e deixa o navigation livre para o garbage collector
		 * @param	flushContent Se for true, remove também o conteúdo carregado
		 */
		public function destroy(flushContent:Boolean = false):void
		{
			loaderMax.dispose(flushContent);
			loaderMax = null;
		}
		
		
		
		
		
		
		
		
		///////////////////////////////
		///// ATALHOS DOS LOADERS /////
		///////////////////////////////
		
		/**
		 * Inicia o carregamento dos itens.
		 * loaderMax.load();
		 */
		public function load():void 
		{
			loaderMax.load();
		}
		
		/**
		 * Pausa o carregamento dos itens.
		 * loaderMax.pause();
		 */
		public function pause():void 
		{
			loaderMax.pause();
		}
		
		/**
		 * Retoma o carregamento dos itens.
		 * loaderMax.resume();
		 */
		public function resume():void 
		{
			loaderMax.resume();
		}
		
		/**
		 * Cancela o carregamento dos itens não carregados até o momento
		 * loaderMax.pause();
		 */
		public function cancel():void 
		{
			loaderMax.cancel();
		}
		
		/**
		 * Porcentagem do carregamento (0-1)
		 * LoaderCore(item || loaderMax).progress
		 * @param	item Um item do navigation. Se deixar vazio, utiliza o loaderMax interno
		 * @return
		 */
		public function progress(item:* = null):Number 
		{
			return LoaderCore(item || loaderMax).progress;
		}
		
		
		
		
		
		/////////////////////////
		///// VERIFICADORES /////
		/////////////////////////
		
		/**
		 * Verifica se o status do item é LOADING
		 * LoaderCore(item || loaderMax).status == LoaderStatus.LOADING
		 * @param	item Um item do navigation. Se deixar vazio, utiliza o loaderMax interno
		 * @return
		 */
		public function isLoading(item:* = null):Boolean 
		{
			return (LoaderCore(item || loaderMax).status == LoaderStatus.LOADING);
		}
		
		/**
		 * Verifica se o status do item é COMPLETED
		 * LoaderCore(item || loaderMax).status == LoaderStatus.COMPLETED
		 * @param	item Um item do navigation. Se deixar vazio, utiliza o loaderMax interno
		 * @return
		 */
		public function isCompleted(item:* = null):Boolean 
		{
			return (LoaderCore(item || loaderMax).status == LoaderStatus.COMPLETED);
		}
		
		/**
		 * Verifica se o status do item é FAILED
		 * LoaderCore(item || loaderMax).status == LoaderStatus.FAILED
		 * @param	item Um item do navigation. Se deixar vazio, utiliza o loaderMax interno
		 * @return
		 */
		public function isFailed(item:* = null):Boolean 
		{
			return (LoaderCore(item || loaderMax).status == LoaderStatus.FAILED);
		}
		
		/**
		 * Verifica se o status do item é PAUSED
		 * LoaderCore(item || loaderMax).status == LoaderStatus.PAUSED
		 * @param	item Um item do navigation. Se deixar vazio, utiliza o loaderMax interno
		 * @return
		 */
		public function isPaused(item:* = null):Boolean 
		{
			return (LoaderCore(item || loaderMax).status == LoaderStatus.PAUSED);
		}
		
		
	}

} 