package seisd.form
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import seisd.display.Global;
	import seisd.form.core.FormEvent;
	import seisd.form.core.FormItem;
	import seisd.form.core.FormItemType;
	
	
	
	
	/// @eventType	seisd.form.core.FormEvent.ERROR_VALIDATION
	[Event(name = "errorValidation", type = "seisd.form.core.FormEvent")] 
	
	/// @eventType	seisd.form.core.FormEvent.BEFORE_SEND_INIT
	[Event(name = "beforeSendInit", type = "seisd.form.core.FormEvent")] 
	
	/// @eventType	seisd.form.core.FormEvent.SEND_INIT
	[Event(name = "sendInit", type = "seisd.form.core.FormEvent")] 
	
	/// @eventType	seisd.form.core.FormEvent.SEND_ERROR
	[Event(name = "sendError", type = "seisd.form.core.FormEvent")] 
	
	/// @eventType	seisd.form.core.FormEvent.SEND_SUCCESS
	[Event(name = "sendSuccess", type = "seisd.form.core.FormEvent")] 
	
	
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class Form extends EventDispatcher
	{
		
		/// Lista de FormItem para manipular os textfields
		public var itemList:Vector.<FormItem>;
		
		/// Textfields que o usuário preencheu errado
		public var invalidatedList:Vector.<FormItem>;
		
		/// Informação que será enviada.
		/// Para personalizar, utilize dataToSend.minhaVariavel = 'Qualquer informação' e receba no php $_POST['minhaVariavel']
		public var varsToSend:URLVariables;
		
		/// Verifica se o formulário está sendo enviado e ainda não deu resposta
		public var sending:Boolean;
		
		/// Boolean para ficar dando trace nas mudança
		public var verbose:Boolean;
		
		/// Botão de enviar
		private var _submitButton:InteractiveObject;
		
		/// Url de destino ao enviar.
		private var urlPHP:String;
		
		
		
		
		
		/**
		 * Cria um formulário e permite as funções mais comuns
		 * @param	urlPHP Url de destino ao enviar.
		 * Atenção aos textfield.name pois serão os valores recebidos pelo $_POST do php. Ex: textfield.name = 'mensagem' resultará em $_POST['mensagem']
		 * O php deve retornar "success=mail()" para ele poder validar a resposta do servidor. Caso contrário, sempre interpretará como enviado com sucesso.
		 */
		public function Form(urlPHP:String)
		{
			this.urlPHP = urlPHP;
			
			itemList = new Vector.<FormItem>();
			varsToSend = new URLVariables();
			
			addEventListener(FormEvent.ERROR_VALIDATION, errorValidation);
			addEventListener(FormEvent.BEFORE_SEND_INIT, beforeSendInit);
			addEventListener(FormEvent.SEND_INIT, sendInit);
			addEventListener(FormEvent.SEND_ERROR, sendError);
			addEventListener(FormEvent.SEND_SUCCESS, sendSuccess);
			
			if (Global.stage) Global.stage.addEventListener(KeyboardEvent.KEY_UP, checkEnterPressed);
		}
		
		/**
		 * Adiciona um textfield ao form no formato de FormItem
		 * O texto padrão será pego pelo textfield.text. A quantidade de caracteres será pego pelo textfield.maxChars
		 * @param	input Textfield, Combox (evoluir mais...)
		 * @param	type Tipo do campo, consulte a classe FormItemType para detalhes. O valor null permite a inserção de qualquer caracter
		 * @param	required Obrigatoriedade do campo ao enviar
		 */
		public function add(input:*, type:String = null, required:Boolean = true):void
		{
			var field:TextField;
			switch (type) 
			{
				case FormItemType.COMBOBOX:
					trace('combobx ainda não suportado, favor acrescentar');
					return;
				break;
				case FormItemType.CHECKBOX:
					trace('checkbox ainda não suportado, favor acrescentar');
					return;
				break;
				default:
					field = input;
				break;
			}
			
			itemList.push(new FormItem(field, type, required));
			field.addEventListener(FocusEvent.FOCUS_IN, focusIn);
			field.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			
		}
		
		/**
		 * Habilita o tabindex dos fields
		 * @param	includeSubmitButton
		 */
		public function enableTabIndex(includeSubmitButton:Boolean = false):void 
		{
			for (var i:int = 0; i < itemList.length; i++) 
			{
				changeTabIndex(itemList[i].field, i);
			}
			if (includeSubmitButton) changeTabIndex(submitButton, itemList.length);
		}
		
		/**
		 * Desabilita o tabindex dos fields
		 */
		public function disableTabIndex():void 
		{
			for (var i:int = 0; i < itemList.length; i++) 
			{
				changeTabIndex(itemList[i].field, -1);
			}
			changeTabIndex(submitButton, -1);
		}
		
		/**
		 * Limpa todos os fields do form
		 */
		public function reset():void
		{
			for (var i:int = 0; i < itemList.length; i++) 
			{
				itemList[i].field.text = itemList[i].defaultText;
			}
		}
		
		
		
		
		
		
		
		
		
		
		//////////////////////////////////
		///// HANDLERS PARA OVERRIDE /////
		//////////////////////////////////
		
		/// Sobreponha. Handler quando houver erro de validação
		public function errorValidation(e:FormEvent):void { }
		
		/// Sobreponha. Handler quando iniciar o envio
		public function beforeSendInit(e:FormEvent):void { }
		
		/// Sobreponha. Handler quando iniciar o envio
		public function sendInit(e:FormEvent):void { }
		
		/// Sobreponha. Handler quando houver erro no envio
		public function sendError(e:FormEvent):void { }
		
		/// Sobreponha. Handler quando houver sucesso no envio
		public function sendSuccess(e:FormEvent):void { }
		
		
		
		
		
		
		
		
		
		//////////////////
		///// ENVIAR /////
		//////////////////
		
		/**
		 * Envia o formulário
		 * @param	e
		 */
		public function send(e:Event = null):void 
		{
			if (!sending) 
			{	
				if (!validate())
				{
					for (var j:int = 0; j < invalidatedList.length; j++) 
						if (verbose) trace('(FORM) Erro de validação em ' + invalidatedList[j].defaultText + ' (' + invalidatedList[j].field.name + ')');
						
					dispatchEvent(new FormEvent(FormEvent.ERROR_VALIDATION, invalidatedList));
				}
				else
				{
					dispatchEvent(new FormEvent(FormEvent.BEFORE_SEND_INIT));
					
					//php vars
					for (var i:int = 0; i < itemList.length; i++) 
					{
						if (itemList[i].field.text != itemList[i].defaultText)
							varsToSend[itemList[i].field.name] = itemList[i].field.text;
						else
							varsToSend[itemList[i].field.name] = '';
					}
					
					//php
					var urlMail:URLRequest = new URLRequest(urlPHP);
						urlMail.data = varsToSend;
						urlMail.method = URLRequestMethod.POST;
					
					//send
					var sendmail:URLLoader = new URLLoader();
						sendmail.addEventListener(IOErrorEvent.IO_ERROR, error);
						sendmail.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
						sendmail.addEventListener(Event.COMPLETE, success);
						sendmail.load(urlMail);	
					
					sending = true;
					
					if (verbose) trace('(FORM) Enviando...');
					dispatchEvent(new FormEvent(FormEvent.SEND_INIT));
				}
			}
		}
		
		private function error(e:ErrorEvent):void 
		{
			sending = false;
			
			if (verbose) trace('(FORM) Erro de envio: [' + e.type + '] ' + e);
			dispatchEvent(new FormEvent(FormEvent.SEND_ERROR, null, e));
		}
		
		private function success(e:Event):void 
		{
			sending = false;
			
			if (verbose) trace('(FORM) Sucesso ao enviar');
			
			var returned:URLVariables = new URLVariables(e.target.data);
			if (returned.success || !returned.hasOwnProperty('success')) 
			{
				dispatchEvent(new FormEvent(FormEvent.SEND_SUCCESS));
			}
			else
			{
				error(new ErrorEvent(ErrorEvent.ERROR, false, false, 'Erro na resposta da função mail() do php: ' + urlPHP));
			}
		}
		
		
		
		
		
		
		
		
		
		
		//////////////////////
		///// VALIDAÇÕES /////
		//////////////////////
		
		private function validate():Boolean 
		{
			invalidatedList = new Vector.<FormItem>();
			
			for (var i:int = 0; i < itemList.length; i++) 
			{
				if (!validateItem(itemList[i]))
				{
					invalidatedList.push(itemList[i]);
				}
			}
			
			return Boolean(invalidatedList.length == 0);
		}
		
		private function validateItem(item:FormItem):Boolean 
		{
			var ok:Boolean = true;
			
			if (item.required) 
			{
				ok = Boolean(item.field.text != item.defaultText && item.field.text != '')
				
				if (ok)
				{
					//expansível
					switch (item.type) 
					{
						case FormItemType.MAIL:
							var mailRegExp:RegExp = /^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$/;
							ok = mailRegExp.test(item.field.text);
						break;
					}
				}
			}
			
			return ok;
		}
		
		
		
		
		
		
		
		////////////////////
		///// PRIVADOS /////
		////////////////////
		
		private function changeTabIndex(object:InteractiveObject, value:int):void
		{
			object.tabIndex = value;
			object.tabEnabled = Boolean(value != -1);
		}
		
		private function focusIn(e:FocusEvent):void 
		{
			var fieldFocused:TextField = e.currentTarget as TextField;
			for (var i:int = 0; i < itemList.length; i++) 
			{
				if (fieldFocused == itemList[i].field && fieldFocused.text == itemList[i].defaultText) 
				{
					fieldFocused.text = '';
				}
			}
		}
		
		private function focusOut(e:FocusEvent):void 
		{
			var fieldFocused:TextField = e.currentTarget as TextField;
			for (var i:int = 0; i < itemList.length; i++) 
			{
				if (fieldFocused == itemList[i].field && fieldFocused.text == '') 
				{
					fieldFocused.text = itemList[i].defaultText;
				}
			}
		}
		
		private function checkEnterPressed(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.NUMPAD_ENTER)
			{
				var isMultine:Boolean = Boolean(Global.stage.focus is TextField && TextField(Global.stage.focus).multiline == true);
				if (!isMultine) send();
			}
		}
		
		
		
		
		
		///////////////////////////
		///// GETTER E SETTER /////
		///////////////////////////
		
		/// Botão de enviar
		public function get submitButton():InteractiveObject { return _submitButton; }
		public function set submitButton(value:InteractiveObject):void 
		{
			if (value) 
			{	
				_submitButton = value;
				_submitButton.addEventListener(MouseEvent.CLICK, send);
				
				if (_submitButton is Sprite) 
				{
					Sprite(_submitButton).buttonMode = true;
					Sprite(_submitButton).mouseChildren = false;
				}
			}
		}
		
		
	}
	
}






