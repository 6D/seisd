package seisd.form.core
{
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class FormItem 
	{
		public var field:TextField;
		public var defaultText:String;
		public var type:String;
		public var required:Boolean;
		
		public function FormItem(field:TextField, type:String = null, required:Boolean = true)
		{
			this.field = field;
			this.defaultText = field.text;
			this.type = type;
			this.required = required;
			
			field.restrict = FormItemType.getRestrictString(type);
		}
	} 
	
}