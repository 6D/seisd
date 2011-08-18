package seisd.form
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.text.TextField;
	import seisd.form.core.FormEvent;
	import seisd.form.core.FormItemType;
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class FormContact extends Form 
	{
		
		private var status:TextField;
		
		/**
		 * Formulário básico de email do tipo "envie-nos uma mensagem"
		 * Atenção ao container pois ele deve possuir filhos com nomes predefinidos
		 * @param	formContainer O container deve possuir filhos com os seguintes nomes: sender, mail, subject, message, submit e status(opcional)
		 * @param	urlPHP
		 */
		public function FormContact(formContainer:DisplayObjectContainer, urlPHP:String)
		{
			super(urlPHP);
			
			submitButton = InteractiveObject(formContainer.getChildByName('submit'));
			
			add(TextField(formContainer.getChildByName('sender')), FormItemType.ALPHABETIC);
			add(TextField(formContainer.getChildByName('mail')), FormItemType.MAIL);
			add(TextField(formContainer.getChildByName('subject')));
			add(TextField(formContainer.getChildByName('message')));
			
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