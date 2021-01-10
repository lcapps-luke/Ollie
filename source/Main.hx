package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.util.FlxSave;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static inline var WIDTH:Int = 1920;
	public static inline var HEIGHT:Int = 1080;
	public static inline var NAME_MAX_LENGTH:Int = 15;
	public static var SAVE(default, null):FlxSave;

	public function new()
	{
		super();

		SAVE = new FlxSave();
		SAVE.bind("lc.ollie.config");

		initGame();

		#if !FLX_NO_MOUSE
		FlxG.mouse.useSystemCursor = true;
		#end
	}

	private function initGame()
	{
		addChild(new FlxGame(WIDTH, HEIGHT, MenuState, 1, 60, 60, true));
	}
}
