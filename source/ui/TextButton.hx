package ui;

import flixel.text.FlxText;

class TextButton extends Button
{
	private var txt:FlxText;

	public function new(text:String, textSize:Int, callback:Void->Void)
	{
		txt = new FlxText(0, 0, 0, text, textSize);
		super(txt, callback);
	}
}
