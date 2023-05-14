package;

import flixel.FlxG;
import flixel.addons.ui.FlxInputText;
import flixel.text.FlxText;
import score.ScoreClient;
import ui.Button;
import ui.TextButton;

class EndState extends AbstractGraveyardState
{
	private var board:String;
	private var score:Int;
	private var token:String = null;

	private var nameInput:FlxInputText;
	private var submitClicked:Bool = false;

	public function new(board:String, score:Int, token:String)
	{
		super();
		this.board = board;
		this.score = score;
		this.token = token;
	}

	override function create()
	{
		super.create();

		var scoreText = new FlxText(Layout.SCORE_X, Layout.SCORE_Y, Layout.SCORE_WIDTH, 'Score: $score');
		scoreText.setFormat(AssetPaths.PermanentMarker__ttf, Layout.SCORE_SIZE, 0xFF000000);
		scoreText.angle = Layout.BOARD_ANGLE;
		scoreText.antialiasing = true;
		add(scoreText);

		var label:FlxText = new FlxText(0, 0, 0, "Submit Score?", 144);
		label.setFormat(AssetPaths.PermanentMarker__ttf, 144, 0xFFFFFFFF);
		label.x = Main.WIDTH / 2 - label.width / 2;
		label.y = Main.HEIGHT / 4 - label.height / 2;
		add(label);

		var savedName:String = Main.SAVE.data.name;
		nameInput = new FlxInputText(0, 0, Math.round(Main.WIDTH * 0.75), "", 144, 0xFFFFFF, 0x000000);
		nameInput.setFormat(AssetPaths.PermanentMarker__ttf, 144, 0xFFFFFFFF);
		nameInput.text = savedName == null ? "anonymous" : savedName;
		nameInput.caretWidth = 10;
		nameInput.maxLength = Main.NAME_MAX_LENGTH;
		nameInput.x = Main.WIDTH / 8;
		nameInput.y = Main.HEIGHT / 2 - nameInput.height / 2;
		nameInput.textField.needsSoftKeyboard = true;
		nameInput.hasFocus = true;
		add(nameInput);

		if (token != null)
		{
			var submit:Button = new TextButton("Submit", 144, onSubmitClicked);
			submit.x = Main.WIDTH / 2 + 20;
			submit.y = (Main.HEIGHT - submit.height) - 20;
			add(submit);
		}

		var cancel:Button = new TextButton("Return", 144, onCancelClicked);
		cancel.x = Main.WIDTH / 2 - (cancel.width + 20);
		cancel.y = (Main.HEIGHT - cancel.height) - 20;
		add(cancel);
	}

	private function onSubmitClicked()
	{
		if (!submitClicked)
		{
			submitClicked = true;

			var sanName = nameInput.text;
			if (sanName.length > Main.NAME_MAX_LENGTH)
			{
				sanName = sanName.substring(0, Main.NAME_MAX_LENGTH);
			}

			Main.SAVE.data.name = sanName;
			Main.SAVE.flush();

			ScoreClient.submit(board, token, sanName, score, function(success:Bool)
			{
				if (success)
				{
					returnToMenu();
				}
				else
				{
					submitClicked = false;
				}
			}, Main.ITCH_USER_ID);
		}
	}

	private function onCancelClicked()
	{
		returnToMenu();
	}

	private function returnToMenu()
	{
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			FlxG.sound.music.fadeOut();
		}
		FlxG.switchState(new MenuState());
	}
}
