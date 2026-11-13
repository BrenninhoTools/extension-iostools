package ios;

#if ios
import ios.internal.Native;
import ios.internal.Util;

class Notifications
{
	public static function requestPermission(?onResult:(granted:Bool, status:PermissionStatus) -> Void):Void
		Permissions.request(NOTIFICATIONS, onResult);

	public static function schedule(identifier:String, title:String, body:String, seconds:Float, repeats:Bool = false, badge:Int = -1, sound:Bool = true):Void
	{
		Callback.init();
		Native.notificationsSchedule(Util.safe(identifier), Util.safe(title), Util.safe(body), seconds, repeats, badge, sound);
	}

	public static function cancel(identifier:String):Void
		Native.notificationsCancel(Util.safe(identifier));

	public static function cancelAll():Void
		Native.notificationsCancelAll();

	public static function clearDelivered():Void
		Native.notificationsClearDelivered();

	public static function setForegroundPresentation(enabled:Bool):Void
	{
		Callback.init();
		Native.notificationsSetForegroundPresentation(enabled);
	}
}
#end
