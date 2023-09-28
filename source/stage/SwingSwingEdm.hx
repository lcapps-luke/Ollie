package stage;

import flixel.FlxG;
import score.ScoreClient;

class SwingSwingEdm extends AbstractScriptedStageState
{
	public static inline var SCORE_BOARD:String = "ollie_edm";
	private static inline var END_TIME_FADE:Int = 173170;
	private static inline var END_TIME_SWAP:Int = END_TIME_FADE + 1000;

	private var token:String = null;

	public function new()
	{
		super(AssetPaths.swing_swing_edm__ogg, AssetPaths.swing_swing_edm__txt, END_TIME_FADE, END_TIME_SWAP);
	}

	override function create()
	{
		ScoreClient.getToken(SCORE_BOARD, function(t)
		{
			token = t;
		});

		super.create();
	}

	override private function onStageEnd()
	{
		super.onStageEnd();
		Main.updateStageData(SCORE_BOARD, this.perfect, score);
		FlxG.switchState(new EndState(SCORE_BOARD, score, token));
	}
}
