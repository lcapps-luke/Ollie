package;

import flixel.text.FlxText;

class EndState extends AbstractGraveyardState
{
	private var score:Int;

	public function new(score:Int)
	{
		super();
		this.score = score;
	}

	override function create()
	{
		super.create();

		var scoreText = new FlxText(Layout.SCORE_X, Layout.SCORE_Y, Layout.SCORE_WIDTH, 'Score: $score');
		scoreText.setFormat(AssetPaths.PermanentMarker__ttf, Layout.SCORE_SIZE, 0xFF000000);
		scoreText.angle = Layout.BOARD_ANGLE;
		scoreText.antialiasing = true;
		add(scoreText);
	}
}
