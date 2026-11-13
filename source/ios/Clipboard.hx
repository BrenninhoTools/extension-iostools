package ios;

#if ios
import ios.internal.Native;
import ios.internal.Util;

class Clipboard
{
	public static var text(get, set):String;
	public static var hasText(get, never):Bool;

	public static function clear():Void
		Native.clipboardClear();

	static function get_text():String
		return Util.str(Native.clipboardGetText());

	static function set_text(value:String):String
	{
		Native.clipboardSetText(Util.safe(value));
		return value;
	}

	static function get_hasText():Bool
		return Native.clipboardHasText();
}
#end
