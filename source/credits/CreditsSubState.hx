package credits;

import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import openfl.Lib;
import openfl.net.URLRequest;
import ui.BasicButton;
import ui.TextButton;

class CreditsSubState extends FlxSubState
{
	private static inline var CREDIT_PAD = 10;

	private var coverLink:FlxText = null;
	private var coverLinkHover:Bool = false;
	private var urlHover:FlxTextFormat;
	private var coverButton:BasicButton;

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

		yAcc += CreditLine.SIZE + CREDIT_PAD;
		var jd = new CreditLine("'Swing Swing EDM Remix' by Jair D");
		jd.addLink("https://www.youtube.com/watch?v=9-j-RBGrHVM", AssetPaths.yt_icon__png);
		jd.addLink("https://twitter.com/SakuraMusicLLC", AssetPaths.tw_icon__png);
		jd.addLink("https://ko-fi.com/audiobox", AssetPaths.kofi_icon__png);
		jd.x = 40;
		jd.y = yAcc;
		add(jd);

		yAcc += CreditLine.SIZE + CREDIT_PAD;
		var mc = new CreditLine("'Jollie Jollie Metal Cover' by Doni Azulef");
		mc.addLink("https://www.youtube.com/watch?v=yZKGMTMPEE4", AssetPaths.yt_icon__png);
		mc.x = 40;
		mc.y = yAcc;
		add(mc);

		yAcc += CreditLine.SIZE * 2;
		var da = new CreditLine("EDM Disk Art by Bang telex");
		da.addLink("https://www.pixiv.net/en/artworks/86105054", AssetPaths.pixiv_icon__png);
		da.x = 40;
		da.y = yAcc;
		add(da);

		yAcc += CreditLine.SIZE + CREDIT_PAD;
		var da = new CreditLine("Metal Disk Art by berobe6");
		da.addLink("https://twitter.com/berobe6/status/1513017500094853120", AssetPaths.tw_icon__png);
		da.x = 40;
		da.y = yAcc;
		add(da);

		yAcc += CreditLine.SIZE * 4;
		coverLink = new FlxText();
		coverLink.setFormat(AssetPaths.PermanentMarker__ttf, CreditLine.SIZE, 0xFFFFFFFF);
		coverLink.wordWrap = true;
		coverLink.fieldWidth = Main.WIDTH - 40;
		coverLink.text = "Characters and artwork are the property of cover corp.\nSee their fan work terms for details https://en.hololive.tv/terms";
		coverLink.x = 40;
		coverLink.y = yAcc;

		coverButton = new BasicButton(coverLink, onCoverLink);
		coverButton.x = 40;
		coverButton.y = yAcc;
		coverButton.normalAlpha = 1;
		add(coverButton);

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

		var interact = coverButton.status;

		if (interact != FlxButton.NORMAL && !coverLinkHover)
		{
			coverLink.addFormat(urlHover, 92, 139);
			coverLinkHover = true;
		}

		if (interact == FlxButton.NORMAL && coverLinkHover)
		{
			coverLink.removeFormat(urlHover);
			coverLinkHover = false;
		}
	}

	private function onCoverLink()
	{
		Lib.getURL(new URLRequest("https://en.hololive.tv/terms"), "_blank");
	}
}
