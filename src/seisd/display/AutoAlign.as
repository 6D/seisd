package seisd.display 
{
	
	/*
	 * Vamoss
	 * implementada a integração com o IDisplayAlignable
	 * incorporando acesso direto as propriedades de alinhamento dos objetos
	 */
	
	/*
	 * based on cicron@naver.com (2008.10.17)
	 */
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	
	import seisd.utils.ArrayUtils;
	
	public class AutoAlign 
	{
		
		protected static var alignList:Vector.<Align> = new Vector.<Align>();
		
		public function AutoAlign() 
		{	
			
		}
		
		/**
		 * Adiciona o alvo no AutoAlign
		 * @param	target
		 * @param	vars
		 */
		/*
		 * 
			1. Stage Mode Setup
			- scaleMode = 'noScale' / align = 'TOP_LEFT'
			2. Set Stage Object
			- import ks.AutoAlign; // import 
			- AutoAlign.setStage(stage); // stage Object //
			3. New Align Object
			- Relative Alignment
			* AutoAlign.to( Object, { x:0.5, y:0.5 } ); // relative alignment
			: axis X to center (50%) / axis Y to Center (50%)
			* AutoAlign.to( Object, { x:[1, 960], y:[1, 640] } ); // relative alignment with limited area
			: axis X to right ( 100% & out of 960px ) / axis y to bottom ( 100% & out of 640 )
			- Absolute Aligment
			* AutoAlign.to( Object, { left:100, top:100 } );
			: x: 100, y: 100
			* AutoAlign.to( Object, { right:100, bottom:30 } );
			: x: stagewidth -100, y: stageheight-30
			* AutoAlign.to( Object, { right:[100,400], bottom:[100,400] } );
			: x: stagewidth -400, limit : 100 , y: stageheight -400, limit: 100
			4. Delete Object's Aligning
			- AutoAlign.del(Object);
			: delete object's align action
		**/
		public static function add(target:*, alignTarget:DisplayObject, vars:Object = null):Align
		{
			//TODO incluir o verificador se o target já existe, se sim, ele apenas atualiza
			
			var align:Align = new Align(target, alignTarget, vars);
			alignList.push(align);
			
			align.target.addEventListener(Event.ADDED_TO_STAGE, targetAdded);
			align.target.addEventListener(Event.REMOVED_FROM_STAGE, targetRemoved);
			
			//Verifica se já está no paco, ou se tem um alignTarget e faz o update
			if (align.alignTarget) AutoAlign.update(align.target);
			
			return align;
		}
		
		/**
		 * Retira o alvo do AutoAlign
		 * @param	target
		 */
		public static function del(target:DisplayObject):void
		{
			ArrayUtils.remove(target, alignList);
		}
		
		/**
		 * Verifica se o alvo já está no AutoAlign
		 * @param	target
		 * @return
		 */
		public static function has(target:DisplayObject):Boolean
		{
			return ArrayUtils.has(target, alignList);
		}
		
		/**
		 * Retorna um objeto Align baseado no alvo
		 * @param	target
		 * @return
		 */
		public static function getAlign(target:DisplayObject):Align
		{
			for (var i:int = 0; i < alignList.length; i++) 
			{
				if ( alignList[i].target == target ) {
					return alignList[i];
				}
			}
			return null;
		}
		
		
		
		
		
		/**
		 * Atualiza o posicionamento de todos os elementos, ou apenas um alvo específico
		 * @param	target
		 */
		public static function update(target:* = null):void
		{
			var parentWidth:Function = function(target:Align):Number {
				if (target.alignTarget is Stage) {
					return Stage(target.alignTarget).stageWidth;
				}else if (target.alignTarget is MovieClipBase && MovieClipBase(target.alignTarget).ww) {
					return MovieClipBase(target.alignTarget).ww;
				}else {
					return target.alignTarget.width;
				}
			}
			var parentHeight:Function = function(target:Align):Number {
				if (target.alignTarget is Stage ) {
					return Stage(target.alignTarget).stageHeight;
				}else if (target.alignTarget is MovieClipBase && MovieClipBase(target.alignTarget).hh) {
					return MovieClipBase(target.alignTarget).hh;
				}else {
					return target.alignTarget.height;
				}
			}
			var roundProp:Function = function(target:Align, hasProp:String, prop:String):void {
				if (ArrayUtils.has(hasProp, target.roundProps)) {
					target.target[prop] =  Math.ceil(target.target[prop]);
				}
			}
			var alignLeft:Function = function(target:Align):void {
				target.x = target.left;
				roundProp(target, "left", "x");
			}
			var alignRight:Function = function(target:Align):void {
				var gox:Number = parentWidth(target) - target.right;
				if ( target.rightLimit ) {
					gox < target.rightLimit ? target.x = target.rightLimit : target.x = gox  ;
				} else {
					target.x = gox;
				}
				roundProp(target, "right", "x");
			}
			var alignTop:Function = function(target:Align):void {
				target.y = target.top;
			}
			var alignBottom:Function = function(target:Align):void {
				var goy:Number = parentHeight(target) - target.bottom;
				if ( target.bottomLimit ) {
					goy < target.bottomLimit ? target.y = target.bottomLimit : target.y = goy ;
				} else {
					target.y = goy;
				}
				roundProp(target, "bottom", "y");
			}
			var alignX:Function = function(target:Align):void {
				var gox:Number = parentWidth(target) * target.xPercent;
				if ( target.leftLimit ) {
					gox < target.leftLimit ? target.x = target.leftLimit : target.x = gox ;
				} else {
					target.x = gox;
				}
				roundProp(target, "xPercent", "x");
			}
			var alignY:Function = function(target:Align):void {
				var goy:Number = parentHeight(target) * target.yPercent;
				if ( target.topLimit ) {
					goy < target.topLimit ? target.y  = target.topLimit : target.y = goy ;
				} else {
					target.y = goy;
				}
				roundProp(target, "yPercent", "y");
			}
			
			for(var i:uint = 0; i < alignList.length; i ++ )
			{
				var mc:Align = alignList[i];
				
				if (mc.alignTarget)
				{
					//realinha apenas o target quando setado, ou todos quando não setado
					if ((target && mc.target == target) || (target is Event|| target == null))
					{
						if ( !isNaN(mc.top) ) 		alignTop(mc);
						if ( !isNaN(mc.bottom) )	alignBottom(mc);
						if ( !isNaN(mc.left) ) 		alignLeft(mc);
						if ( !isNaN(mc.right) ) 	alignRight(mc);
						if ( !isNaN(mc.xPercent) ) 	alignX(mc) ;
						if ( !isNaN(mc.yPercent) ) 	alignY(mc);
					}
				}
			}
		}
		
		/**
		 * Added to stage
		 * @param	e
		 */
		private static function targetAdded(e:Event):void 
		{
			getAlign(e.currentTarget as DisplayObject).alignTarget.addEventListener(Event.RESIZE, AutoAlign.update);
			//e.currentTarget.addEventListener(Event.RESIZE, AutoAlign.update);
		}
		
		/**
		 * Removed from stage
		 * @param	e
		 */
		private static function targetRemoved(e:Event):void 
		{
			getAlign(e.currentTarget as DisplayObject).alignTarget.removeEventListener(Event.RESIZE, AutoAlign.update);			
			//e.currentTarget.removeEventListener(Event.RESIZE, AutoAlign.update);			
		}
	}
}