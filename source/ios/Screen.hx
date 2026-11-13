package ios;

#if ios
import ios.internal.Native;

class Screen
{
	public static var brightness(get, set):Float;
	public static var keepAwake(get, set):Bool;
	public static var scale(get, never):Float;
	public static var nativeScale(get, never):Float;
	public static var width(get, never):Float;
	public static var height(get, never):Float;
	public static var nativeWidth(get, never):Float;
	public static var nativeHeight(get, never):Float;
	public static var safeArea(get, never):SafeArea;
	public static var maxFPS(get, never):Int;
	public static var isCaptured(get, never):Bool;

	static function get_brightness():Float
		return Native.screenGetBrightness();

	static function set_brightness(value:Float):Float
	{
		Native.screenSetBrightness(value);
		return value;
	}

	static function get_keepAwake():Bool
		return Native.screenGetKeepAwake();

	static function set_keepAwake(value:Bool):Bool
	{
		Native.screenSetKeepAwake(value);
		return value;
	}

	static function get_scale():Float
		return Native.screenScale();

	static function get_nativeScale():Float
		return Native.screenNativeScale();

	static function get_width():Float
		return Native.screenWidth();

	static function get_height():Float
		return Native.screenHeight();

	static function get_nativeWidth():Float
		return Native.screenNativeWidth();

	static function get_nativeHeight():Float
		return Native.screenNativeHeight();

	static function get_safeArea():SafeArea
	{
		return {
			top: Native.screenSafeAreaTop(),
			left: Native.screenSafeAreaLeft(),
			bottom: Native.screenSafeAreaBottom(),
			right: Native.screenSafeAreaRight()
		};
	}

	static function get_maxFPS():Int
		return Native.screenMaxFPS();

	static function get_isCaptured():Bool
		return Native.screenIsCaptured();
}
#end
