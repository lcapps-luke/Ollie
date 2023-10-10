package ui;

import SaveData.StageData;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxAssets.FlxGraphicAsset;

class TrackButton extends MainMenuButton
{
	private var callback:TrackDetails->Void;
	private var details:TrackDetails;

	private var stars:FlxSprite;

	public function new(spr:FlxGraphicAsset, x:Float, y:Float, callback:TrackDetails->Void, details:TrackDetails)
	{
		super(spr, details.title, x, y, onClick);
		this.callback = callback;
		this.details = details;

		details.save = Main.getStageData(details.score);

		stars = new FlxSprite();
		stars.loadGraphic(AssetPaths.stars__png, true, 127, 48);
		stars.x = x + this.sprite.width / 2 - stars.width / 2;
		stars.y = y + this.sprite.height + 30;
		stars.animation.frameIndex = 0;

		if (details.save != null)
		{
			if (details.save.perfect)
			{
				stars.animation.frameIndex = 2;
			}
			else if (details.save.complete)
			{
				stars.animation.frameIndex = 1;
			}
		}

		add(stars);
	}

	private function onClick()
	{
		callback(details);
	}
}

typedef TrackDetails =
{
	var title:String;
	var artist:String;
	var state:Void->FlxState;
	var score:String;
	var library:String;
	var ?save:StageData;
}
