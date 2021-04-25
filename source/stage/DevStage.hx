package stage;

import flixel.FlxG;

class DevStage extends AbstractStageState
{
	private static inline var TRACK:String = AssetPaths.swing_swing__ogg;
	private static inline var START:Int = 8339;
	private static inline var END_FADE:Int = 138315;
	private static inline var END_SWAP:Int = END_FADE + 3000;

	public function new()
	{
		super(TRACK, START, END_FADE, END_SWAP);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var pos = Math.round(FlxG.sound.music.time);

		if (FlxG.mouse.justPressed)
		{
			trace('$pos');
		}
	}

	private function onStageEnd()
	{
		FlxG.switchState(new MenuState());
	}
}
