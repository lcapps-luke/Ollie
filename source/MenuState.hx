package;

import credits.CreditsSubState;
import flixel.FlxG;
import flixel.text.FlxText;
import score.Score;
import score.ScoreClient;
import stage.SwingSwingKK;
import ui.Button;
import ui.ScoreLine;
import ui.TextButton;
#if debug
import stage.DevStage;
#end

class MenuState extends AbstractGraveyardState
{
	private var scoreLines:List<ScoreLine>;
	private var showScores:Button;

	override function create()
	{
		super.create();

		var playButton = new TextButton("Play", 60, onPlayClicked);
		playButton.x = Main.WIDTH / 2 - playButton.width / 2;
		playButton.y = Main.HEIGHT / 2 - playButton.height / 2;
		add(playButton);

		#if debug
		var dev = new TextButton("Dev", 60, function()
		{
			FlxG.switchState(new DevStage());
		});
		dev.x = playButton.x + playButton.width;
		dev.y = Main.HEIGHT / 2 - dev.height / 2;
		add(dev);
		#end

		var scoreHeader = new FlxText(0, 16, 0, "Recent Highscores");
		scoreHeader.setFormat(AssetPaths.PermanentMarker__ttf, 48, 0xFFFFFFFF);
		scoreHeader.x = (scoreHeader.width > Main.WIDTH / 4) ? Main.WIDTH - scoreHeader.width : Main.WIDTH - Main.WIDTH / 4;
		add(scoreHeader);

		scoreLines = new List<ScoreLine>();

		showScores = new TextButton("Show Scores", 48, function()
		{
			remove(showScores);
			reloadScores();
		});
		showScores.x = Main.WIDTH - (Main.WIDTH / 8) - showScores.width / 2;
		showScores.y = 128;
		add(showScores);

		var credits = new TextButton("Credits", 60, onCreditsClicked);
		credits.x = 20;
		credits.y = Main.HEIGHT - credits.height - 20;
		add(credits);
	}

	private function onPlayClicked()
	{
		FlxG.sound.destroy(true);
		FlxG.switchState(new SwingSwingKK());
	}

	private function reloadScores()
	{
		ScoreClient.listScores(function(list:Array<Score>)
		{
			for (s in scoreLines)
			{
				this.remove(s);
			}

			scoreLines.clear();

			var names:Array<String> = new Array<String>();

			var yy:Float = 72;
			for (i in list)
			{
				if (names.contains(i.name))
				{
					continue;
				}

				var s = new ScoreLine(i.name, i.value);
				s.x = Main.WIDTH - Main.WIDTH / 4;
				s.y = yy;
				scoreLines.add(s);
				add(s);

				names.push(i.name);

				yy += s.height;
				if (yy > Main.HEIGHT - s.height)
				{
					break;
				}
			}
		});
	}

	private function onCreditsClicked()
	{
		openSubState(new CreditsSubState());
	}
}
