package;

import flixel.FlxSprite;
import flixel.FlxState;

class AbstractGraveyardState extends FlxState
{
	override public function create()
	{
		super.create();

		var background = new FlxSprite();
		background.loadGraphic(AssetPaths.bg__jpg);
		add(background);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
