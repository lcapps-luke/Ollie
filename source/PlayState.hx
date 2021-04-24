package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import score.ScoreClient;
import script.Cue;
import script.Script;

class PlayState extends AbstractGraveyardState
{
	private static inline var END_TIME_FADE:Int = 138315;
	private static inline var END_TIME_SWAP:Int = END_TIME_FADE + 3000;
	private static inline var COMBO_MULTIPLIER:Float = 0.01;

	private var target:Array<Target>;
	private var progressBar:FlxSprite;
	private var hitDisplay:FlxTypedGroup<HitIndicator>;
	private var scoreText:FlxText;
	private var countdownText:FlxText;

	private var score = 0;
	private var combo = 0;

	private var cues:Array<Cue> = [];
	private var nextCue:Cue = null;
	private var nextCueIndex = 0;

	private var end:Bool = false;
	private var token:String = null;

	override public function create()
	{
		super.create();

		ScoreClient.getToken(function(t)
		{
			token = t;
		});

		// load sprites and masks
		target = new Array<Target>();
		loadTargetMaskPair(Layout.TGT_1_X, Layout.TGT_1_Y, AssetPaths.hm_1__png, Layout.MASK_1_X, Layout.MASK_1_Y);
		loadTargetMaskPair(Layout.TGT_2_X, Layout.TGT_2_Y, AssetPaths.hm_2__png, Layout.MASK_2_X, Layout.MASK_2_Y);
		loadTargetMaskPair(Layout.TGT_3_X, Layout.TGT_3_Y, AssetPaths.hm_3__png, Layout.MASK_3_X, Layout.MASK_3_Y);
		loadTargetMaskPair(Layout.TGT_4_X, Layout.TGT_4_Y, AssetPaths.hm_4__png, Layout.MASK_4_X, Layout.MASK_4_Y);
		loadTargetMaskPair(Layout.TGT_5_X, Layout.TGT_5_Y, AssetPaths.hm_5__png, Layout.MASK_5_X, Layout.MASK_5_Y);
		loadTargetMaskPair(Layout.TGT_6_X, Layout.TGT_6_Y, AssetPaths.hm_6__png, Layout.MASK_6_X, Layout.MASK_6_Y);

		progressBar = new FlxSprite();
		progressBar.makeGraphic(Layout.PROGRESS_WIDTH, Layout.PROGRESS_HEIGHT, Layout.PROGRESS_COLOUR);
		progressBar.origin.set(0, Layout.PROGRESS_HEIGHT / 2);
		progressBar.scale.set(0, 1);
		progressBar.x = Layout.PROGRESS_X;
		progressBar.y = Layout.PROGRESS_Y;
		progressBar.angle = Layout.BOARD_ANGLE;
		progressBar.antialiasing = true;
		add(progressBar);

		scoreText = new FlxText(Layout.SCORE_X, Layout.SCORE_Y, Layout.SCORE_WIDTH, "0");
		scoreText.setFormat(AssetPaths.PermanentMarker__ttf, Layout.SCORE_SIZE, 0xFF000000);
		scoreText.angle = Layout.BOARD_ANGLE;
		scoreText.antialiasing = true;
		add(scoreText);
		updateScoreboard();

		hitDisplay = new FlxTypedGroup<HitIndicator>();
		add(hitDisplay);

		// load cues
		cues = Script.load(AssetPaths.swing_swing_kk_normal__txt, -Std.int(Target.SHOW_DURATION * 1000));
		nextCueIndex = 0;
		nextCue = cues[nextCueIndex];

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

		var zeroTime = nextCue.time / 1000;
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

		FlxG.sound.playMusic(AssetPaths.swing_swing__ogg, 1, false);
	}

	private inline function loadTargetMaskPair(tgtX:Float, tgtY:Float, mask:String, mskX:Float, mskY:Float)
	{
		var t = new Target(tgtX, tgtY, onTargetHit, onTargetMiss);
		add(t);
		target.push(t);

		var m = new FlxSprite(mskX, mskY);
		m.loadGraphic(mask);
		add(m);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (nextCue != null && FlxG.sound.music.time >= nextCue.time)
		{
			var txtIdx = [0, 1, 2, 3, 4, 5];
			FlxG.random.shuffle(txtIdx);

			var count = 0;

			for (i in txtIdx)
			{
				if (!target[i].isShowing())
				{
					if (count < nextCue.ollie)
					{
						target[i].show(nextCue.hold, true, FlxG.random.int(0, 4));
					}
					else if (count < nextCue.ollie + nextCue.udin)
					{
						target[i].show(nextCue.hold, false);
					}
					else
					{
						break;
					}

					count++;
				}
			}

			nextCueIndex++;
			if (nextCueIndex < cues.length)
			{
				nextCue = cues[nextCueIndex];
			}
			else
			{
				nextCue = null;
			}
		}

		if (FlxG.sound.music.time > END_TIME_FADE && !end)
		{
			end = true;
			FlxG.sound.music.fadeOut(3, 0.25);
		}
		if (FlxG.sound.music.time > END_TIME_SWAP)
		{
			FlxG.switchState(new EndState(score, token));
		}

		progressBar.scale.set(Math.min(FlxG.sound.music.time / END_TIME_FADE, 1), 1);
	}

	public function onTargetHit(good:Bool)
	{
		if (!good)
		{
			combo = 0;
		}
		else
		{
			combo++;
		}

		var bonus = combo > 1 ? Math.floor(100 * (combo * COMBO_MULTIPLIER)) : 0;
		var incr = good ? (100 + bonus) : -100;

		score += incr;
		updateScoreboard();

		var ind = createHitIndicator();

		var point:FlxPoint = null;
		#if !FLX_NO_MOUSE
		point = FlxG.mouse.getPosition();
		#end

		#if !FLX_NO_TOUCH
		var touch = FlxG.touches.getFirst();
		if (touch != null)
		{
			point = touch.getPosition();
		}
		else
		{
			point = FlxPoint.get();
		}
		#end

		ind.score(point.x, point.y, incr);
	}

	public function onTargetMiss(x:Float, y:Float)
	{
		var ind = createHitIndicator();
		ind.miss(x, y);

		combo = 0;
		updateScoreboard();
	}

	private function updateScoreboard()
	{
		var dc = combo > 1 ? combo : 0;
		scoreText.text = 'Score: $score (combo x$dc)';
	}

	public function createHitIndicator():HitIndicator
	{
		var indicator = hitDisplay.recycle(HitIndicator, HitIndicator.new);
		return indicator;
	}
}
