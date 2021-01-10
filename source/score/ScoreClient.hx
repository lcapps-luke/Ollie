package score;

import datetime.DateTime;
import haxe.Http;
import haxe.Json;

class ScoreClient
{
	private static inline var root:String = "https://score.lc-apps.co.uk/ollie";

	public static function getToken(callback:String->Void):Void
	{
		var req = new Http('$root/token');
		#if js
		req.async = true;
		#end
		req.onData = callback;

		req.onError = function(msg:String)
		{
			callback(null);
		};

		req.request(false);
	}

	public static function submit(token:String, name:String, score:Int, callback:Bool->Void):Void
	{
		var req = new Http('$root');
		#if js
		req.async = true;
		#end
		req.addHeader("Content-Type", "application/json");
		req.setPostData(Json.stringify({
			token: token,
			value: score,
			name: name,
			proof: null
		}));

		req.onStatus = function(status:Int)
		{
			callback(status >= 200 && status <= 299);
		};

		req.onError = function(msg:String)
		{
			callback(false);
		}

		req.request(true);
	}

	public static function listScores(callback:Array<Score>->Void):Void
	{
		var req = new Http('$root');
		req.addParameter("from", (DateTime.now() - Day(30)).toString());
		#if js
		req.async = true;
		#end
		req.onData = function(data:String)
		{
			var scores:Array<Score> = cast Json.parse(data);
			callback(scores);
		};

		req.onError = function(msg:String)
		{
			callback(null);
		}

		req.request(false);
	}
}
