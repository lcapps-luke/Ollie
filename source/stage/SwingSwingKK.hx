package stage;

import flixel.FlxG;
import score.ScoreClient;

class SwingSwingKK extends AbstractScriptedStageState
{
	public static inline var SCORE_BOARD:String = "ollie";
	private static inline var END_TIME_FADE:Int = 138315;
	private static inline var END_TIME_SWAP:Int = END_TIME_FADE + 3000;

	private var token:String = null;

	public function new()
	{
		super(AssetPaths.swing_swing__ogg, AssetPaths.swing_swing_kk_normal__txt, END_TIME_FADE, END_TIME_SWAP);
	}

	override function create()
	{
		ScoreClient.getToken(SCORE_BOARD, function(t)
		{
			token = t;
		});

		super.create();
	}

	private function onStageEnd()
	{
		Main.updateStageData(SCORE_BOARD, this.perfect);
		FlxG.switchState(new EndState(SCORE_BOARD, score, token));
	}
}
