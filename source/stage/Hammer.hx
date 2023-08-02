package stage;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import ui.InteractionUtils;

class Hammer extends FlxSprite
{
	private var point = new FlxPoint();

	public function new()
	{
		super();
		loadGraphic(AssetPaths.hammer__png, true, 466, 428);
		offset.set(81, 341);

		this.animation.add("up", [0], 12, false);
		this.animation.add("down", [1, 2], 12, false);
		this.animation.play("up");
	}

	override function update(elapsed:Float)
	{
		point = InteractionUtils.clickPoint(point);
		this.x = point.x;
		this.y = point.y;

		if (!InteractionUtils.isHeld())
		{
			this.animation.play("up");
		}

		if (InteractionUtils.justClicked())
		{
			this.animation.play("down", true);
		}

		super.update(elapsed);
	}
}
