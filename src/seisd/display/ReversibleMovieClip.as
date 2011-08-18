package seisd.display
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class ReversibleMovieClip extends MovieClipBase
	{
		
		
		/**
		 * Cria um MovieClipBase que possui a opção de dar playBack() e possui um stop no seu último frame
		 * @param	autoStopOnInit Se for true, começa com dando um stop para permanecer no primeiro frame.
		 */
		public function ReversibleMovieClip(autoStopOnInit:Boolean = false)
		{	
			addFrameScript(totalFrames - 1, stop);
			if (autoStopOnInit) stop();
		}
		
		/**
		 * Dá play invertido
		 */
		public function playBack():void 
		{
			addEventListener(Event.ENTER_FRAME, goBack);
		}
		
		/// override no stop apenas para pausar também um eventual playback
		override public function stop():void 
		{
			super.stop();
			removeEventListener(Event.ENTER_FRAME, goBack);
		}
		
		
		
		
		
		
		////////////////////
		///// HANDLERS /////
		////////////////////
		
		/// @private Dá prevFrame() a cada frame. Se chegar no primeiro frame, dá stop()
		private function goBack(e:Event):void
		{
			(currentFrame == 1) ? stop() : prevFrame();
		}
		
		
		
	}
	
}