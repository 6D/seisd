package seisd.form.core
{
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class FormItemType
	{
		
		public static const ALPHABETIC:String = 'alphabetic';
		public static const ALPHABETIC_UPPERCASE:String = 'alphabeticUppercase';
		public static const ALPHABETIC_LOWERCASE:String = 'alphabeticLowercase';
		public static const ALPHANUMERIC:String = 'alphanumeric';
		public static const NUMERIC:String = 'numeric';
		public static const MAIL:String = 'mail';
		
		public static const COMBOBOX:String = "combobox";
		
		public static const CHECKBOX:String = "checkbox";
		
		
		
		public static function getRestrictString(type:String):String 
		{
			switch (type) 
			{
				case FormItemType.ALPHABETIC:
					return 'A-Z a-z áéíóúâêôãõàüçÁÉÍÓÚÂÊÔÃÕÀÜÇ';
				break;
				case FormItemType.ALPHABETIC_UPPERCASE:
					return 'A-Z ÁÉÍÓÚÂÊÔÃÕÀÜÇ';
				break;
				case FormItemType.ALPHABETIC_LOWERCASE:
					return 'a-z áéíóúâêôãõàüç';
				break;
				case FormItemType.ALPHANUMERIC:
					return '0-9 A-Z a-z áéíóúâêôãõàüçÁÉÍÓÚÂÊÔÃÕÀÜÇ ;:()*&%$#@!?{}[],.\\-/';
				break;
				case FormItemType.MAIL:
					return 'A-Z a-z 0-9 _.@\\-';
				break;
				case FormItemType.NUMERIC:
					return '0-9 _.\\-/\u005C ';
				break;
				default:
					return null;
				break;
			}
		}
		
	}
	
}