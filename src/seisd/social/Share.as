package seisd.social
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Harrison
	 */
	public class Share
	{
		
		/**
		 * Open a new widnow to share something on facebook
		 * @param	title The message
		 * @param	url The absolute url that want to share
		 * @param	message The message
		 * @param	image The absolute url to an image
		 */
		public static function facebook(url:String = '', title:String = '', message:String = '', image:String = ''):void
		{
			var share:String = 'http://www.facebook.com/sharer.php?s=100';
				share += '&p[title]=' + encodeURIComponent(title);
				share += '&p[url]=' + encodeURIComponent(url);
				share += '&p[summary]=' + encodeURIComponent(message);
				share += '&p[images][0]=' + encodeURIComponent(image);
				
			openWindow(share);
		}
		
		/**
		 * Open a new window to promote something on orkut
		 * @param	title The message
		 * @param	url The absolute url that want to share
		 * @param	message The message
		 * @param	image The absolute url to an image
		 */
		public static function orkut(url:String = '', title:String = '', message:String = '', image:String = ''):void
		{
			var share:String = 'http://promote.orkut.com/preview?nt=orkut.com';
				share += '&tt=' + encodeURIComponent(title);
				share += '&du=' + encodeURIComponent(url);
				share += '&cn=' + encodeURIComponent(message);
				share += '&tn=' + encodeURIComponent(image);
				
			openWindow(share);
		}
		
		/**
		 * Open a new window to share something on twitter
		 * @param	url The absolute url that want to share. Don't worry if it too big, the twitter's system automatically use Twitter's URL shortener
		 * @param	message The message
		 */
		public static function twitter(url:String = '', message:String = ''):void
		{
			var share:String = 'http://twitter.com/share?';
				share += 'text=' + encodeURIComponent(message);
				share += '&url=' + encodeURIComponent(url);
				
			openWindow(share);
		}
		
		
		
		
		/// @private Tenta abrir um popup, se não conseguir, usa o clássico navigateToURL
		private static function openWindow(url:String):void
		{
			try 
			{
				var callReturn:* = ExternalInterface.call('window.open', url, '_blank', 'width=760,height=400');
				if (callReturn === null) throw new Error('swf rodando dentro do flash');
			}
			catch (err:Error)
			{
				navigateToURL(new URLRequest(url), '_blank');
			}
		}
		
		
		
	}
	
}