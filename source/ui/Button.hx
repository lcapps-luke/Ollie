package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Button extends FlxSpriteGroup
{
	public static inline var PADDING:Float = 20;

	private var callback:Void->Void;
	private var spr:FlxSprite;

	public function new(spr:FlxSprite, callback:Void->Void)
	{
		super();

		this.callback = callback;

		this.spr = spr;
		spr.x = PADDING;
		spr.y = PADDING;
		add(spr);

		var back = new FlxSprite();
		back.makeGraphic(Math.ceil(spr.width + PADDING * 2), Math.ceil(spr.height + PADDING * 2), FlxColor.TRANSPARENT, true);
		add(back);

		back.drawRect(0, 0, back.width, back.height, FlxColor.TRANSPARENT, {
			thickness: 20,
			color: FlxColor.WHITE
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var over:Bool = this.getHitbox().containsPoint(FlxG.mouse.getPosition());

		this.alpha = over ? 1 : 0.8;

		if (FlxG.mouse.justReleased && over)
		{
			callback();
		}
	}
}
