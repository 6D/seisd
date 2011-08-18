package seisd.utils 
{
	
	/**
	 * ...
	 * @author Vamoss
	 */
	public class DateUtils 
	{
		private static var languageDictionary:Object = 
		{
			br:{
				monthNames:['janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho', 'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'],
				lessThanMinute:'menos de um minuto',
				aboutAMinute:'cerca de um minuto',
				minuteAgo:' minutos atrás',
				aboutHour:'cerca de uma hora atrás',
				hourAgo:' horas atrás',
				yesterday:'ontem',
				dayAgo:' dias atrás',
				aboutWeek:'cerca de uma semana atrás',
				weekAgo:' semanas atrás',
				aboutMonth:'cerca de um mes atrás',
				monthAgo:' meses atrás',
				aboutYear:'cerca de ano atrás',
				yearsAgo:' anos atrás',
				longDateFunction:formatDatePortuguese
			},
			en:{
				monthNames:['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'],
				lessThanMinute:'less than a minute ago',
				aboutAMinute:'about a minute ago',
				minuteAgo:' minutes ago',
				aboutHour:'about a hour ago',
				hourAgo:' hours ago',
				yesterday:'yesterday',
				dayAgo:' days ago',
				aboutWeek:'about a week ago',
				weekAgo:' weeks ago',
				aboutMonth:'about a month ago',
				monthAgo:' months ago',
				aboutYear:'about a year ago',
				yearsAgo:' years ago',
				longDateFunction:formatDateEnglish
			}
		}
		
		
		/**
		 * Converte Date num formato mais amigável, como o Facebook faz
		 * As linguas sao setadas na classe, atualmente disponiveis "br" e "en"
		 * @param	date
		 * @param	language
		 * @param	relativeDays Tempo (em horas) necessário para mostrar conteúdo do tipo "dias atrás", após esse tempo, mostrará na modo completo, exemplo: 1 de janeiro de 2011
		 *						 Se for definido como NaN, sempre retornará o modo completo
		 * 						 Default: 7 dias
		 * @return
		 */
		public static function friendlyDate(date:Date, relativeDays:Number = 7, language:String = "br"):String
		{
			var delta:int = ((new Date()).getTime() - date.getTime()) / 1000;
			
			var cutoff:Number = + relativeDays === relativeDays ? relativeDays * 24 * 60 * 60 : Infinity;
			
			if (relativeDays === false || delta > cutoff || delta < 0)
			return languageDictionary[language].longDateFunction(date, languageDictionary[language].monthNames);
			
			if (delta < 60) return languageDictionary[language].lessThanMinute;
			
			var minutes:Number = delta / 60;
			if (minutes < 2) return languageDictionary[language].aboutAMinute;
			if (minutes < 60) return Math.floor(minutes) + languageDictionary[language].minuteAgo;
			
			var hours:Number = minutes / 60;
			if (hours < 2) return languageDictionary[language].aboutHour;
			if (hours < 24) return Math.floor(hours) + languageDictionary[language].hourAgo;
			
			var days:Number = hours / 24;
			if (days < 2) return languageDictionary[language].yesterday;
			if (days < 7) return Math.floor(days) + languageDictionary[language].dayAgo;
			
			var weeks:Number = days / 7;
			if (weeks < 2) return languageDictionary[language].aboutWeek;
			if (weeks < 4) return Math.floor(weeks) + languageDictionary[language].weekAgo;
			
			var months:Number = days / 30;
			if (months < 2) return languageDictionary[language].aboutMonth;
			if (months < 12) return Math.floor(months) + languageDictionary[language].monthAgo;
			
			var years:Number = months / 12;
			if (years < 2) return languageDictionary[language].aboutYear;
			
			return years + languageDictionary[language].yearsAgo;
		}
		
		/// Return 10:05 am
		public static function formatTime(date:Date):String
		{
			var h:Number = date.getHours(), 
				m:Number = date.getMinutes();
			return (h > 12 ? h - 12 : h) + ':' + (m < 10 ? '0' : '') + m + ' ' + (h < 12 ? 'am' : 'pm');
		}
		
		/// Return january 15th, 2011 at 10:05 am
		private static function formatDateEnglish(date:Date, monthNames:Array):String
		{
			var mon:String = monthNames[date.getMonth()],
				day:Number = date.getDate(),
				year:Number = date.getFullYear(),
				suf:String = ordinalSuffix(day);
			
			return mon + ' ' + day + suf + ', ' + year + ' at ' + formatTime(date);
		}

		/// Return 15 de janeiro de 2011 as 10:05 am
		private static function formatDatePortuguese(date:Date, monthNames:Array):String
		{
			var mon:String = monthNames[date.getMonth()],
				day:Number = date.getDate(),
				year:Number = date.getFullYear();
			
			return day + ' de ' + mon + ' de ' + year + ' as ' + formatTime(date);
		}
		
		/// Return 15th or 20st for example
		private static function ordinalSuffix(day:Number):String
		{
			return ['th', 'st', 'nd', 'rd'][day < 4 || (day > 20 && day % 10 < 4) ? day % 10 : 0];
		}
	}
}