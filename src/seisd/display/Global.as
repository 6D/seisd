package seisd.display
{
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class Global 
	{
		
		/// Instancia estática do stage
		private static var _stage:Stage;
		
		
		/**
		 * Ela serve para o acesso universal(static) de variáveis
		 */
		public function Global()
		{
			
		}
		
		
		
		/**
		 * Inicializa o stage global e define o stage.align e o scaleMode
		 * @param	stage
		 * @param	align
		 * @param	scaleMode
		 */
		public static function init(stage:Stage, align:String = 'TL', scaleMode:String = 'noScale'):void
		{
			_stage = stage;
			_stage.align = align;
			_stage.scaleMode = scaleMode;
		}
		
		public static function get stage():Stage 
		{
			if (!_stage) trace('Inicialize primeiro a stage. Global.init(stage)');
			return _stage;
		}
		
		public static function set stage(value:Stage):void 
		{
			_stage = value;
		}
		
		
		
		
		
		
		
		
		
		///////////////////
		///// GETTERS /////
		///////////////////
		
		/// Largura do stage. Global.stage.stageWidth
		public static function get witdh():Number
		{
			return Global.stage.stageWidth;
		}
		
		/// Altura do stage. Global.stage.stageHeight
		public static function get height():Number
		{
			return Global.stage.stageHeight;
		}
		
		
		
		
		
		
		
		
		
		
		
	}
	
}