package;

import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class HitIndicator extends FlxText
{
	private var ttl:Float = 0;

	public function new()
	{
		super();
		setFormat(AssetPaths.PermanentMarker__ttf, 50);
	}

	public function score(sx:Float, sy:Float, score:Int)
	{
		if (score > 0)
		{
			this.color = 0xFFFF0000;
		}
		else
		{
			this.color = 0xFFFF00FF;
		}

		this.text = (score > 0 ? "+" : "") + Std.string(score);

		x = sx - this.width / 2;
		y = sy;

		animate();
	}

	public function miss(sx:Float, sy:Float)
	{
		this.color = 0xFFFF00FF;
		this.text = "miss";

		x = sx - this.width / 2;
		y = sy;

		animate();
	}

	private function animate()
	{
		alpha = 1;

		FlxTween.tween(this, {y: y - 100}, 0.8, {
			ease: FlxEase.expoOut,
			onComplete: (t:FlxTween) -> FlxTween.tween(this, {alpha: 0}, 0.2, {onComplete: (t:FlxTween) -> this.kill()})
		});
	}
}
