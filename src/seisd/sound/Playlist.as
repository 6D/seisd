package seisd.sound
{
	import com.greensock.loading.MP3Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import seisd.navigation.core.NavigationEvent;
	import seisd.navigation.NavigationLoaders;
	import seisd.utils.ArrayUtils;
	
	
	
	/// @eventType	seisd.sound.Playlist.PLAY
	[Event(name = "play", type = "seisd.sound.Playlist")] 
	
	/// @eventType	seisd.sound.Playlist.PAUSE
	[Event(name = "pause", type = "seisd.sound.Playlist")] 
	
	/// @eventType	seisd.sound.Playlist.CHANGE
	[Event(name = "change", type = "seisd.sound.Playlist")] 
	
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class Playlist extends EventDispatcher 
	{
		
		public static const PLAY:String = 'play';
		public static const PAUSE:String = 'pause';
		public static const CHANGE:String = 'change';
		
		
		
		/// Navegação de MP3Loader das músicas
		public var navMP3:NavigationLoaders;
		
		/// @private Armazena o volume para todas as músicas
		private var _volume:Number;
		
		/// @private Armazena o volume para o toggle do volume
		private var _savedVolume:Number;
		
		
		
		
		/**
		 * Player de músicas carregadas externamente
		 */
		public function Playlist()
		{
			_volume = 1;
			
			navMP3 = new NavigationLoaders();
			navMP3.addEventListener(NavigationEvent.DEACTIVATED, stop);
			navMP3.addEventListener(NavigationEvent.ACTIVATED, activated);
		}
		
		/// @private Handler de troca de música
		private function activated(e:NavigationEvent):void 
		{
			play();
			dispatchEvent(new Event(Playlist.CHANGE));
		}
		
		/**
		 * Adiciona uma url de mp3 para a playlist. Considere a música adicionada a playlist após este momento.
		 * @param	url
		 */
		public function add(url:String):void
		{
			var mp3:MP3Loader = new MP3Loader(url, { autoPlay:false } );
				mp3.addEventListener(MP3Loader.SOUND_COMPLETE, nextTrack);
			navMP3.add(mp3);
			
			if (currentSoundLoader) mp3.volume = currentSoundLoader.volume;
		}
		
		/**
		 * Inicia o carregamento das música e automaticamente inicia a primeira música
		 * @param	shuffleTracks Se for true, embaralha as músicas antes de iniciar
		 */
		public function init(shuffleTracks:Boolean = false):void
		{
			if (shuffleTracks) ArrayUtils.mix(navMP3.list);
			
			navMP3.load();
			navMP3.activateFirstOnList();
		}
		
		
		
		
		
		
		
		////////////////////////////////
		///// CONTROLE DA PLAYLIST /////
		////////////////////////////////
		
		/// Play na música
		public function play(e:Event = null):void
		{
			volume = _volume;
			currentSoundLoader.playSound();
			dispatchEvent(new Event(Playlist.PLAY));
		}
		
		/// Pause na música
		public function pause(e:Event = null):void
		{
			currentSoundLoader.pauseSound();
			dispatchEvent(new Event(Playlist.PAUSE));
		}
		
		/// Play se estiver pausado. Pause se estiver tocando
		public function toggle(e:Event = null):void
		{
			currentSoundLoader.soundPaused ? play() : pause();
		}
		
		/// Stop na música
		public function stop(e:Event = null):void
		{
			pause();
			currentSoundLoader.gotoSoundTime(0);
		}
		
		/// Stop na música atual e play na anterior (de acordo com a adição na playlist)
		public function previousTrack(e:Event = null):void
		{
			navMP3.activatePreviousOnList();
		}
		
		/// Stop na música atual e play na seguinte (de acordo com a adição na playlist)
		public function nextTrack(e:Event = null):void
		{
			navMP3.activateNextOnList();
		}
		
		/// Stop na música atual e play em alguma aleatória
		public function randomTrack(e:Event = null):void
		{
			navMP3.activateRandomOnList();
		}
		
		/// Liga e desliga o volume
		public function toggleVolume(e:Event = null):void 
		{
			if (volume > 0) 
			{
				_savedVolume = _volume;
				volume = 0;
			}
			else
			{
				volume = _savedVolume;
			}
		}
		
		/// Ajusta o volume (0-1)
		public function get volume():Number 
		{
			return _volume;
		}
		
		/// Ajusta o volume (0-1) e aplica a música atual
		public function set volume(value:Number):void 
		{
			_volume = value;
			currentSoundLoader.volume = _volume;
		}
		
		
		
		
		
		
		
		
		/////////////////
		///// ÚTEIS /////
		/////////////////
		
		/**
		 * Boolean indicando se a música está tocando
		 * !currentSoundLoader.soundPaused
		 */
		public function isPlaying():Boolean
		{
			return !currentSoundLoader.soundPaused;
		}
		
		/**
		 * MP3Loader da música ativa
		 * MP3Loader(navMP3.current)
		 */
		public function get currentSoundLoader():MP3Loader
		{
			return MP3Loader(navMP3.current);
		}
		
		/**
		 * Índice da música ativa
		 * navMP3.currentIndex
		 */
		public function get currentIndex():uint 
		{
			return navMP3.currentIndex;
		}
		
		
		
		
	}
	
}