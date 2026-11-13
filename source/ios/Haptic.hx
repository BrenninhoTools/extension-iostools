package ios;

#if ios
import ios.internal.Native;

class Haptic
{
	public static var supported(get, never):Bool;

	public static function impact(style:ImpactStyle = MEDIUM, intensity:Float = 1.0):Void
		Native.hapticImpact(style, intensity);

	public static function notification(type:NotificationFeedback = SUCCESS):Void
		Native.hapticNotification(type);

	public static function selection():Void
		Native.hapticSelection();

	public static function vibrate():Void
		Native.hapticVibrate();

	static function get_supported():Bool
		return Native.hapticSupported();
}
#end
