package ui;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

class ScoreLine extends FlxSpriteGroup
{
	public function new(name:String, score:Int, outline:Bool)
	{
		super();

		var nt:FlxText = new FlxText(0, 0, 0, name.length > Main.NAME_MAX_LENGTH ? name.substring(0, Main.NAME_MAX_LENGTH) : name);
		nt.setFormat(AssetPaths.PermanentMarker__ttf, 32, 0xFFFFFFFF, LEFT, outline ? OUTLINE : NONE, 0xFFFF4B00);
		nt.borderSize = 2;
		add(nt);

		var st:FlxText = new FlxText(0, 0, 0, Std.string(score));
		st.setFormat(AssetPaths.PermanentMarker__ttf, 32, 0xFFFFFFFF);
		st.x = (Main.WIDTH / 4) - st.width;
		add(st);
	}
}
