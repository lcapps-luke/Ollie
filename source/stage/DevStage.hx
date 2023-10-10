package stage;

import flixel.FlxG;

class DevStage extends AbstractStageState
{
	private static var TRACK:String = AssetPaths.makePath(AssetPaths.LIB_MUSIC_METAL, AssetPaths.jollie_jollie_metal__ogg);
	private static inline var START:Int = 8040; // 8339;
	private static inline var END_FADE:Int = 173170;
	private static inline var END_SWAP:Int = END_FADE + 1000;

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

		if (FlxG.keys.anyJustReleased([R]))
		{
			scrubMusic(0);
		}

		if (FlxG.keys.anyJustReleased([ONE]))
		{
			scrubMusic(0.1);
		}
		if (FlxG.keys.anyJustReleased([TWO]))
		{
			scrubMusic(0.2);
		}
		if (FlxG.keys.anyJustReleased([THREE]))
		{
			scrubMusic(0.3);
		}
		if (FlxG.keys.anyJustReleased([FOUR]))
		{
			scrubMusic(0.4);
		}
		if (FlxG.keys.anyJustReleased([FIVE]))
		{
			scrubMusic(0.5);
		}
		if (FlxG.keys.anyJustReleased([SIX]))
		{
			scrubMusic(0.6);
		}
		if (FlxG.keys.anyJustReleased([SEVEN]))
		{
			scrubMusic(0.7);
		}
		if (FlxG.keys.anyJustReleased([EIGHT]))
		{
			scrubMusic(0.8);
		}
		if (FlxG.keys.anyJustReleased([NINE]))
		{
			scrubMusic(0.9);
		}
	}

	private function scrubMusic(pos:Float)
	{
		FlxG.sound.music.time = FlxG.sound.music.length * pos;
	}

	private function onStageEnd()
	{
		FlxG.switchState(new MenuState());
	}

	function createBackground() {}
}
