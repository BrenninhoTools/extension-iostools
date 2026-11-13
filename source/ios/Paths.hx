package ios;

#if ios
import ios.internal.Native;
import ios.internal.Util;

class Paths
{
	public static var documents(get, never):String;
	public static var library(get, never):String;
	public static var caches(get, never):String;
	public static var applicationSupport(get, never):String;
	public static var temporary(get, never):String;
	public static var bundle(get, never):String;
	public static var freeSpace(get, never):Float;
	public static var totalSpace(get, never):Float;

	public static function excludeFromBackup(path:String, exclude:Bool = true):Bool
		return Native.pathsExcludeFromBackup(Util.safe(path), exclude);

	static function get_documents():String
		return Util.str(Native.pathsDocuments());

	static function get_library():String
		return Util.str(Native.pathsLibrary());

	static function get_caches():String
		return Util.str(Native.pathsCaches());

	static function get_applicationSupport():String
		return Util.str(Native.pathsApplicationSupport());

	static function get_temporary():String
		return Util.str(Native.pathsTemporary());

	static function get_bundle():String
		return Util.str(Native.pathsBundle());

	static function get_freeSpace():Float
		return Native.pathsFreeSpace();

	static function get_totalSpace():Float
		return Native.pathsTotalSpace();
}
#end
