package ios;

#if ios
import ios.internal.Native;
import ios.internal.Util;

class Permissions
{
	public static function getStatus(permission:Permission):PermissionStatus
		return Native.permissionStatus(permission);

	public static function isGranted(permission:Permission):Bool
	{
		var status:PermissionStatus = getStatus(permission);
		return status == AUTHORIZED || status == LIMITED;
	}

	public static function request(permission:Permission, ?onResult:(granted:Bool, status:PermissionStatus) -> Void):Void
	{
		var id:Int = Callback.register(onResult == null ? null : function(data:Dynamic):Void
		{
			onResult(Util.field(data, "granted", false), Util.field(data, "status", 0));
		});

		Native.permissionRequest(id, permission);
	}
}
#end
