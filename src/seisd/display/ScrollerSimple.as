package seisd.display
{
	import com.greensock.easing.Back;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Davi Fontenele
	 */
	public class ScrollerSimple extends Sprite
	{
		private var _target:DisplayObject;
		private var _clicado:Sprite;
		private var _margem:Number;
		private var _ampliar:Number;
		private var larguraScroll:Number;
		private var _scroller:Sprite;
		private var mascara:Sprite;
		private var trilho:Shape;
		private var barra:Sprite;
		private var barraHit:Shape;
		private var barraShape:Shape;
		private var _corTrilho:Number;
		private var _corBarra:Number;
		private var _zero:Number;
		private var _yInicial:Number;
		
		/**
		 * 
		 * @param	alvo
		 * @param	params Default: { corTrilho:0xCCCCCC, corBarra:0x666666, width:1, bottom:100, gain:2 }
		 */
		public function ScrollerSimple(alvo:DisplayObject, params:Object = null)
		{
			if (alvo is TextField) TextField(alvo).mouseWheelEnabled = false;
			
			x = alvo.x;
			y = alvo.y;
			
			params = params || {}
			_corTrilho = params.cor1 != undefined ? params.cor1 : params.corTrilho != undefined ? params.corTrilho : 0xCCCCCC;
			_corBarra = params.cor2 != undefined ? params.cor2 : params.corBarra != undefined ? params.corBarra : 0x666666;
			
			larguraScroll = params.width != undefined ? params.width : 1;
			_target = alvo;
			_margem = params.bottom != undefined ? params.bottom : 100;
			_ampliar = params.gain != undefined ? params.gain : 2;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			mascara = new Sprite();
			mascara.name = "mascara";
			
			mascara.graphics.beginFill(0x00FF00, .3);
			mascara.graphics.drawRect(0, 0, _target.width, 180);
			mascara.graphics.endFill();
			
			scroller = new Sprite();
			scroller.name = "scroller";
			scroller.x = mascara.width + 20;
			scroller.y = mascara.y;
			scroller.alpha = 0;
			
			trilho = new Shape();
			trilho.name = "trilho";
			trilho.graphics.beginFill(_corTrilho);
			trilho.graphics.drawRect(0, 0, larguraScroll, 180);
			trilho.graphics.endFill();
			scroller.addChild(trilho);
			
			barra = new Sprite();
			barra.name = "barra";
			
			barraHit = new Shape();
			barraHit.graphics.beginFill(0x00FF00,0);
			barraHit.graphics.drawRect(-10, 0, larguraScroll + 20, 50);
			barraHit.graphics.endFill();
			barra.addChild(barraHit);
			
			barraShape = new Shape();
			barraShape.name = "shape";
			barraShape.graphics.beginFill(_corBarra);
			barraShape.graphics.drawRect(0, 0, larguraScroll, 50);
			barraShape.graphics.endFill();
			barra.addChild(barraShape);
			scroller.addChild(barra);
			
			barra.buttonMode = true;
			
			barra.addEventListener(MouseEvent.MOUSE_OVER, barraMouseEvents);
			barra.addEventListener(MouseEvent.MOUSE_OUT, barraMouseEvents);
			barra.addEventListener(MouseEvent.MOUSE_DOWN, pickScroll);
			
			addEventListener(Event.ENTER_FRAME, scroll);
			addEventListener(MouseEvent.MOUSE_WHEEL, scrollWheel);
			
			_target.mask = mascara;
			_target.x = _target.y = 0;
			addChild(_target);
			addChild(mascara);
			addChild(scroller);
		}
		
		private function destroy(e:Event):void{
			removeEventListener(Event.ENTER_FRAME, scroll);
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(MouseEvent.MOUSE_WHEEL, scrollWheel);			
		}
		
		private function barraMouseEvents(e:MouseEvent):void 
		{
			TweenLite.to(e.currentTarget.getChildByName("shape"), .5, { x: e.type == MouseEvent.MOUSE_OVER ? -_ampliar : 0, width:larguraScroll + (e.type == MouseEvent.MOUSE_OVER ? _ampliar * 2 : 0), ease:Back.easeOut } );
		}
		
		private function scrollWheel(e:MouseEvent):void
		{
			barra.y -= e.delta;
		}
		
		private function pickScroll(e:MouseEvent):void
		{
			_clicado = e.currentTarget as Sprite;
			_clicado.addEventListener(Event.ENTER_FRAME, dragScroll);
			stage.addEventListener(MouseEvent.MOUSE_UP, dropScroll);
			_zero = mouseY;
			_yInicial = _clicado.y;
		}
		
		private function dropScroll(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, dropScroll);
			_clicado.removeEventListener(Event.ENTER_FRAME, dragScroll);
		}
		
		private function dragScroll(e:Event):void 
		{
			if(_yInicial + (mouseY - _zero) < 0)
				_clicado.y = 0;
			else if (_yInicial + (mouseY - _zero) > (trilho.height - _clicado.height))
				_clicado.y = trilho.height - _clicado.height;
			else
				_clicado.y = _yInicial + (mouseY - _zero);
		}
		
		public function scroll(e:Event = null):void
		{
			//REFRESH SCROLL
			var superMargem:Number = _margem;
			var nextParent:DisplayObject = this.parent;
			while (nextParent.parent)
			{
				superMargem += nextParent.y;
				nextParent = nextParent.parent;
			}
			
			mascara.height = trilho.height = stage.stageHeight - mascara.y - superMargem;
			barra.height = (mascara.height / _target.height) * trilho.height;
			if (barra.y > trilho.height - barra.height) barra.y = trilho.height - barra.height;
			if (barra.y < trilho.y) barra.y = trilho.y;
			
			//"SCROLLA" OU NÃO
			if (mascara.height < _target.height)
			{
				scroller.alpha += .2 * (1 - scroller.alpha);
				scroller.mouseChildren = scroller.mouseEnabled = true;
				var calculo:Number = mascara.y - barra.y * (trilho.height / barra.height);
				var distancia:Number = calculo > mascara.y ? mascara.y : calculo < mascara.y + (mascara.height - _target.height)? mascara.y + (mascara.height - _target.height) : calculo;
				_target.y += .2 * (distancia - _target.y);
				if (barra.y > trilho.height - barra.height) barra.y = trilho.height - barra.height;
				if (barra.y < 0) barra.y = 0;
				if (mouseX > scroller.x + scroller.width + 10 || mouseX < scroller.x - 10) barra.stopDrag();
				if (mouseY > scroller.y + scroller.height + 10 || mouseY < scroller.y - 10) barra.stopDrag();
			}
			else
			{
				_target.y += .2 * (mascara.y - _target.y);
				scroller.alpha += .2 * (0 - scroller.alpha);
				scroller.mouseChildren = scroller.mouseEnabled = false;
			}
		}
		
		public function get visibleHeight():Number {
			var h:Number = 0;
			if (mascara) {
				if (_target.height < mascara.height) {
					h = _target.height;
				}else{
					h = mascara.height;
				}
			}
			return h;
		}
		
		public function get scroller():Sprite 
		{
			return _scroller;
		}
		
		public function set scroller(value:Sprite):void 
		{
			_scroller = value;
		}
		
	}
	
}