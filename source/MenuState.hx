package;

import credits.CreditsSubState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import score.Score;
import score.ScoreClient;
import stage.SwingSwingKK;
import stage.SwingSwingKKHard;
import ui.BasicTextButton;
import ui.Button;
import ui.ScoreLine;
import ui.TextButton;
#if debug
import stage.DevStage;
#end

class MenuState extends AbstractGraveyardState
{
	private static var TRACK_LIST = [
		{
			title: "Swing Swing",
			artist: "kk",
			state: SwingSwingKK.new,
			score: SwingSwingKK.SCORE_BOARD
		},
		{
			title: "Swing Swing (hard)",
			artist: "kk",
			state: SwingSwingKKHard.new,
			score: SwingSwingKKHard.SCORE_BOARD
		}
	];

	private static var trackSelectionIndex:Int = 0;

	private var scoreLinesMap:Map<String, List<ScoreLine>>;
	private var showScores:Button;
	private var showingScores:Bool = false;
	private var trackTitle:FlxText;
	private var trackArtist:FlxText;

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

		scoreLinesMap = new Map<String, List<ScoreLine>>();

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

		var trackSelectBackground = new FlxSprite(611, 20, AssetPaths.bg_menu__jpg);
		add(trackSelectBackground);

		var trackSelectBack = new BasicTextButton("<", 84, function()
		{
			setTrackRelative(-1);
		}, 0xFF000000);
		trackSelectBack.x = 650;
		trackSelectBack.y = 35;
		trackSelectBack.angle = Layout.BOARD_ANGLE;
		add(trackSelectBack);

		var trackSelectForward = new BasicTextButton(">", 84, function()
		{
			setTrackRelative(1);
		}, 0xFF000000);
		trackSelectForward.x = 1282;
		trackSelectForward.y = 21;
		trackSelectForward.angle = Layout.BOARD_ANGLE;
		add(trackSelectForward);

		trackTitle = new FlxText(714, 46, 570, "");
		trackTitle.setFormat(AssetPaths.PermanentMarker__ttf, 40, 0xFF000000, FlxTextAlign.CENTER);
		trackTitle.angle = Layout.BOARD_ANGLE;
		add(trackTitle);

		trackArtist = new FlxText(713, 93, 570, "");
		trackArtist.setFormat(AssetPaths.PermanentMarker__ttf, 36, 0xFF000000, FlxTextAlign.CENTER);
		trackArtist.angle = Layout.BOARD_ANGLE;
		add(trackArtist);

		setTrack(trackSelectionIndex);
	}

	private function setTrack(idx:Int)
	{
		trackSelectionIndex = idx;
		trackTitle.text = TRACK_LIST[trackSelectionIndex].title;
		trackArtist.text = TRACK_LIST[trackSelectionIndex].artist;

		if (showingScores)
		{
			reloadScores();
		}
	}

	private function setTrackRelative(idxr:Int)
	{
		var sel = trackSelectionIndex + idxr;

		if (sel < 0)
		{
			sel = TRACK_LIST.length - 1;
		}

		if (sel >= TRACK_LIST.length)
		{
			sel = 0;
		}

		setTrack(sel);
	}

	private function onPlayClicked()
	{
		FlxG.sound.destroy(true);

		FlxG.switchState(TRACK_LIST[trackSelectionIndex].state());
	}

	private function reloadScores()
	{
		showingScores = true;

		var board = TRACK_LIST[trackSelectionIndex].score;

		for (kv in scoreLinesMap.keyValueIterator())
		{
			for (i in kv.value)
			{
				i.visible = kv.key == board;
			}
		}

		if (scoreLinesMap.exists(board))
		{
			return;
		}

		var scoreLines = new List<ScoreLine>();
		scoreLinesMap[board] = scoreLines;

		ScoreClient.listScores(board, function(list:Array<Score>)
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
				if (i.name == null || names.contains(i.name))
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
