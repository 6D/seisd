package seisd.form
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.text.TextField;
	import seisd.form.core.FormItemType;
	import seisd.form.core.FormEvent;
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class FormShare extends Form
	{
		
		private var status:TextField;
		
		/**
		 * Formulário básico de email do tipo "indique a um amigo"
		 * Atenção ao container pois ele deve possuir filhos com nomes predefinidos
		 * @param	formContainer O container deve possuir filhos com os seguintes nomes: nameFrom, mailFrom, nameTo, mailTo, submit e status(opcional)
		 * @param	urlPHP
		 */
		public function FormShare(formContainer:DisplayObjectContainer, urlPHP:String)
		{
			super(urlPHP);
			
			submitButton = InteractiveObject(formContainer.getChildByName('submit'));
			
			add(TextField(formContainer.getChildByName('nameFrom')), FormItemType.ALPHABETIC);
			add(TextField(formContainer.getChildByName('mailFrom')), FormItemType.MAIL);
			add(TextField(formContainer.getChildByName('nameTo')), FormItemType.ALPHABETIC);
			add(TextField(formContainer.getChildByName('mailTo')), FormItemType.MAIL);
			
			enableTabIndex(true);
			
			status = TextField(formContainer.getChildByName('status'));
		}
		
		
		
		override public function errorValidation(e:FormEvent):void 
		{
			if (status) status.text = 'Por favor, preencha os campos corretamente';
		}
		
		override public function sendInit(e:FormEvent):void 
		{
			if (status) status.text = 'Enviando e-mail...';
		}
		
		override public function sendError(e:FormEvent):void 
		{
			if (status) status.text = 'Erro no servidor. Por favor, tente novamente.';
		}
		
		override public function sendSuccess(e:FormEvent):void 
		{
			if (status) status.text = 'E-mail enviado com sucesso.';
		}
		
		
		
	}
	
}