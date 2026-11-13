package ios;

#if ios
import ios.internal.Native;
import ios.internal.Util;

class App
{
	public static var bundleId(get, never):String;
	public static var version(get, never):String;
	public static var build(get, never):String;
	public static var displayName(get, never):String;
	public static var state(get, never):AppState;
	public static var badge(get, set):Int;

	public static function openURL(url:String):Bool
		return Native.appOpenURL(Util.safe(url));

	public static function canOpenURL(url:String):Bool
		return Native.appCanOpenURL(Util.safe(url));

	public static function openSettings():Bool
		return Native.appOpenSettings();

	public static function requestReview():Void
		Native.appRequestReview();

	static function get_bundleId():String
		return Util.str(Native.appBundleId());

	static function get_version():String
		return Util.str(Native.appVersion());

	static function get_build():String
		return Util.str(Native.appBuild());

	static function get_displayName():String
		return Util.str(Native.appDisplayName());

	static function get_state():AppState
		return Native.appState();

	static function get_badge():Int
		return Native.appGetBadge();

	static function set_badge(value:Int):Int
	{
		Native.appSetBadge(value);
		return value;
	}
}
#end
