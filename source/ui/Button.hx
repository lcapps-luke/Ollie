package ui;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Button extends BasicButton
{
	public static inline var PADDING:Float = 20;

	public function new(spr:FlxSprite, callback:Void->Void)
	{
		super(spr, callback);

		labelOffsets[0].set(PADDING, PADDING);
		labelOffsets[1].set(PADDING, PADDING);
		labelOffsets[2].set(PADDING, PADDING);
	}

	override function makeButtonGraphic()
	{
		var width = Math.ceil(this.label.width + PADDING * 2);
		var height = Math.ceil(this.label.height + PADDING * 2);

		makeGraphic(width, height, FlxColor.TRANSPARENT, true);
		FlxSpriteUtil.drawRect(this, 0, 0, width, height, FlxColor.TRANSPARENT, {
			thickness: 20,
			color: FlxColor.WHITE
		});
	}
}
