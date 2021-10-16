package score;

import datetime.DateTime;
import haxe.Json;
import haxe.crypto.Md5;

class ScoreClient
{
	private static inline var root:String = "https://score.lc-apps.co.uk/";

	private static var client = new HttpClient();

	public static function getToken(board:String, callback:String->Void):Void
	{
		client.get({
			url: '$root$board/token',
			headers: [],
			params: [],
			success: (code:Int, content:String) ->
			{
				callback(content);
			},
			error: (msg:String) ->
			{
				callback(null);
			}
		});
	}

	public static function submit(board:String, token:String, name:String, score:Int, callback:Bool->Void, itchUserId:String = null):Void
	{
		client.post({
			url: '$root$board',
			headers: ["Content-Type" => "application/json"],
			params: [],
			body: Json.stringify({
				token: token,
				value: score,
				name: name,
				proof: Md5.encode(token + name),
				itchUserId: itchUserId
			}),
			success: (status:Int, content:String) ->
			{
				callback(status >= 200 && status <= 299);
			},
			error: (msg) ->
			{
				callback(false);
			}
		});
	}

	public static function listScores(board:String, callback:Array<Score>->Void):Void
	{
		client.get({
			url: '$root$board',
			headers: [],
			params: ["from" => (DateTime.now() - Day(30)).toString()],
			success: (status:Int, content:String) ->
			{
				var scores:Array<Score> = cast Json.parse(content);
				callback(scores);
			},
			error: (msg:String) ->
			{
				callback(null);
			}
		});
	}
}
