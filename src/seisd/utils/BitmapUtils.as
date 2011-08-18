package seisd.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class BitmapUtils 
	{
		
		
		/**
		 * Converte um displayObject em Bitmap para otimizar o procesamento em muitos casos
		 * @param	displayObject
		 * @param	autoAdd Adiciona automaticamente o bitmap retornado ao displayObject.parent, caso ele exista
		 * @param	removeChilds Remove automaticamente todos os filhos do displayObject, caso possua
		 * @return
		 */
		public static function toBitmap(displayObject:DisplayObject, autoAdd:Boolean = true, removeChilds:Boolean = true):Bitmap
		{	
			//bitmap
			var bitmapData:BitmapData = new BitmapData(displayObject.width, displayObject.height, true, 0x00ffffff);
				bitmapData.draw(displayObject);
			var bitmap:Bitmap = new Bitmap(bitmapData, "auto", true);
				bitmap.x = displayObject.x;
				bitmap.y = displayObject.y;
			
			//autoadd
			if (autoAdd && displayObject.parent)
			{
				displayObject.parent.addChild(bitmap);
				displayObject.parent.swapChildren(bitmap, displayObject);
				displayObject.parent.removeChild(displayObject);
			}
			
			//removechilds
			if (removeChilds && displayObject is DisplayObjectContainer)
			{
				while (DisplayObjectContainer(displayObject).numChildren > 0) DisplayObjectContainer(displayObject).removeChildAt(0);
			}
			
			return bitmap;
		}
		
		
		
	}
	
}