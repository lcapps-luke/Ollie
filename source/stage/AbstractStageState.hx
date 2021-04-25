package stage;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

abstract class AbstractStageState extends AbstractGraveyardState
{
	private var progressBar:FlxSprite;
	private var countdownText:FlxText;

	private var end:Bool = false;

	private var track:String;
	private var countdownEnd:Int;
	private var endFade:Int;
	private var endSwap:Int;

	public function new(track:String, countdownEnd:Int, endFade:Int, endSwap:Int)
	{
		super();

		this.track = track;
		this.countdownEnd = countdownEnd;
		this.endFade = endFade;
		this.endSwap = endSwap;
	}

	override public function create()
	{
		super.create();

		createBackground();

		progressBar = new FlxSprite();
		progressBar.makeGraphic(Layout.PROGRESS_WIDTH, Layout.PROGRESS_HEIGHT, Layout.PROGRESS_COLOUR);
		progressBar.origin.set(0, Layout.PROGRESS_HEIGHT / 2);
		progressBar.scale.set(0, 1);
		progressBar.x = Layout.PROGRESS_X;
		progressBar.y = Layout.PROGRESS_Y;
		progressBar.angle = Layout.BOARD_ANGLE;
		progressBar.antialiasing = true;
		add(progressBar);

		// start countdown
		countdownText = new FlxText();
		countdownText.setFormat(AssetPaths.PermanentMarker__ttf, Layout.COUNTDOWN_SIZE, 0xFFFF0000);
		countdownText.antialiasing = true;
		add(countdownText);

		function setCountdown(v:String)
		{
			countdownText.scale.set(1, 1);
			countdownText.angle = 0;
			countdownText.text = v;
			countdownText.x = Main.WIDTH / 2 - countdownText.width / 2;
			countdownText.y = Main.HEIGHT / 2 - countdownText.height / 2;
		}

		setCountdown("3");

		var zeroTime = countdownEnd / 1000;
		var timePerNumber = zeroTime / 3;

		var delay = timePerNumber / 2;
		FlxTween.tween(countdownText.scale, {x: 0, y: 0}, timePerNumber / 5, {startDelay: delay, onComplete: (t) -> setCountdown("2")});
		FlxTween.tween(countdownText, {angle: 360}, timePerNumber / 5, {startDelay: delay});

		delay += timePerNumber;
		FlxTween.tween(countdownText.scale, {x: 0, y: 0}, timePerNumber / 5, {startDelay: delay, onComplete: (t) -> setCountdown("1")});
		FlxTween.tween(countdownText, {angle: 360}, timePerNumber / 5, {startDelay: delay});

		delay += timePerNumber;
		FlxTween.tween(countdownText.scale, {x: 0, y: 0}, timePerNumber / 5, {startDelay: delay, onComplete: (t) -> countdownText.kill()});
		FlxTween.tween(countdownText, {angle: 360}, timePerNumber / 5, {startDelay: delay});

		FlxG.sound.playMusic(track, 1, false);

		function sndRetry()
		{
			FlxG.sound.destroy(true);
			FlxG.sound.playMusic(track, 1, false);
			FlxG.sound.music.onComplete = sndRetry;
		}
		FlxG.sound.music.onComplete = sndRetry;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.time > endFade && !end)
		{
			end = true;
			FlxG.sound.music.fadeOut(3, 0.25);
		}
		if (FlxG.sound.music.time > endSwap)
		{
			FlxG.sound.music.onComplete = null;
			onStageEnd();
		}

		progressBar.scale.set(Math.min(FlxG.sound.music.time / endFade, 1), 1);
	}

	private abstract function createBackground():Void;

	private abstract function onStageEnd():Void;
}
