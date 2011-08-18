package seisd.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Vamoss
	 */	 
	public class ParticleMe extends Sprite
	{
		public var aParticles:Vector.<Particle>;
		
		private var force:uint;
		private var velocity:Number;
		
		private var state:String;
		
		private var bmd:BitmapData;
		private var canvas:Bitmap;
		private const canvasMargin:int = 50;
		
		private var particlesContainer:Sprite;
		
		public function ParticleMe(target:DisplayObjectContainer, particleSize:int = 1, color:uint = 0xFFFF00, force:uint = 450, velocity:Number = .1) {
			
			this.force = force;
			this.velocity = velocity;
			
			//Clone Position
			x = target.x;
			y = target.y;
			target.x = 0;
			target.y = 0;
			
			//Clone Parent
			if (target.parent) {
				target.parent.addChild(this);
				target.parent.removeChild(target);
			}
			addChild(target);
			
			
							//x:aParticles[i].origin.x - (force / distance * 5) * (xDif / distance * 5),
							//y:aParticles[i].origin.y - (force / distance * 5) * (yDif / distance * 5)
			
			bmd = new BitmapData(target.width + canvasMargin * 2, target.height + canvasMargin * 2, true, 0x000000);
			canvas = new Bitmap(bmd);
			canvas.x = -canvasMargin;
			canvas.y = -canvasMargin;
			addChild(canvas);
			particlesContainer = new Sprite();
			
			//HitArea
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, target.width, target.height);
			graphics.endFill();
			
			
			//Fill Particles
			var counter:int = 0;
			aParticles = new Vector.<Particle>();
			for (var xx:int  = 0; xx <= target.width; xx += particleSize) {
				for (var yy:int = 0; yy <= target.height; yy += particleSize) {
					if (target.hitTestPoint(this.x + xx, this.y + yy, true)) {
						aParticles[counter] = particlesContainer.addChild(new Particle(xx, yy, particleSize, color)) as Particle;
						counter++;
					}
				}
			}
			
			//Interact
			addEventListener(Event.ENTER_FRAME, render);			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		private function mouseOver(e:MouseEvent):void 
		{
			state = MouseEvent.MOUSE_OVER;
		}
		
		private function mouseOut(e:MouseEvent):void 
		{
			state = MouseEvent.MOUSE_OUT;
		}
		
		private function render(e:Event):void 
		{
			var destiny:Object;
			var xDif:Number;
			var yDif:Number;
			var distance:Number;
			
			for (var i:int = 0; i < aParticles.length; i++ ) {
				destiny = {x:aParticles[i].origin.x, y:aParticles[i].origin.y};
				
				if(state==MouseEvent.MOUSE_OVER){
					xDif = mouseX-aParticles[i].x;
					yDif = mouseY-aParticles[i].y;
					distance = Math.sqrt(xDif * xDif + yDif * yDif);
					
					if (distance < force*.5) {
						destiny = {
							x:aParticles[i].origin.x - (force / distance) * (xDif / distance),
							y:aParticles[i].origin.y - (force / distance) * (yDif / distance)
						}
					}
				}
				
				aParticles[i].x += (destiny.x - aParticles[i].x) * velocity;
				aParticles[i].y += (destiny.y - aParticles[i].y) * velocity;
			}
				
			draw();
		}
		
		private function draw():void
		{
			bmd.lock();
			bmd.applyFilter(bmd, bmd.rect, new Point(0, 0), new BlurFilter(1.5, 1.5, 1));
			bmd.applyFilter(bmd, bmd.rect, new Point(0, 0), new ColorMatrixFilter( [ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.9, 0 ] ));
			bmd.draw(particlesContainer, new Matrix(.8, 0, 0, .8, canvasMargin, canvasMargin));
            bmd.unlock();
		}
	}
	
}

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

internal dynamic class Particle extends Sprite
{	
	public var origin:Point;
	
    public function Particle(x:Number = 0, y:Number = 0, particleSize:int = 5, color:uint = 0x000000)
    {
        this.x = x - particleSize * .5;
        this.y = y - particleSize * .5;
		
		origin = new Point(this.x, this.y);
		
		graphics.beginFill(color);
		graphics.drawRect(0, 0, particleSize, particleSize);
		graphics.endFill();
    }
	
	private function drawLineToOrigin(p:Particle):void {
		// draw a line to the origin
		p.graphics.clear();
		p.graphics.lineStyle(0, 0x000000, 15);
		p.graphics.lineTo(p.origin.x - p.x, p.origin.y - p.y);
	};
}