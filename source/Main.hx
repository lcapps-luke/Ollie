package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static inline var WIDTH:Int = 1920;
	public static inline var HEIGHT:Int = 1080;

	public function new()
	{
		super();

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
