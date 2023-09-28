package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;
import ui.InteractionUtils;

class Target extends FlxSpriteGroup
{
	public static inline var SHOW_DURATION = 0.3;
	public static inline var INITIAL_PLUSH_CHANCE = 0.1;

	public static var PLUSH_CHANCE = INITIAL_PLUSH_CHANCE;
	public static var PLUSH_SHOWN = false;

	private static var OLLIE_ASSETS = [
		AssetPaths.spr_oli_1__png,
		AssetPaths.spr_oli_2__png,
		AssetPaths.spr_oli_3__png,
		AssetPaths.spr_oli_4__png,
		AssetPaths.spr_oli_5__png,
		AssetPaths.spr_oli_6__png
	];

	private var udin:FlxSprite;
	private var ollie:Array<FlxSprite>;
	private var hitOllie:FlxSprite;
	private var hitOlliePlush:FlxSprite;

	private var isOllie:Bool = true;
	private var isPlush:Bool = true;

	private var holdTimer:Float = 0;
	private var startY:Float = 0;

	private var hit:Bool = false;
	private var hitCallback:Bool->Void;
	private var missCallback:Float->Float->Void;

	public function new(x:Float, y:Float, hitCallback:Bool->Void, missCallback:Float->Float->Void)
	{
		super(x, y);
		this.hitCallback = hitCallback;
		this.missCallback = missCallback;

		startY = y;

		udin = new FlxSprite();
		udin.loadGraphic(AssetPaths.udin__png);
		udin.kill();
		add(udin);

		ollie = new Array<FlxSprite>();
		for (i in OLLIE_ASSETS)
		{
			var o = new FlxSprite();
			o.loadGraphic(i);
			ollie.push(o);

			o.kill();
			add(o);
		}

		hitOllie = new FlxSprite();
		hitOllie.loadGraphic(AssetPaths.spr_oli_h__png);
		hitOllie.kill();
		add(hitOllie);

		hitOlliePlush = new FlxSprite();
		hitOlliePlush.loadGraphic(AssetPaths.spr_oli_h2__png);
		hitOlliePlush.kill();
		add(hitOlliePlush);
	}

	private function killAll()
	{
		udin.kill();
		for (o in ollie)
		{
			o.kill();
		}
		hitOllie.kill();
		hitOlliePlush.kill();
	}

	public function show(hold:Float, good:Bool)
	{
		killAll();
		hit = false;

		if (good)
		{
			isPlush = FlxG.random.bool(PLUSH_CHANCE);
			ollie[isPlush ? 5 : FlxG.random.int(0, 4)].revive();
			if (isPlush)
			{
				PLUSH_SHOWN = true;
				PLUSH_CHANCE = INITIAL_PLUSH_CHANCE;
			}
		}

		if (!good)
		{
			udin.revive();
		}

		isOllie = good;

		holdTimer = hold + SHOW_DURATION;

		FlxTween.tween(this, {y: startY - height}, SHOW_DURATION, {ease: FlxEase.sineIn});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (holdTimer > 0)
		{
			holdTimer -= elapsed;
			if (holdTimer <= 0)
			{
				FlxTween.tween(this, {y: startY}, SHOW_DURATION, {ease: FlxEase.sineOut, onComplete: onHidden});
			}
		}

		if (isShowing() && !hit && InteractionUtils.justClicked())
		{
			var point = InteractionUtils.clickPoint();

			if (this.getHitbox().containsPoint(point) && point.y < startY)
			{
				hit = true;
				hitCallback(isOllie);

				holdTimer = 0.001;

				if (isOllie)
				{
					killAll();

					if (isPlush)
					{
						hitOlliePlush.revive();
					}
					else
					{
						hitOllie.revive();
					}
				}
			}

			FlxDestroyUtil.put(point);
		}
	}

	private function onHidden(tween:FlxTween)
	{
		if (!hit && isOllie)
		{
			missCallback(x + width / 2, y);
		}
	}

	public function isShowing():Bool
	{
		return (holdTimer > 0 || y < startY);
	}
}
