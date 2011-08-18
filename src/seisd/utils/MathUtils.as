/**
 * Created by IntelliJ IDEA.
 * User: harrison
 * Date: 05/07/11
 * Time: 23:43
 * To change this template use File | Settings | File Templates.
 */
package seisd.utils
{
    public class MathUtils
    {
		
		/**
		 * Analiza o valor dado e se ele estiver fora do valor mínimo e máximo fornecido, ele assume o valor mais próximo
		 * @param	value
		 * @param	minValue
		 * @param	maxValue
		 * @return
		 */
        public static function between(value:Number, minValue:Number, maxValue:Number):Number
        {
            return Math.min(maxValue, Math.max(minValue, value));
        }
		
    }
}
