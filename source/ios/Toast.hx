package ios;

#if ios
import ios.internal.Native;
import ios.internal.Util;

class Toast
{
	public static inline var SHORT:Float = 2.0;
	public static inline var LONG:Float = 3.5;

	public static function show(message:String, duration:Float = SHORT):Void
		Native.toastShow(Util.safe(message), duration);
}
#end
