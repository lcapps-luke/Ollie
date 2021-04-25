package ui;

import flixel.text.FlxText;
import flixel.util.FlxColor;

class BasicTextButton extends BasicButton
{
	private var txt:FlxText;

	public function new(text:String, textSize:Int, callback:Void->Void, colour:FlxColor = FlxColor.WHITE)
	{
		txt = new FlxText(0, 0, 0, text);
		txt.setFormat(AssetPaths.PermanentMarker__ttf, textSize, colour);
		super(txt, callback);
	}
}
