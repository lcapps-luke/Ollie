package script;

import haxe.io.BytesInput;
import openfl.Assets;

class Script
{
	private static var SCRIPT_REGEX = ~/^(\d+) ([\.\d]+) (\d) (\d)$/;

	public static function load(script:String, shift:Int):Array<Cue>
	{
		var dataInput = new BytesInput(Assets.getBytes(script));
		var cueList = new Array<Cue>();

		while (dataInput.position < dataInput.length)
		{
			var line = dataInput.readLine();

			if (SCRIPT_REGEX.match(line))
			{
				cueList.push({
					time: Std.parseInt(SCRIPT_REGEX.matched(1)) + shift,
					hold: Std.parseFloat(SCRIPT_REGEX.matched(2)),
					ollie: Std.parseInt(SCRIPT_REGEX.matched(3)),
					udin: Std.parseInt(SCRIPT_REGEX.matched(4))
				});
			}
		}

		return cueList;
	}
}
