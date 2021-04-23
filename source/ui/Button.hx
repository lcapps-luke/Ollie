package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Button extends BasicButton
{
	public static inline var PADDING:Float = 20;

	public function new(spr:FlxSprite, callback:Void->Void)
	{
		super(spr, callback);

		spr.x = PADDING;
		spr.y = PADDING;

		var back = new FlxSprite();
		back.makeGraphic(Math.ceil(spr.width + PADDING * 2), Math.ceil(spr.height + PADDING * 2), FlxColor.TRANSPARENT, true);
		add(back);

		back.drawRect(0, 0, back.width, back.height, FlxColor.TRANSPARENT, {
			thickness: 20,
			color: FlxColor.WHITE
		});
	}
}
