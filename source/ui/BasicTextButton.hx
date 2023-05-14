package ui;

import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class BasicTextButton extends FlxButton
{
	public function new(text:String, textSize:Int, callback:Void->Void, colour:FlxColor = FlxColor.WHITE)
	{
		super(0, 0, text, callback);
		this.label.setFormat(AssetPaths.PermanentMarker__ttf, textSize, colour);

		makeGraphic(Math.ceil(this.label.width), Math.ceil(this.label.height), FlxColor.TRANSPARENT);
	}

	override function loadDefaultGraphic()
	{
		// super.loadDefaultGraphic();
	}
}
