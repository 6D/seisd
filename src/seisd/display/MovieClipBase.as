package seisd.display
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vamoss, Harrison
	 */
	public dynamic class MovieClipBase extends MovieClip
	{
		
		private var _ww:Number;
		private var _hh:Number;
		private var _align:Align;
		
		
		
		/**
		 * MovieClip padrão. Possui algumas pequenas e comuns funcionalidades 
		 */
		public function MovieClipBase()
		{	
			addEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		/// Atalho para ao ser adicionado no stage
		protected function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			if (stage) stage.addEventListener(Event.RESIZE, onResize, false, -1, true);
		}
		
		/// Atalho para ao ser remnovido no stage
		protected function removed(e:Event):void 
		{
			if (stage) stage.removeEventListener(Event.RESIZE, onResize);
		}
		
		/// Atalho para redimensionamento
		protected function onResize(e:Event = null):void 
		{
			
		}
		
		
		
		
		
		
		
		/**
		 * Define o tamanho final do movieclip, variáveis úteis para problemas como espera de carregamento de imagens e itens mascarados
		 * @param	w
		 * @param	h
		 * @param	drawBoundingBox Se precisar verificar os valores, defina como true que desenhará uma borda vermelha baseado no ww e hh
		 */
		public function setSize(w:Number, h:Number, drawBoundingBox:Boolean = false):void
		{
			_ww = w ? w : 0;
			_hh = h ? h : 0;
			
			if (drawBoundingBox)
			{
				graphics.clear();
				graphics.lineStyle(1, 0xFF0000);
				graphics.drawRect(0, 0, _ww, _hh);
			}
			
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		/// Largura fictícia do objeto
		public function get ww():Number { return _ww; }
		public function set ww(value:Number):void 
		{
			setSize(value, _hh);
		}
		
		/// Altura fictícia do objeto
		public function get hh():Number { return _hh; }
		public function set hh(value:Number):void 
		{
			setSize(_ww, value);
		}
		
		/// objeto do tipo Align usado para alinhar o MovieClipBase
		public function get align():Align
		{
			if (!_align) _align = AutoAlign.getAlign(this) || AutoAlign.add(this, parent);
			return _align;
		}
		
		
		
	}
	
}