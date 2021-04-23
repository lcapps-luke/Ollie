package credits;

import flixel.FlxSubState;
import flixel.text.FlxText;
import openfl.Lib;
import openfl.net.URLRequest;
import ui.InteractionUtils;
import ui.TextButton;

class CreditsSubState extends FlxSubState
{
	private var coverLink:FlxText = null;
	private var coverLinkHover:Bool = false;
	private var urlHover:FlxTextFormat;

	public function new()
	{
		super(0xBE000000);

		urlHover = new FlxTextFormat(0xFFFF0000);
	}

	override function create()
	{
		super.create();

		var title = new FlxText(0, 16, 0, "Credits");
		title.setFormat(AssetPaths.PermanentMarker__ttf, 72, 0xFFFFFFFF);
		title.x = Main.WIDTH / 2 - title.width / 2;
		add(title);

		var yAcc = title.height + 40;

		var ollie = new CreditLine("Kureiji Ollie");
		ollie.addLink("https://www.youtube.com/channel/UCYz_5n-uDuChHtLo7My1HnQ", AssetPaths.yt_icon__png);
		ollie.addLink("https://twitter.com/kureijiollie", AssetPaths.tw_icon__png);
		ollie.x = 40;
		ollie.y = yAcc;
		add(ollie);

		yAcc += CreditLine.SIZE * 2;
		var lc = new CreditLine("Game by Luke Cann");
		lc.addLink("https://twitter.com/cannl", AssetPaths.tw_icon__png);
		lc.x = 40;
		lc.y = yAcc;
		add(lc);

		yAcc += CreditLine.SIZE * 2;
		var kk = new CreditLine("'Swing Swing' by kk");
		kk.addLink("https://www.youtube.com/watch?v=YVzk3bqEu6g", AssetPaths.yt_icon__png);
		kk.x = 40;
		kk.y = yAcc;
		add(kk);

		yAcc += CreditLine.SIZE;
		var jd = new CreditLine("'Swing Swing EDM Remix' by Jair D");
		jd.addLink("https://www.youtube.com/watch?v=9-j-RBGrHVM", AssetPaths.yt_icon__png);
		jd.x = 40;
		jd.y = yAcc;
		add(kk);

		yAcc += CreditLine.SIZE * 4;
		coverLink = new FlxText();
		coverLink.setFormat(AssetPaths.PermanentMarker__ttf, CreditLine.SIZE, 0xFFFFFFFF);
		coverLink.wordWrap = true;
		coverLink.fieldWidth = Main.WIDTH - 40;
		coverLink.text = "Characters and artwork are the property of cover corp.\nSee their fan work terms for details https://en.hololive.tv/terms";
		coverLink.x = 40;
		coverLink.y = yAcc;

		add(coverLink);

		var closeBtn = new TextButton("Close", 60, () ->
		{
			close();
		});
		closeBtn.x = Main.WIDTH - closeBtn.width - 20;
		closeBtn.y = Main.HEIGHT - closeBtn.height - 20;
		add(closeBtn);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (coverLink == null)
		{
			return;
		}

		var interact = InteractionUtils.wasClicked(coverLink.getHitbox());

		if (interact == OVER && !coverLinkHover)
		{
			coverLink.addFormat(urlHover, 92, 139);
			coverLinkHover = true;
		}

		if (interact == CLICK)
		{
			Lib.getURL(new URLRequest("https://en.hololive.tv/terms"), "_blank");
		}

		if (interact == NONE && coverLinkHover)
		{
			coverLink.removeFormat(urlHover);
			coverLinkHover = false;
		}
	}
}
