package seisd.utils 
{
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class TextFieldUtils 
	{
		
		/**
		 * Cria um textfield 
		 * @param	config { autoSize:'left', selectable:false } e todos os default do TextField e TextFormat
		 * @return
		 */
		public static function createText(config:Object):TextField
		{
			var format:TextFormat = new TextFormat();
			for (var propFormat:String in config)
				if (format.hasOwnProperty(propFormat)) format[propFormat] = config[propFormat];
			
			var field:TextField = new TextField();
				field.defaultTextFormat = format;
				field.autoSize = TextFieldAutoSize.LEFT;
				field.selectable = false;
			
			for (var propField:String in config)
				if (field.hasOwnProperty(propField)) field[propField] = config[propField];
			
			return field;
		}
		
		
		
	}

}