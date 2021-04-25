package stage;

import flixel.FlxG;

class DevStage extends AbstractStageState
{
	private static inline var TRACK:String = AssetPaths.swing_swing__ogg;
	private static inline var START:Int = 1; // 8339;
	private static inline var END_FADE:Int = 138315;
	private static inline var END_SWAP:Int = END_FADE + 3000;

	private var rightDown:Int = 0;

	public function new()
	{
		super(TRACK, START, END_FADE, END_SWAP);
	}

	override function create()
	{
		super.create();

		// FlxG.sound.music.time = 87734 - 2000;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var pos = Math.round(FlxG.sound.music.time);

		if (FlxG.mouse.justPressed)
		{
			trace('$pos');
		}

		if (FlxG.mouse.justPressedRight)
		{
			rightDown = pos;
		}

		if (FlxG.mouse.justReleasedRight)
		{
			var dur = (pos - rightDown) / 1000;
			trace('$rightDown - $pos [$dur]');
		}
	}

	private function onStageEnd()
	{
		FlxG.switchState(new MenuState());
	}

	function createBackground() {}
}
