package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxAssets;
import ui.TextButton;

class MenuState extends AbstractGraveyardState
{
	override function create()
	{
		super.create();

		var playButton = new TextButton("Play", 48, onPlayClicked);
		playButton.x = Main.WIDTH / 2 - playButton.width / 2;
		playButton.y = Main.HEIGHT / 2 - playButton.height / 2;
		add(playButton);
	}

	private function onPlayClicked()
	{
		FlxG.switchState(new PlayState());
	}
}
