package ios.internal;

#if ios
import cpp.Char;
import cpp.RawPointer;
import haxe.Json;

class Util
{
	public static inline function str(ptr:RawPointer<Char>):String
		return Native.take(ptr);

	public static inline function safe(value:Null<String>):String
		return value == null ? "" : value;

	public static function list(values:Null<Array<String>>):String
		return Json.stringify(values == null ? [] : values);

	public static function field<T>(data:Dynamic, name:String, fallback:T):T
	{
		if (data == null || !Reflect.hasField(data, name))
			return fallback;

		var value:Dynamic = Reflect.field(data, name);
		return value == null ? fallback : cast value;
	}
}
#end
