package;

import birthday.BirthdayOverlay;
import birthday.BirthdayUtils;
import credits.CreditsSubState;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import stage.SwingSwingEdm;
import stage.SwingSwingKK;
import stage.SwingSwingKKHard;
import ui.Button;
import ui.MainMenuButton;
import ui.ScoreLine;
import ui.TextButton;
import ui.TrackButton;
#if debug
import stage.DevStage;
#end

class MenuState extends AbstractGraveyardState
{
	private var scoreLinesMap:Map<String, List<ScoreLine>>;
	private var showScores:Button;
	private var showingScores:Bool = false;
	private var trackTitle:FlxText;
	private var trackArtist:FlxText;

	private var toAdd:Array<FlxBasic> = null;

	public function new()
	{
		super();
		MenuSelectionSubState.RESET_SCORES();
	}

	override function create()
	{
		super.create();

		#if debug
		var dev = new TextButton("Dev", 60, function()
		{
			FlxG.switchState(new DevStage());
		});
		dev.x = Main.WIDTH / 2 - dev.width / 2;
		dev.y = Main.HEIGHT - dev.height;
		add(dev);
		#end

		var trackSelectBackground = new FlxSprite(611, 20, AssetPaths.bg_menu__jpg);
		add(trackSelectBackground);

		var creditsButton = new MainMenuButton(AssetPaths.btn_credits__png, "Credits", 1450, 510, onCreditsClicked);
		add(creditsButton);

		add(new TrackButton(AssetPaths.disk_normal__png, 337, 54, onTrackSelected, {
			title: "Swing Swing",
			artist: "kk",
			state: SwingSwingKK.new,
			score: SwingSwingKK.SCORE_BOARD
		}));

		add(new TrackButton(AssetPaths.disk_hard__png, 337, 510, onTrackSelected, {
			title: "Swing Swing (hard)",
			artist: "kk",
			state: SwingSwingKKHard.new,
			score: SwingSwingKKHard.SCORE_BOARD
		}));

		add(new TrackButton(AssetPaths.disk_edm__png, 890, 280, onTrackSelected, {
			title: "Swing Swing (EDM Remix)",
			artist: "Jair D",
			state: SwingSwingEdm.new,
			score: SwingSwingEdm.SCORE_BOARD
		}));

		if (BirthdayUtils.isBirthday())
		{
			add(new BirthdayOverlay(this));
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (toAdd != null)
		{
			for (a in toAdd)
			{
				add(a);
			}
		}
	}

	private function onCreditsClicked()
	{
		openSubState(new CreditsSubState());
	}

	private function onTrackSelected(details:TrackDetails)
	{
		openSubState(new MenuSelectionSubState(details));
	}
}
