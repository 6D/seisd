package seisd.debug
{
	
	/**
	 * ...
	 * @author Harrison
	 */
	public function print_r(object:Object, dontTrace:Boolean = false):String 
	{
		var string:String = '{ ';
		
		for (var value:* in object)
			string += value + ':' + object[value] + ', ';
		
		string = string.slice(0, string.lastIndexOf(',')); //remove a última vírgula
		string += ' }';
		
		if (!dontTrace) trace(string);
		
		return string;
	}
	
}