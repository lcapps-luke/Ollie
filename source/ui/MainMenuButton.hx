package ui;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.addons.ui.FlxClickArea;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MainMenuButton extends FlxTypedGroup<FlxObject>
{
	private static inline var WOBBLE_SPEED:Float = 2.5;
	private static inline var WOBBLE_DIST:Float = 10;

	private var region:FlxClickArea;
	private var label:FlxText;
	private var extra:FlxText;

	private var wobblePhase:Float = FlxG.random.float(0, Math.PI);
	private var spriteY:Float = 0;

	private var focusEffect:FlxEffectSprite;

	public function new(spr:FlxGraphicAsset, name:String, x:Float, y:Float, callback:Void->Void)
	{
		super();
		spriteY = y;

		var sprite = new FlxSprite(x, y, spr);
		focusEffect = new FlxEffectSprite(sprite, [new FlxOutlineEffect(NORMAL, FlxColor.WHITE, 5)]);
		focusEffect.setPosition(x, y);
		add(focusEffect);

		label = new FlxText();
		label.setFormat(AssetPaths.PermanentMarker__ttf, 30, 0xff000000);
		label.text = name;
		label.x = x + sprite.width / 2 - label.width / 2;
		label.y = y - label.height - 10;
		add(label);

		region = new FlxClickArea(x - 10, y - 50, sprite.width + 20, sprite.height + 90, callback);
		add(region);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		wobblePhase += elapsed * WOBBLE_SPEED;
		focusEffect.y = spriteY + FlxMath.fastSin(wobblePhase) * WOBBLE_DIST;

		focusEffect.effectsEnabled = region.status != FlxButton.NORMAL;
	}
}
