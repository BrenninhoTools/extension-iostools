package ios;

#if ios
import ios.internal.Native;

class Network
{
	public static var isConnected(get, never):Bool;
	public static var type(get, never):NetworkType;
	public static var isExpensive(get, never):Bool;
	public static var isConstrained(get, never):Bool;

	public static function start():Void
	{
		Callback.init();
		Native.networkStart();
	}

	public static function stop():Void
		Native.networkStop();

	static function get_isConnected():Bool
		return Native.networkIsConnected();

	static function get_type():NetworkType
		return Native.networkType();

	static function get_isExpensive():Bool
		return Native.networkIsExpensive();

	static function get_isConstrained():Bool
		return Native.networkIsConstrained();
}
#end
