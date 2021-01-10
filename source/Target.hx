package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Target extends FlxSpriteGroup
{
	public static var SHOW_DURATION = 0.3;

	private static var OLLIE_ASSETS = [
		AssetPaths.spr_oli_1__png,
		AssetPaths.spr_oli_2__png,
		AssetPaths.spr_oli_3__png,
		AssetPaths.spr_oli_4__png,
		AssetPaths.spr_oli_5__png
	];

	private var udin:FlxSprite;
	private var ollie:Array<FlxSprite>;
	private var hitOllie:FlxSprite;

	private var isOllie:Bool = true;

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
		add(hitOllie);
	}

	private function killAll()
	{
		udin.kill();
		for (o in ollie)
		{
			o.kill();
		}
		hitOllie.kill();
	}

	public function show(hold:Float, good:Bool, index:Int = -1)
	{
		killAll();
		hit = false;

		if (good && index != -1)
		{
			ollie[index].revive();
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

		if (isShowing() && FlxG.mouse.justPressed && !hit)
		{
			var point = FlxG.mouse.getPosition();
			if (this.getHitbox().containsPoint(point) && point.y < startY)
			{
				hit = true;
				hitCallback(isOllie);

				holdTimer = 0.001;

				if (isOllie)
				{
					killAll();
					hitOllie.revive();
				}
			}
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
