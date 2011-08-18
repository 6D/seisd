package seisd.string
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class Translator 
	{
		
		private static var _fieldList:Array = [];
		private static var _dictionary:XML;
		private static var _language:String;
		
		
		
		
		
		/**
		 * Procura por textfields e tenta traduzí-los
		 * @param	container Container de TextFields, entre outros
		 * @param	deepSearch Procurar também dentro dos objetos filhos
		 */
		public static function translateAll(container:DisplayObjectContainer, deepSearch:Boolean = true):void
		{
			var displayObject:DisplayObject;
			for (var i:int = 0; i < container.numChildren; i++) 
			{
				displayObject = container.getChildAt(i);
				
				if (displayObject is TextField)
					Translator.translateTextfield(displayObject as TextField);
				
				if (deepSearch && displayObject is DisplayObjectContainer)
					Translator.translateAll(displayObject as DisplayObjectContainer);
			}
		}
		
		/**
		 * Tenta traduzir um textfield. Se conseguir, anexa o textfield ao Translator
		 * @param	field
		 */
		public static function translateTextfield(field:TextField):void 
		{
			//expressão regular retirada de: StringUtils.trim() by Ryan Matsikas (www.gskinner.com)
			var id:String = field.text.replace(/^\s+|\s+$/g, '');
			
			if (hasTranslation(id))
			{
				addField(field, id);
				field.text = Translator.translate(id);
			}
		}
		
		/**
		 * Traduz um texto baseado no seu id
		 * @param	id
		 * @return
		 */
		public static function translate(id:String):String
		{
			return _dictionary.child(id).child(_language) || id;
		}
		
		/**
		 * Verifica se existe um nó no dicionário com este id
		 * @param	id
		 * @return
		 */
		public static function hasTranslation(id:String):Boolean
		{
			return Boolean(String(_dictionary.child(id).child(_language)));
		}
		
		
		
		
		
		
		
		
		
		
		/**
		 * Adiciona um textfield ao Translator para quando houver troca de lingua, esse textfield atualizar automaticamente
		 * @param	field
		 * @param	id Nome do node do dicionário
		 */
		public static function addField(field:TextField, id:String = null):void 
		{
			id = id ? id : field.text;
			
			if (hasTranslation(id))
				_fieldList.push(new FieldInfo(field, id));
		}
		
		/**
		 * Atualiza todos os textfields já anexados ao Translator
		 */
		public static function update():void 
		{
			for (var i:int = 0; i < _fieldList.length; i++) 
			{
				_fieldList[i].field.text = Translator.translate(_fieldList[i].id);
			}
		}
		
		
		
		
		
		
		
		
		
		/**
		 * XML com o dicionário seguindo o modelo
		 * <dicionario>
		 * 	<ola>
		 * 		<br>olá</br>
		 * 		<en>hello</en>
		 * 		<es>hola</es>
		 * 	</ola>
		 * </dicionario>
		 */
		static public function get dictionary():XML { return _dictionary; }
		static public function set dictionary(value:XML):void 
		{
			_dictionary = value;
		}
		
		
		static public function get language():String { return _language; }
		static public function set language(value:String):void 
		{
			update();
			_language = value;
		}
		
		
		
	}
	
}


import flash.text.TextField;
internal class FieldInfo
{
	public var field:TextField;
	public var id:String;
	
	public function FieldInfo(field:TextField, id:String)
	{
		this.field = field;
		this.id = id;
	}
}

