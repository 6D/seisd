package seisd.utils 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class GraphicsUtils 
	{
		
		
		
		/**
		 * Retorna um Sprite com um retangulo desenhado
		 * @param	config { color:0x000000, alpha:1, x:0, y:0, width:100, height:100 }
		 */
		public static function newRect(config:Object = null):Sprite
		{
			var sprite:Sprite = new Sprite();
			GraphicsUtils.drawRect(sprite.graphics, config);
			
			return sprite;
		}
		
		/**
		 * Desenha um retangulo com o graphics dado
		 * @param	graphics
		 * @param	config { color:0x000000, alpha:1, x:0, y:0, width:100, height:100 }
		 */
		public static function drawRect(graphics:Graphics, config:Object = null):void
		{
			config ||= { }
			config.color  = (config.color != undefined)  ? config.color  : 0x000000;
			config.alpha  = (config.alpha != undefined)  ? config.alpha  : 1;
			config.x 	  = (config.x != undefined) 	 ? config.x 	 : 0;
			config.y 	  = (config.y != undefined) 	 ? config.y 	 : 0;
			config.width  = (config.width != undefined)  ? config.width  : 100;
			config.height = (config.height != undefined) ? config.height : 100;
			
			graphics.beginFill(config.color, config.alpha);
			graphics.drawRect(config.x, config.y, config.width, config.height);
			graphics.endFill();
		}
		
	}

}