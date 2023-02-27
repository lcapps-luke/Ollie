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

		#if !FLX_NO_TOUCH
		var touch = FlxG.touches.getFirst();
		if (touch != null)
		{
			var pos = touch.getPosition();
			over = hitbox.containsPoint(pos);
			FlxDestroyUtil.put(pos);

			if (touch.justReleased && over)
			{
				return CLICK;
			}
		}
		#end

		#if !FLX_NO_MOUSE
		var pos = FlxG.mouse.getPosition();
		over = hitbox.containsPoint(pos);
		FlxDestroyUtil.put(pos);

		if (FlxG.mouse.justReleased && over)
		{
			return CLICK;
		}
		#end

		return over ? OVER : NONE;
	}

	public static function justClicked():Bool
	{
		#if !FLX_NO_TOUCH
		if (FlxG.touches.justStarted().length > 0)
		{
			return true;
		}
		#end

		#if !FLX_NO_MOUSE
		if (FlxG.mouse.justPressed)
		{
			return true;
		}
		#end

		return false;
	}

	public static function clickPoint():FlxPoint
	{
		#if !FLX_NO_TOUCH
		var touch = FlxG.touches.getFirst();
		if (touch != null)
		{
			return touch.getPosition();
		}
		#end

		#if !FLX_NO_MOUSE
		return FlxG.mouse.getPosition();
		#end

		return FlxPoint.get();
	}

	public static function isHeld():Bool
	{
		#if !FLX_NO_TOUCH
		if (FlxG.touches.list.length > 0)
		{
			return true;
		}
		#end

		#if !FLX_NO_MOUSE
		if (FlxG.mouse.pressed)
		{
			return true;
		}
		#end

		return false;
	}
}

enum Interaction
{
	OVER;
	CLICK;
	NONE;
}
