package stage;

import flixel.FlxG;
import score.ScoreClient;

class SwingSwingKK extends AbstractScriptedStageState
{
	private static inline var END_TIME_FADE:Int = 138315;
	private static inline var END_TIME_SWAP:Int = END_TIME_FADE + 3000;

	private var token:String = null;

	public function new()
	{
		super(AssetPaths.swing_swing__ogg, AssetPaths.swing_swing_kk_normal__txt, END_TIME_FADE, END_TIME_SWAP);
	}

	override function create()
	{
		super.create();

		ScoreClient.getToken(function(t)
		{
			token = t;
		});
	}

	private function onStageEnd()
	{
		FlxG.switchState(new EndState(score, token));
	}
}
