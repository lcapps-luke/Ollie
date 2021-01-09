package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;
import script.Cue;
import script.Script;

class PlayState extends AbstractGraveyardState
{
	private var target:Array<Target>;

	private var cues:Array<Cue> = [];
	private var nextTimeIndex = 0;

	private var progressBar:FlxSprite;
	private var showUdin = false;

	override public function create()
	{
		super.create();

		// TODO load sprites and masks
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
		progressBar.angle = -1.45;
		add(progressBar);

		// adjust times
		cues = Script.load(-Std.int(Target.SHOW_DURATION * 1000));
		trace(cues);

		// TODO start countdown

		// FlxG.sound.muted = true;
		FlxG.sound.playMusic(AssetPaths.swing_swing__ogg, 1, false);
	}

	private inline function loadTargetMaskPair(tgtX:Float, tgtY:Float, mask:String, mskX:Float, mskY:Float)
	{
		var t = new Target(tgtX, tgtY);
		add(t);
		target.push(t);

		var m = new FlxSprite(mskX, mskY);
		m.loadGraphic(mask);
		add(m);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
		{
			trace(FlxG.sound.music.time);
		}

		var cue = nextTimeIndex < cues.length ? cues[nextTimeIndex] : null;
		if (cue != null && FlxG.sound.music.time >= cue.time)
		{
			nextTimeIndex++;

			var txtIdx = [0, 1, 2, 3, 4, 5];
			FlxG.random.shuffle(txtIdx);

			if (cue.ollie > 0)
			{
				for (i in txtIdx)
				{
					if (!target[i].isShowing())
					{
						target[i].show(0.5, true, FlxG.random.int(0, 4));
						break;
					}
				}
			}

			if (cue.udin > 0)
			{
				for (i in txtIdx)
				{
					if (!target[i].isShowing())
					{
						target[i].show(0.5, false);
						break;
					}
				}
			}
		}

		progressBar.scale.set(FlxG.sound.music.time / FlxG.sound.music.length, 1);
	}
}
