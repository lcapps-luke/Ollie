package;

import flixel.system.FlxBasePreloader;
import flixel.system.FlxPreloader;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

@:keep @:bitmap("assets/images/bg_l.jpg")
private class BG extends BitmapData {}

class Preloader extends FlxBasePreloader
{
	var buffer:Sprite;
	var bar:Bitmap;
	var barMask:Bitmap;
	var barScale:Float = 0;
	var maskStart:Float = 0;
	var maskScale:Float = 0;

	override public function new()
	{
		super();
	}

	override function create()
	{
		buffer = new Sprite();
		addChild(buffer);

		var xScale = Lib.current.stage.stageWidth / Main.WIDTH;
		var yScale = Lib.current.stage.stageHeight / Main.HEIGHT;

		_width = Std.int(Lib.current.stage.stageWidth);
		_height = Std.int(Lib.current.stage.stageHeight);

		var bg = createBitmap(BG, function(bg:Bitmap)
		{
			bg.width = _width;
			bg.height = _height;
		});

		buffer.addChild(bg);

		barScale = Layout.PROGRESS_WIDTH * xScale;
		maskScale = Layout.PROGRESS_X * xScale;
		maskStart = maskScale - barScale;

		barMask = new Bitmap(new BitmapData(Std.int(barScale), Std.int(70 * yScale), false));
		barMask.x = Layout.PROGRESS_X * xScale;
		barMask.y = 77 * yScale;
		buffer.addChild(barMask);

		bar = new Bitmap(new BitmapData(Std.int(barScale), Std.int(Layout.PROGRESS_HEIGHT * yScale), false, Layout.PROGRESS_COLOUR));
		bar.alpha = 0.75;
		bar.x = Layout.PROGRESS_X * xScale;
		bar.y = Layout.PROGRESS_Y * yScale;
		bar.rotation = Layout.BOARD_ANGLE;
		bar.mask = barMask;

		buffer.addChild(bar);

		super.create();
	}

	override function destroy()
	{
		if (buffer != null)
		{
			removeChild(buffer);
		}
		buffer = null;
		bar = null;
		barMask = null;

		super.destroy();
	}

	override function update(percent:Float)
	{
		super.update(percent);
		barMask.x = maskStart + maskScale * percent;
	}
}
