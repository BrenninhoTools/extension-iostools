package ios.internal;

#if ios
import cpp.Callable;
import cpp.Char;
import cpp.ConstCharStar;
import cpp.RawPointer;

@:buildXml('<include name="${haxelib:extension-iostools}/project/Build.xml" />')
@:include("IOSTools.hpp")
@:unreflective
extern class Native
{
	@:native("iostools::take") static function take(ptr:RawPointer<Char>):String;
	@:native("iostools::setEventCallback") static function setEventCallback(callback:Callable<ConstCharStar->Void>):Void;

	@:native("iostools_device_name") static function deviceName():RawPointer<Char>;
	@:native("iostools_device_model") static function deviceModel():RawPointer<Char>;
	@:native("iostools_device_localized_model") static function deviceLocalizedModel():RawPointer<Char>;
	@:native("iostools_device_machine") static function deviceMachine():RawPointer<Char>;
	@:native("iostools_device_system_name") static function deviceSystemName():RawPointer<Char>;
	@:native("iostools_device_system_version") static function deviceSystemVersion():RawPointer<Char>;
	@:native("iostools_device_identifier_for_vendor") static function deviceIdentifierForVendor():RawPointer<Char>;
	@:native("iostools_device_language") static function deviceLanguage():RawPointer<Char>;
	@:native("iostools_device_locale") static function deviceLocale():RawPointer<Char>;
	@:native("iostools_device_region") static function deviceRegion():RawPointer<Char>;
	@:native("iostools_device_timezone") static function deviceTimezone():RawPointer<Char>;
	@:native("iostools_device_idiom") static function deviceIdiom():Int;
	@:native("iostools_device_orientation") static function deviceOrientation():Int;
	@:native("iostools_device_battery_level") static function deviceBatteryLevel():Float;
	@:native("iostools_device_battery_state") static function deviceBatteryState():Int;
	@:native("iostools_device_low_power_mode") static function deviceLowPowerMode():Bool;
	@:native("iostools_device_thermal_state") static function deviceThermalState():Int;
	@:native("iostools_device_physical_memory") static function devicePhysicalMemory():Float;
	@:native("iostools_device_processor_count") static function deviceProcessorCount():Int;
	@:native("iostools_device_active_processor_count") static function deviceActiveProcessorCount():Int;
	@:native("iostools_device_system_uptime") static function deviceSystemUptime():Float;
	@:native("iostools_device_is_simulator") static function deviceIsSimulator():Bool;
	@:native("iostools_device_is_ios_app_on_mac") static function deviceIsIOSAppOnMac():Bool;
	@:native("iostools_device_is_version_at_least") static function deviceIsVersionAtLeast(major:Int, minor:Int, patch:Int):Bool;
	@:native("iostools_device_start_monitoring") static function deviceStartMonitoring():Void;
	@:native("iostools_device_stop_monitoring") static function deviceStopMonitoring():Void;

	@:native("iostools_app_bundle_id") static function appBundleId():RawPointer<Char>;
	@:native("iostools_app_version") static function appVersion():RawPointer<Char>;
	@:native("iostools_app_build") static function appBuild():RawPointer<Char>;
	@:native("iostools_app_display_name") static function appDisplayName():RawPointer<Char>;
	@:native("iostools_app_state") static function appState():Int;
	@:native("iostools_app_open_url") static function appOpenURL(url:ConstCharStar):Bool;
	@:native("iostools_app_can_open_url") static function appCanOpenURL(url:ConstCharStar):Bool;
	@:native("iostools_app_open_settings") static function appOpenSettings():Bool;
	@:native("iostools_app_request_review") static function appRequestReview():Void;
	@:native("iostools_app_set_badge") static function appSetBadge(count:Int):Void;
	@:native("iostools_app_get_badge") static function appGetBadge():Int;

	@:native("iostools_paths_documents") static function pathsDocuments():RawPointer<Char>;
	@:native("iostools_paths_library") static function pathsLibrary():RawPointer<Char>;
	@:native("iostools_paths_caches") static function pathsCaches():RawPointer<Char>;
	@:native("iostools_paths_application_support") static function pathsApplicationSupport():RawPointer<Char>;
	@:native("iostools_paths_temporary") static function pathsTemporary():RawPointer<Char>;
	@:native("iostools_paths_bundle") static function pathsBundle():RawPointer<Char>;
	@:native("iostools_paths_free_space") static function pathsFreeSpace():Float;
	@:native("iostools_paths_total_space") static function pathsTotalSpace():Float;
	@:native("iostools_paths_exclude_from_backup") static function pathsExcludeFromBackup(path:ConstCharStar, exclude:Bool):Bool;

	@:native("iostools_screen_get_brightness") static function screenGetBrightness():Float;
	@:native("iostools_screen_set_brightness") static function screenSetBrightness(value:Float):Void;
	@:native("iostools_screen_get_keep_awake") static function screenGetKeepAwake():Bool;
	@:native("iostools_screen_set_keep_awake") static function screenSetKeepAwake(value:Bool):Void;
	@:native("iostools_screen_scale") static function screenScale():Float;
	@:native("iostools_screen_native_scale") static function screenNativeScale():Float;
	@:native("iostools_screen_width") static function screenWidth():Float;
	@:native("iostools_screen_height") static function screenHeight():Float;
	@:native("iostools_screen_native_width") static function screenNativeWidth():Float;
	@:native("iostools_screen_native_height") static function screenNativeHeight():Float;
	@:native("iostools_screen_safe_area_top") static function screenSafeAreaTop():Float;
	@:native("iostools_screen_safe_area_left") static function screenSafeAreaLeft():Float;
	@:native("iostools_screen_safe_area_bottom") static function screenSafeAreaBottom():Float;
	@:native("iostools_screen_safe_area_right") static function screenSafeAreaRight():Float;
	@:native("iostools_screen_max_fps") static function screenMaxFPS():Int;
	@:native("iostools_screen_is_captured") static function screenIsCaptured():Bool;

	@:native("iostools_haptic_supported") static function hapticSupported():Bool;
	@:native("iostools_haptic_impact") static function hapticImpact(style:Int, intensity:Float):Void;
	@:native("iostools_haptic_notification") static function hapticNotification(type:Int):Void;
	@:native("iostools_haptic_selection") static function hapticSelection():Void;
	@:native("iostools_haptic_vibrate") static function hapticVibrate():Void;

	@:native("iostools_alert_show") static function alertShow(requestId:Int, title:ConstCharStar, message:ConstCharStar, buttons:ConstCharStar, style:Int, cancelIndex:Int, destructiveIndex:Int):Void;
	@:native("iostools_alert_prompt") static function alertPrompt(requestId:Int, title:ConstCharStar, message:ConstCharStar, placeholder:ConstCharStar, text:ConstCharStar, confirm:ConstCharStar, cancel:ConstCharStar, secure:Bool):Void;
	@:native("iostools_toast_show") static function toastShow(message:ConstCharStar, duration:Float):Void;

	@:native("iostools_clipboard_set_text") static function clipboardSetText(text:ConstCharStar):Void;
	@:native("iostools_clipboard_get_text") static function clipboardGetText():RawPointer<Char>;
	@:native("iostools_clipboard_has_text") static function clipboardHasText():Bool;
	@:native("iostools_clipboard_clear") static function clipboardClear():Void;

	@:native("iostools_share") static function share(requestId:Int, text:ConstCharStar, url:ConstCharStar, files:ConstCharStar):Void;

	@:native("iostools_permission_status") static function permissionStatus(type:Int):Int;
	@:native("iostools_permission_request") static function permissionRequest(requestId:Int, type:Int):Void;

	@:native("iostools_notifications_schedule") static function notificationsSchedule(identifier:ConstCharStar, title:ConstCharStar, body:ConstCharStar, seconds:Float, repeats:Bool, badge:Int, sound:Bool):Void;
	@:native("iostools_notifications_cancel") static function notificationsCancel(identifier:ConstCharStar):Void;
	@:native("iostools_notifications_cancel_all") static function notificationsCancelAll():Void;
	@:native("iostools_notifications_clear_delivered") static function notificationsClearDelivered():Void;
	@:native("iostools_notifications_set_foreground_presentation") static function notificationsSetForegroundPresentation(enabled:Bool):Void;

	@:native("iostools_network_start") static function networkStart():Void;
	@:native("iostools_network_stop") static function networkStop():Void;
	@:native("iostools_network_is_connected") static function networkIsConnected():Bool;
	@:native("iostools_network_type") static function networkType():Int;
	@:native("iostools_network_is_expensive") static function networkIsExpensive():Bool;
	@:native("iostools_network_is_constrained") static function networkIsConstrained():Bool;

	@:native("iostools_audio_set_category") static function audioSetCategory(category:Int, mixWithOthers:Bool):Bool;
	@:native("iostools_audio_set_active") static function audioSetActive(active:Bool):Bool;
	@:native("iostools_audio_other_audio_playing") static function audioOtherAudioPlaying():Bool;
	@:native("iostools_audio_output_volume") static function audioOutputVolume():Float;
	@:native("iostools_audio_headphones_connected") static function audioHeadphonesConnected():Bool;
	@:native("iostools_audio_start_monitoring") static function audioStartMonitoring():Void;
}
#end
