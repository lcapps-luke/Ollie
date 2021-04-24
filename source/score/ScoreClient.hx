package score;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpResponse;
import datetime.DateTime;
import haxe.Json;

class ScoreClient
{
	private static inline var root:String = "https://score.lc-apps.co.uk/ollie";

	public static function getToken(callback:String->Void):Void
	{
		var request = new HttpRequest({
			url: '$root/token',
			callback: function(response:HttpResponse)
			{
				callback(response.toText());
			},
			callbackError: function(response:HttpResponse)
			{
				callback(null);
			}
		});

		request.send();
	}

	public static function submit(token:String, name:String, score:Int, callback:Bool->Void):Void
	{
		var request = new HttpRequest({
			url: '$root',
			method: "POST",
			contentType: "application/json",
			content: Json.stringify({
				token: token,
				value: score,
				name: name,
				proof: null
			}),
			callback: function(response:HttpResponse)
			{
				callback(response.isOK);
			}
		});

		request.send();
	}

	public static function listScores(callback:Array<Score>->Void):Void
	{
		var fromDate = StringTools.urlEncode((DateTime.now() - Day(30)).toString());

		var request = new HttpRequest({
			url: '$root?from=$fromDate',
			callback: function(response:HttpResponse)
			{
				callback(cast response.toJson());
			},
			callbackError: function(response:HttpResponse)
			{
				callback(null);
			}
		});

		request.send();
	}
}
