package ui;

import flixel.FlxSprite;

using flixel.util.FlxSpriteUtil;

class ToggleButton extends Button
{
	public var checked(default, set):Bool = true;

	private var on:FlxSprite;
	private var off:FlxSprite;
	private var toggleCallback:Bool->Void;

	public function new(sprOn:FlxSprite, sprOff:FlxSprite, toggleCallback:Bool->Void)
	{
		super(sprOn, toggle);
		this.toggleCallback = toggleCallback;

		on = sprOn;
		off = sprOff;
	}

	public function toggle()
	{
		checked = !checked;
		toggleCallback(checked);
	}

	private function set_checked(v:Bool):Bool
	{
		this.label = v ? on : off;
		return checked = v;
	}
}
