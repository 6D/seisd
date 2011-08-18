package seisd.display
{
	import flash.display.DisplayObject;
	
	import seisd.debug.print_r;
	
	/**
	 * ...
	 * @author Vamoss, Harrison
	 */
	public class Align 
	{
		
		
		private var _xPercent:Number = NaN;
		private var _yPercent:Number = NaN;
		private var _left:Number = NaN;
		private var _right:Number = NaN;
		private var _top:Number = NaN;
		private var _bottom:Number = NaN;
		private var _leftLimit:Number = NaN;
		private var _rightLimit:Number = NaN;
		private var _topLimit:Number = NaN;
		private var _bottomLimit:Number = NaN;
		private var _alignTarget:DisplayObject;
		
		public var target:DisplayObject;
		
		///Arredonda os valores de posicionamento
		///Por exemplo roundProps = ["xPercent", "top"];
		public var roundProps:Array = new Array();
		
		public function Align(target:DisplayObject, alignTarget:DisplayObject, vars:Object = null)
		{
			this.target = target;
			this._alignTarget = alignTarget;
			
			//Clone vars to this
			for (var prop:String in vars) { 
				this['_' + prop] = vars[prop];
			};
		}
		
		///Alvo responsável pelo alinhamento, ex: Stage, Parent ou qualquer ou	tro container
		/// Caso não esteja setado, a propriedade "parent" é automaticamente associada
		public function get alignTarget():DisplayObject
		{
			if (!_alignTarget && target.parent) _alignTarget = target.parent;
			return _alignTarget;
		}
		public function set alignTarget(value:DisplayObject):void 
		{
			_alignTarget = value;
			update();
		}
		
		///Posicionamento relativo do elemento pela esquerda de acordo com uma porcentagem. Ex: 50% = .5;
		public function get xPercent():Number { return !isNaN(_xPercent) ? _xPercent : NaN; }
		public function set xPercent(value:Number):void
		{
			_xPercent = value;
			update();
		}
		
		///Posicionamento relativo do elemento pela esquerda de acordo com uma porcentagem. Ex: 50% = .5;
		public function get yPercent():Number { return !isNaN(_yPercent) ? _yPercent : NaN; }
		public function set yPercent(value:Number):void
		{
			_yPercent = value;
			update();
		}
		
		///Posiciona absoluto do elemento pela esquerda.
		public function get left():Number { return !isNaN(_left) ? _left : NaN; }
		public function set left(value:Number):void
		{
			_left = value;
			update();
		}
		
		///Posiciona absoluto do elemento pela direita.
		public function get right():Number { return !isNaN(_right) ? _right : NaN; }
		public function set right(value:Number):void
		{
			_right = value;
			update();
		}
		
		///Posiciona absoluto do elemento pelo topo.
		public function get top():Number { return !isNaN(_top) ? _top : NaN; }
		public function set top(value:Number):void
		{
			_top = value;
			update();
		}
		
		///Posiciona absoluto do elemento pela base.
		public function get bottom():Number { return !isNaN(_bottom) ? _bottom : NaN; }
		public function set bottom(value:Number):void
		{
			_bottom = value;
			update();
		}
			
		///Limita o posicionamento pela esquerda até o valor determinado.
		public function get leftLimit():Number { return !isNaN(_leftLimit) ? _leftLimit : NaN; }
		public function set leftLimit(value:Number):void
		{
			_leftLimit = value;
			update();
		}
			
		///Limita o posicionamento pela direita até o valor determinado.
		public function get rightLimit():Number { return !isNaN(_rightLimit) ? _rightLimit : NaN; }
		public function set rightLimit(value:Number):void
		{
			_rightLimit = value;
			update();
		}
		
		///Limita o posicionamento pelo topo até o valor determinado.
		public function get topLimit():Number { return !isNaN(_topLimit) ? _topLimit : NaN; }
		public function set topLimit(value:Number):void
		{
			_topLimit = value;
			update();
		}
		
		///Limita o posicionamento pela base até o valor determinado.
		public function get bottomLimit():Number { return !isNaN(_bottomLimit) ? _bottomLimit : NaN; }
		public function set bottomLimit(value:Number):void
		{
			_bottomLimit = value;
			update();
		}
		
		public function get x():Number { return target.x; }
		public function set x(value:Number):void { target.x = value;}
		
		public function get y():Number { return target.y; }
		public function set y(value:Number):void { target.y = value; }
		
		public function get width():Number { return target.width; }
		public function set width(value:Number):void { target.width = value; }
		
		public function get height():Number { return target.height; }
		public function set height(value:Number):void { target.height = value; }
		
		
		
		public function update():void
		{
			if (!AutoAlign.has(target)) { 
				AutoAlign.add(target, _alignTarget)
			} else {
				AutoAlign.update(target);
			}
		}
		
		
		
		
		
		
		
		
		/// Melhora o trace
		public function toString():String
		{
			var alignProps:Array =
			[
				'target',
				'alignTarget',
				'xPercent',
				'yPercent',
				'left',
				'top',
				'right',
				'top',
				'bottom',
				'leftLimit',
				'rightLimit',
				'topLimit',
				'bottomLimit',
				'x',
				'y',
				'width',
				'height'
			]
			
			var relevantProps:Object = {}
			
			for (var i:int = 0; i < alignProps.length; i++) 
				if (this[alignProps[i]]) relevantProps[alignProps[i]] = this[alignProps[i]];
			
			return print_r(relevantProps, true);
		}
		
		
		
	}
	
}