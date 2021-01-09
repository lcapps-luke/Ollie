package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import script.Cue;
import script.Script;

class PlayState extends AbstractGraveyardState
{
	private static inline var END_TIME_FADE:Int = 138315;
	private static inline var END_TIME_SWAP:Int = END_TIME_FADE + 3000;

	private var target:Array<Target>;

	private var cues:Array<Cue> = [];
	private var nextCue:Cue = null;
	private var nextCueIndex = 0;

	private var progressBar:FlxSprite;
	private var showUdin = false;

	private var score = 0;
	private var scoreText:FlxText;

	private var end:Bool = false;

	override public function create()
	{
		super.create();

		// load sprites and masks
		target = new Array<Target>();
		loadTargetMaskPair(Layout.TGT_1_X, Layout.TGT_1_Y, AssetPaths.hm_1__png, Layout.MASK_1_X, Layout.MASK_1_Y);
		loadTargetMaskPair(Layout.TGT_2_X, Layout.TGT_2_Y, AssetPaths.hm_2__png, Layout.MASK_2_X, Layout.MASK_2_Y);
		loadTargetMaskPair(Layout.TGT_3_X, Layout.TGT_3_Y, AssetPaths.hm_3__png, Layout.MASK_3_X, Layout.MASK_3_Y);
		loadTargetMaskPair(Layout.TGT_4_X, Layout.TGT_4_Y, AssetPaths.hm_4__png, Layout.MASK_4_X, Layout.MASK_4_Y);
		loadTargetMaskPair(Layout.TGT_5_X, Layout.TGT_5_Y, AssetPaths.hm_5__png, Layout.MASK_5_X, Layout.MASK_5_Y);
		loadTargetMaskPair(Layout.TGT_6_X, Layout.TGT_6_Y, AssetPaths.hm_6__png, Layout.MASK_6_X, Layout.MASK_6_Y);

		progressBar = new FlxSprite();
		progressBar.makeGraphic(714, 46, 0xC84C2449);
		progressBar.origin.set(0, 23);
		progressBar.scale.set(0, 1);
		progressBar.x = 639;
		progressBar.y = 99;
		progressBar.angle = Layout.BOARD_ANGLE;
		progressBar.antialiasing = true;
		add(progressBar);

		scoreText = new FlxText(Layout.SCORE_X, Layout.SCORE_Y, Layout.SCORE_WIDTH, "0");
		scoreText.setFormat(AssetPaths.PermanentMarker__ttf, Layout.SCORE_SIZE, 0xFF000000);
		scoreText.angle = Layout.BOARD_ANGLE;
		scoreText.antialiasing = true;
		add(scoreText);

		// load cues
		cues = Script.load(-Std.int(Target.SHOW_DURATION * 1000));
		nextCueIndex = 0;
		nextCue = cues[nextCueIndex];

		// TODO start countdown

		// FlxG.sound.muted = true;
		FlxG.sound.playMusic(AssetPaths.swing_swing__ogg, 1, false);
	}

	private inline function loadTargetMaskPair(tgtX:Float, tgtY:Float, mask:String, mskX:Float, mskY:Float)
	{
		var t = new Target(tgtX, tgtY, onTargetHit);
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
			FlxG.switchState(new EndState(score));
		}

		progressBar.scale.set(Math.min(FlxG.sound.music.time / END_TIME_FADE, 1), 1);
	}

	public function onTargetHit(good:Bool)
	{
		score += good ? 100 : -100;
		scoreText.text = Std.string(score);
	}
}
