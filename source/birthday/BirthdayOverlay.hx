package birthday;

import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class BirthdayOverlay extends FlxSpriteGroup
{
	private static inline var PART_MAX_SIZE:Float = 12;

	public function new(state:FlxState)
	{
		super();

		var text:FlxText = new FlxText(0, 0, 0, "HAPPY BIRTHDAY OLLIE!");
		text.setFormat(AssetPaths.PermanentMarker__ttf, 60, 0xFF0000, null, OUTLINE, 0xFFFFA600);
		text.borderSize = 3;
		text.x = Main.WIDTH / 2 - text.width / 2 + 35;
		text.y = 50;
		add(text);

		var emitter = new FlxEmitter(0, -PART_MAX_SIZE, 0);
		emitter.width = Main.WIDTH;
		emitter.makeParticles(5, 5, FlxColor.WHITE, 200);
		emitter.launchAngle.set(90);
		emitter.angularVelocity.set(-180, 180, -90, 90);
		emitter.scale.set(5, 5, 8, 8);
		emitter.speed.set(100, 200);
		emitter.lifespan.set(Main.HEIGHT / 100);
		emitter.color.set(FlxColor.BLACK, FlxColor.WHITE);
		emitter.start(false, 0.1);

		state.add(emitter);
	}
}
