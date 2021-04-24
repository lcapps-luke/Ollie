package ui;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxDestroyUtil;

class InteractionUtils
{
	public static function wasClicked(hitbox:FlxRect):Interaction
	{
		var over = false;

		#if !FLX_NO_MOUSE
		var pos = FlxG.mouse.getPosition();
		over = hitbox.containsPoint(pos);
		FlxDestroyUtil.put(pos);

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

	public static function justClicked():Bool
	{
		#if !FLX_NO_MOUSE
		if (FlxG.mouse.justPressed)
		{
			return true;
		}
		#end

		#if !FLX_NO_TOUCH
		if (FlxG.touches.justStarted().length > 0)
		{
			return true;
		}
		#end

		return false;
	}

	public static function clickPoint():FlxPoint
	{
		#if !FLX_NO_MOUSE
		return FlxG.mouse.getPosition();
		#end

		#if !FLX_NO_TOUCH
		var touch = FlxG.touches.justStarted();
		if (touch.length > 0)
		{
			return touch[0].getPosition();
		}
		#end

		return null;
	}
}

enum Interaction
{
	OVER;
	CLICK;
	NONE;
}
