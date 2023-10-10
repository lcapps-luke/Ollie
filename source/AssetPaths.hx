package;

@:build(flixel.system.FlxAssets.buildFileReferences("assets", true))
class AssetPaths
{
	public static inline var LIB_MUSIC_SS = "music_ss";
	public static inline var LIB_MUSIC_EDM = "music_edm";
	public static inline var LIB_MUSIC_METAL = "music_metal";

	public static function makePath(lib:String, asset:String)
	{
		return '$lib:$asset';
	}
}
