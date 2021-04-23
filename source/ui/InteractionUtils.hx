package ui;

import flixel.FlxG;
import flixel.math.FlxRect;

class InteractionUtils
{
	public static function wasClicked(hitbox:FlxRect):Interaction
	{
		var over = false;

		#if !FLX_NO_MOUSE
		over = hitbox.containsPoint(FlxG.mouse.getPosition());

		if (FlxG.mouse.justReleased && over)
		{
			return CLICK;
		}
		#end

		#if !FLX_NO_TOUCH
		var touch = FlxG.touches.getFirst();

		if (touch != null && touch.justReleased && hitbox.containsPoint(touch.getPosition()))
		{
			return CLICK;
		}
		#end

		return over ? OVER : NONE;
	}
}

enum Interaction
{
	OVER;
	CLICK;
	NONE;
}
