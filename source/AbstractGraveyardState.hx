package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import ui.ToggleButton;

class AbstractGraveyardState extends FlxState
{
	override public function create()
	{
		super.create();

		var background = new FlxSprite();
		background.loadGraphic(AssetPaths.bg__jpg);
		add(background);

		var on = new FlxSprite();
		on.loadGraphic(AssetPaths.vol_on__png);

		var off = new FlxSprite();
		off.loadGraphic(AssetPaths.vol_off__png);

		var sound = new ToggleButton(on, off, onToggleSound);
		sound.setPosition(20, 20);
		sound.checked = !FlxG.sound.muted;
		add(sound);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	private function onToggleSound(on:Bool)
	{
		FlxG.sound.muted = !on;
	}
}
