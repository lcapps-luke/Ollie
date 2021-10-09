package birthday;

class BirthdayUtils
{
	public static inline var MONTH:Int = 9; // Zero indexed October
	public static inline var DAY:Int = 13; // 13th

	public static function isBirthday():Bool
	{
		var date:Date = Date.now();
		return date.getMonth() == MONTH && date.getDate() == DAY;
	}
}
