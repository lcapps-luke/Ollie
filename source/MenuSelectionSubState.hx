package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.ui.FlxClickArea;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import score.Score;
import score.ScoreClient;
import ui.ScoreLine;
import ui.TextButton;
import ui.TrackButton.TrackDetails;

class MenuSelectionSubState extends FlxSubState
{
	private static inline var CENTER:Float = 1580;
	private static var SCORES = new Map<String, Array<Score>>();
	private static var LOAD_SCORES = false;

	public static function RESET_SCORES()
	{
		SCORES = new Map<String, Array<Score>>();
	}

	private var details:TrackDetails;

	private var showScores:TextButton;
	private var toAdd:Array<Score> = null;

	public function new(details:TrackDetails)
	{
		super();
		this.details = details;
	}

	override function create()
	{
		super.create();
		var bg = new FlxSprite(0, 0, AssetPaths.cut_in__png);
		bg.scale.set(1, Main.HEIGHT);
		bg.origin.set(0, 0);
		bg.y = 0;
		bg.x = Main.WIDTH - bg.width;
		bg.alpha = 0.7;
		add(bg);

		var title = new FlxText();
		title.text = details.title;
		title.setFormat(AssetPaths.PermanentMarker__ttf, 50, 0xffffffff);
		title.x = CENTER - title.width / 2;
		title.y = 30;
		add(title);

		var artist = new FlxText();
		artist.text = 'By ${details.artist}';
		artist.setFormat(AssetPaths.PermanentMarker__ttf, 30, 0xffffffff);
		artist.x = CENTER - artist.width / 2;
		artist.y = title.y + 70;
		add(artist);

		var playButton = new TextButton("Play", 60, onPlayClicked);
		playButton.x = CENTER - playButton.width / 2;
		playButton.y = artist.y + 70;
		add(playButton);

		var best = new FlxText();
		best.text = 'Best Score: ${getBestScore()}';
		best.setFormat(AssetPaths.PermanentMarker__ttf, 40, 0xffffffff);
		best.x = CENTER - best.width / 2;
		best.y = playButton.y + 140;
		add(best);

		if (LOAD_SCORES)
		{
			reloadScores();
		}
		else
		{
			showScores = new TextButton("Show Scores", 30, function()
			{
				remove(showScores);
				reloadScores();
			});
			showScores.x = CENTER - showScores.width / 2;
			showScores.y = best.y + 200;
			add(showScores);
		}

		var backButton = new TextButton("Back", 20, onBackClicked);
		backButton.x = Main.WIDTH - backButton.width - 5;
		backButton.y = Main.HEIGHT - backButton.height - 5;
		add(backButton);

		new FlxTimer().start(0.3, function(t)
		{
			var backRegion = new FlxClickArea(0, 0, Main.WIDTH - bg.width, Main.HEIGHT, onBackClicked);
			add(backRegion);
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (toAdd != null)
		{
			var yy:Float = 400;
			for (i in toAdd)
			{
				var s = new ScoreLine(i.name, i.value, i.supporter);
				s.x = CENTER - 250;
				s.y = yy;

				yy += s.height;
				if (yy > Main.HEIGHT - s.height - 20)
				{
					break;
				}

				add(s);
			}

			toAdd = null;
		}
	}

	private function getBestScore():String
	{
		if (details.save == null || details.save.best < 0)
		{
			return "-";
		}

		return Std.string(details.save.best);
	}

	private function onPlayClicked()
	{
		FlxG.switchState(details.state());
	}

	private function onBackClicked()
	{
		close();
	}

	private function reloadScores()
	{
		LOAD_SCORES = true;

		if (SCORES.exists(details.score))
		{
			var newLines = new Array<Score>();
			for (s in SCORES.get(details.score))
			{
				newLines.push(s);
			}

			toAdd = newLines;
			return;
		}

		var scoreLines = new Array<Score>();
		SCORES[details.score] = scoreLines;

		ScoreClient.listScores(details.score, function(list:Array<Score>)
		{
			if (list == null)
			{
				toAdd = [
					{
						name: "Failed to load",
						value: -1,
						time: ""
					}
				];
				return;
			}

			var names:Array<String> = new Array<String>();

			var newLines = new Array<Score>();
			for (i in list)
			{
				if (i.name == null || names.contains(i.name))
				{
					continue;
				}

				newLines.push(i);
				names.push(i.name);
			}

			SCORES[details.score] = newLines;
			toAdd = newLines;
		});
	}
}
