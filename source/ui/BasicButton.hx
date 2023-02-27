package ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class BasicButton extends FlxSpriteGroup
{
	private var callback:Void->Void;
	private var spr:FlxSprite;

	public function new(spr:FlxSprite, callback:Void->Void)
	{
		super();

		this.callback = callback;

		this.spr = spr;
		add(spr);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var interact = InteractionUtils.wasClicked(this.getHitbox());
		this.alpha = interact == OVER ? 1 : 0.8;

		if (interact == CLICK)
		{
			callback();
		}
	}
}
