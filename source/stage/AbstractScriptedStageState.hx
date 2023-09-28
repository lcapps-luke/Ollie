package stage;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxDestroyUtil;
import script.Cue;
import script.Script;
import ui.InteractionUtils;

abstract class AbstractScriptedStageState extends AbstractStageState
{
	private static inline var COMBO_MULTIPLIER:Float = 0.01;

	private var target:Array<Target>;
	private var hitDisplay:FlxTypedGroup<HitIndicator>;
	private var scoreText:FlxText;

	private var score = 0;
	private var combo = 0;

	private var cues:Array<Cue> = [];
	private var nextCue:Cue = null;
	private var nextCueIndex = 0;

	private var perfect = true;

	public function new(track:String, script:String, endFade:Int, endSwap:Int)
	{
		// load cues
		cues = Script.load(script, -Std.int(Target.SHOW_DURATION * 1000));
		nextCueIndex = 0;
		nextCue = cues[nextCueIndex];

		super(track, nextCue.time, endFade, endSwap);
	}

	override public function create()
	{
		super.create();

		scoreText = new FlxText(Layout.SCORE_X, Layout.SCORE_Y, Layout.SCORE_WIDTH, "0");
		scoreText.setFormat(AssetPaths.PermanentMarker__ttf, Layout.SCORE_SIZE, 0xFF000000);
		scoreText.angle = Layout.BOARD_ANGLE;
		scoreText.antialiasing = true;
		add(scoreText);
		updateScoreboard();

		hitDisplay = new FlxTypedGroup<HitIndicator>();
		add(hitDisplay);
	}

	private function createBackground()
	{
		// load sprites and masks
		target = new Array<Target>();
		loadTargetMaskPair(Layout.TGT_1_X, Layout.TGT_1_Y, AssetPaths.hm_1__png, Layout.MASK_1_X, Layout.MASK_1_Y);
		loadTargetMaskPair(Layout.TGT_2_X, Layout.TGT_2_Y, AssetPaths.hm_2__png, Layout.MASK_2_X, Layout.MASK_2_Y);
		loadTargetMaskPair(Layout.TGT_3_X, Layout.TGT_3_Y, AssetPaths.hm_3__png, Layout.MASK_3_X, Layout.MASK_3_Y);
		loadTargetMaskPair(Layout.TGT_4_X, Layout.TGT_4_Y, AssetPaths.hm_4__png, Layout.MASK_4_X, Layout.MASK_4_Y);
		loadTargetMaskPair(Layout.TGT_5_X, Layout.TGT_5_Y, AssetPaths.hm_5__png, Layout.MASK_5_X, Layout.MASK_5_Y);
		loadTargetMaskPair(Layout.TGT_6_X, Layout.TGT_6_Y, AssetPaths.hm_6__png, Layout.MASK_6_X, Layout.MASK_6_Y);
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
						target[i].show(nextCue.hold, true);
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
	}

	public function onTargetHit(good:Bool)
	{
		if (good)
		{
			combo++;
			FlxG.sound.play(AssetPaths.hit__wav);
		}
		else
		{
			combo = 0;
			FlxG.sound.play(AssetPaths.miss__wav);
			perfect = false;
		}

		var bonus = combo > 1 ? Math.floor(100 * (combo * COMBO_MULTIPLIER)) : 0;
		var incr = good ? (100 + bonus) : -100;

		score += incr;
		updateScoreboard();

		var ind = createHitIndicator();

		var point:FlxPoint = InteractionUtils.clickPoint();

		ind.score(point == null ? 0 : point.x, point == null ? 0 : point.y, incr);

		FlxDestroyUtil.put(point);
	}

	public function onTargetMiss(x:Float, y:Float)
	{
		var ind = createHitIndicator();
		ind.miss(x, y);

		combo = 0;
		updateScoreboard();

		perfect = false;
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

	private function onStageEnd()
	{
		if (!Target.PLUSH_SHOWN)
		{
			Target.PLUSH_CHANCE *= 4;
		}
		Target.PLUSH_SHOWN = false;
	}
}
