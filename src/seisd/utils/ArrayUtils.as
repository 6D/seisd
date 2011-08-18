package seisd.utils 
{
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class ArrayUtils 
	{
		
		/**
		 * Embaralha os itens de um array
		 * @param	array
		 */
		public static function mix(array:Array):void
		{
			var arrayTemp:Array = [];
			var totalItens:uint = array.length;
			for (var i:int = 0; i < totalItens; i++) 
			{
				arrayTemp = arrayTemp.concat(array.splice(Math.floor(Math.random() * array.length), 1));
			}
			
			array = arrayTemp;
		}
		
		/**
		 * Remove um item do array
		 * @param	item
		 * @param	arrayOrVector
		 */
		public static function remove(item:*, arrayOrVector:*):void
		{
			if (ArrayUtils.has(item, arrayOrVector)) 
				arrayOrVector.splice(arrayOrVector.indexOf(item), 1);
		}
		
		/**
		 * Verifica a existencia de um item no array
		 * @param	item
		 * @param	arrayOrVector
		 * @return
		 */
		public static function has(item:*, arrayOrVector:*):Boolean
		{
			return (arrayOrVector.indexOf(item) != -1);
		}
		
		/**
		 * Adiciona um item no fim do array se não existir um item igual
		 * @param	item
		 * @param	arrayOrVector
		 * @return true se foi adicionado, false se não
		 */
		public static function addIfMissing(item:*, arrayOrVector:*):Boolean
		{
			var has:Boolean = ArrayUtils.has(item, arrayOrVector);
			
			if (!has)
				arrayOrVector.push(item);
			
			return !has;
		}
		
		
		
	}

}