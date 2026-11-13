package ios;

#if ios
import ios.internal.Native;

class Audio
{
	public static var isOtherAudioPlaying(get, never):Bool;
	public static var outputVolume(get, never):Float;
	public static var headphonesConnected(get, never):Bool;

	public static function setCategory(category:AudioCategory, mixWithOthers:Bool = false):Bool
		return Native.audioSetCategory(category, mixWithOthers);

	public static function setActive(active:Bool):Bool
		return Native.audioSetActive(active);

	public static function startMonitoring():Void
	{
		Callback.init();
		Native.audioStartMonitoring();
	}

	static function get_isOtherAudioPlaying():Bool
		return Native.audioOtherAudioPlaying();

	static function get_outputVolume():Float
		return Native.audioOutputVolume();

	static function get_headphonesConnected():Bool
		return Native.audioHeadphonesConnected();
}
#end
