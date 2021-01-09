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
	var _buffer:Sprite;

	override public function new()
	{
		super(0);
	}

	override function create()
	{
		_buffer = new Sprite();
		addChild(_buffer);

		_width = Std.int(Lib.current.stage.stageWidth);
		_height = Std.int(Lib.current.stage.stageHeight);

		var bg = createBitmap(BG, function(bg:Bitmap)
		{
			bg.width = _width;
			bg.height = _height;
		});

		_buffer.addChild(bg);

		super.create();
	}

	override function destroy()
	{
		if (_buffer != null)
		{
			removeChild(_buffer);
		}
		_buffer = null;

		super.destroy();
	}

	override function update(Percent:Float)
	{
		super.update(Percent);
	}
}
