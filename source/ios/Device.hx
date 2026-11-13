package ios;

#if ios
import ios.internal.Native;
import ios.internal.Util;

class Device
{
	public static var name(get, never):String;
	public static var model(get, never):String;
	public static var localizedModel(get, never):String;
	public static var machine(get, never):String;
	public static var systemName(get, never):String;
	public static var systemVersion(get, never):String;
	public static var identifierForVendor(get, never):String;
	public static var language(get, never):String;
	public static var locale(get, never):String;
	public static var region(get, never):String;
	public static var timezone(get, never):String;
	public static var idiom(get, never):DeviceIdiom;
	public static var orientation(get, never):DeviceOrientation;
	public static var batteryLevel(get, never):Float;
	public static var batteryState(get, never):BatteryState;
	public static var lowPowerMode(get, never):Bool;
	public static var thermalState(get, never):ThermalState;
	public static var physicalMemory(get, never):Float;
	public static var processorCount(get, never):Int;
	public static var activeProcessorCount(get, never):Int;
	public static var systemUptime(get, never):Float;
	public static var isSimulator(get, never):Bool;
	public static var isIOSAppOnMac(get, never):Bool;
	public static var isPad(get, never):Bool;
	public static var isPhone(get, never):Bool;

	public static function isVersionAtLeast(major:Int, minor:Int = 0, patch:Int = 0):Bool
		return Native.deviceIsVersionAtLeast(major, minor, patch);

	public static function startMonitoring():Void
	{
		Callback.init();
		Native.deviceStartMonitoring();
	}

	public static function stopMonitoring():Void
		Native.deviceStopMonitoring();

	static function get_name():String
		return Util.str(Native.deviceName());

	static function get_model():String
		return Util.str(Native.deviceModel());

	static function get_localizedModel():String
		return Util.str(Native.deviceLocalizedModel());

	static function get_machine():String
		return Util.str(Native.deviceMachine());

	static function get_systemName():String
		return Util.str(Native.deviceSystemName());

	static function get_systemVersion():String
		return Util.str(Native.deviceSystemVersion());

	static function get_identifierForVendor():String
		return Util.str(Native.deviceIdentifierForVendor());

	static function get_language():String
		return Util.str(Native.deviceLanguage());

	static function get_locale():String
		return Util.str(Native.deviceLocale());

	static function get_region():String
		return Util.str(Native.deviceRegion());

	static function get_timezone():String
		return Util.str(Native.deviceTimezone());

	static function get_idiom():DeviceIdiom
		return Native.deviceIdiom();

	static function get_orientation():DeviceOrientation
		return Native.deviceOrientation();

	static function get_batteryLevel():Float
		return Native.deviceBatteryLevel();

	static function get_batteryState():BatteryState
		return Native.deviceBatteryState();

	static function get_lowPowerMode():Bool
		return Native.deviceLowPowerMode();

	static function get_thermalState():ThermalState
		return Native.deviceThermalState();

	static function get_physicalMemory():Float
		return Native.devicePhysicalMemory();

	static function get_processorCount():Int
		return Native.deviceProcessorCount();

	static function get_activeProcessorCount():Int
		return Native.deviceActiveProcessorCount();

	static function get_systemUptime():Float
		return Native.deviceSystemUptime();

	static function get_isSimulator():Bool
		return Native.deviceIsSimulator();

	static function get_isIOSAppOnMac():Bool
		return Native.deviceIsIOSAppOnMac();

	static function get_isPad():Bool
		return get_idiom() == PAD;

	static function get_isPhone():Bool
		return get_idiom() == PHONE;
}
#end
