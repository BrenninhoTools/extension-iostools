package ios;

#if ios
import ios.internal.Native;
import ios.internal.Util;

class Alert
{
	public static function show(title:String, message:String, ?buttons:Array<String>, ?onSelect:Int->Void, style:AlertStyle = ALERT, cancelIndex:Int = -1, destructiveIndex:Int = -1):Void
	{
		var id:Int = Callback.register(onSelect == null ? null : function(data:Dynamic):Void
		{
			onSelect(Util.field(data, "index", -1));
		});

		Native.alertShow(id, Util.safe(title), Util.safe(message), Util.list(buttons), style, cancelIndex, destructiveIndex);
	}

	public static function confirm(title:String, message:String, onResult:Bool->Void, confirmLabel:String = "OK", cancelLabel:String = "Cancel"):Void
	{
		show(title, message, [cancelLabel, confirmLabel], function(index:Int):Void
		{
			if (onResult != null)
				onResult(index == 1);
		}, ALERT, 0);
	}

	public static function prompt(title:String, message:String, onResult:PromptResult->Void, placeholder:String = "", text:String = "", confirmLabel:String = "OK", cancelLabel:String = "Cancel", secure:Bool = false):Void
	{
		var id:Int = Callback.register(onResult == null ? null : function(data:Dynamic):Void
		{
			onResult({
				confirmed: Util.field(data, "confirmed", false),
				text: Util.field(data, "text", "")
			});
		});

		Native.alertPrompt(id, Util.safe(title), Util.safe(message), Util.safe(placeholder), Util.safe(text), Util.safe(confirmLabel), Util.safe(cancelLabel), secure);
	}
}
#end
