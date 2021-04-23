package credits;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import openfl.Lib;
import openfl.net.URLRequest;
import ui.BasicButton;

class CreditLine extends FlxSpriteGroup
{
	private static inline var BUTTON_MARGIN:Float = 50;
	public static inline var SIZE:Int = 48;

	private var text:FlxText;
	private var xAcc:Float;

	public function new(text:String)
	{
		super();

		this.text = new FlxText();
		this.text.setFormat(AssetPaths.PermanentMarker__ttf, SIZE, 0xFFFFFFFF);
		this.text.text = text;
		add(this.text);

		xAcc = this.text.width + BUTTON_MARGIN;
	}

	public function addLink(url:String, image:FlxGraphicAsset)
	{
		var ico = new FlxSprite(0, 0, image);
		var scale = SIZE / ico.height;
		ico.scale.set(scale, scale);
		ico.updateHitbox();

		var btn = new BasicButton(ico, function()
		{
			Lib.getURL(new URLRequest(url), "_blank");
		});
		btn.x = xAcc;
		btn.y = SIZE * 0.25;

		add(btn);

		xAcc += btn.width + BUTTON_MARGIN;
	}
}
