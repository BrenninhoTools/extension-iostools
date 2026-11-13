package ios;

#if ios
import ios.internal.Native;
import ios.internal.Util;

class Share
{
	public static function share(?text:String, ?url:String, ?files:Array<String>, ?onComplete:ShareResult->Void):Void
	{
		var id:Int = Callback.register(onComplete == null ? null : function(data:Dynamic):Void
		{
			onComplete({
				completed: Util.field(data, "completed", false),
				activity: Util.field(data, "activity", ""),
				error: Util.field(data, "error", "")
			});
		});

		Native.share(id, Util.safe(text), Util.safe(url), Util.list(files));
	}

	public static inline function text(value:String, ?onComplete:ShareResult->Void):Void
		share(value, null, null, onComplete);

	public static inline function url(value:String, ?onComplete:ShareResult->Void):Void
		share(null, value, null, onComplete);

	public static inline function file(path:String, ?onComplete:ShareResult->Void):Void
		share(null, null, [path], onComplete);
}
#end
