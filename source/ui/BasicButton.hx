package ui;

import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class BasicButton extends FlxTypedButton<FlxSprite>
{
	public var normalAlpha:Float = 0.8;

	public function new(spr:FlxSprite, callback:Void->Void)
	{
		super(0, 0, callback);
		this.label = spr;
		labelAlphas = [1, 1, 1];

		makeButtonGraphic();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		this.alpha = this.status == FlxButton.NORMAL ? normalAlpha : 1;
	}

	private function makeButtonGraphic()
	{
		makeGraphic(Math.ceil(this.label.width), Math.ceil(this.label.height), FlxColor.TRANSPARENT);
	}

	override function loadDefaultGraphic()
	{
		// remove default behaviour
	}
}
