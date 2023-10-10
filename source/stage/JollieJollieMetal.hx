package stage;

import flixel.FlxG;
import score.ScoreClient;

class JollieJollieMetal extends AbstractScriptedStageState
{
	public static inline var LIBRARY = AssetPaths.LIB_MUSIC_METAL;
	public static inline var SCORE_BOARD:String = "ollie_metal";
	private static inline var END_TIME_FADE:Int = 161065;
	private static inline var END_TIME_SWAP:Int = END_TIME_FADE + 1000;

	private var token:String = null;

	public function new()
	{
		super(AssetPaths.makePath(LIBRARY, AssetPaths.jollie_jollie_metal__ogg), AssetPaths.jollie_jollie_metal__txt, END_TIME_FADE, END_TIME_SWAP);
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
