package ui;

import flixel.FlxSprite;

using flixel.util.FlxSpriteUtil;

class ToggleButton extends Button
{
	public var checked(get, set):Bool;

	private var off:FlxSprite;
	private var toggleCallback:Bool->Void;

	public function new(sprOn:FlxSprite, sprOff:FlxSprite, toggleCallback:Bool->Void)
	{
		super(sprOn, toggle);

		this.toggleCallback = toggleCallback;

		off = sprOff;
		off.x = Button.PADDING;
		off.y = Button.PADDING;
		off.visible = false;
		add(off);
	}

	public function toggle()
	{
		checked = !checked;
		toggleCallback(checked);
	}

	private function get_checked():Bool
	{
		return spr.visible;
	}

	private function set_checked(v:Bool):Bool
	{
		off.visible = !v;
		return spr.visible = v;
	}
}
