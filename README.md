# extension-iostools

A library for Haxe/Lime that focuses on iOS development, giving access to native iOS features through Objective-C. Think of it as [extension-androidtools](https://github.com/MAJigsaw77/extension-androidtools), but for iOS.

## Installation

```bash
haxelib git extension-iostools https://github.com/BrenninhoTools/extension-iostools.git
```

Add it to your `Project.xml`:

```xml
<haxelib name="extension-iostools" if="ios" />
```

Every class lives in the `ios` package and only exists when compiling for iOS, so wrap your calls with `#if ios`.

## Features

| Class | What it does |
| --- | --- |
| `ios.Device` | Name, model, machine identifier, iOS version, battery, thermal state, low power mode, memory, CPU count, locale, language, region, timezone, orientation |
| `ios.App` | Bundle id, version, build, display name, app state, open URLs, open Settings, App Store review prompt, badge number |
| `ios.Paths` | Documents, Library, Caches, Application Support, tmp and bundle paths, free/total disk space, exclude files from iCloud backup |
| `ios.Screen` | Brightness, keep screen awake, scale, size, safe area insets, max FPS, screen recording detection |
| `ios.Haptic` | Impact, notification and selection feedback, classic vibration |
| `ios.Alert` | Native alerts, action sheets, confirm dialogs and text prompts |
| `ios.Toast` | Android-style toast messages |
| `ios.Clipboard` | Read, write and clear the clipboard |
| `ios.Share` | Native share sheet for text, links and files |
| `ios.Permissions` | Status and requests for camera, microphone, photos and notifications |
| `ios.Notifications` | Local notifications, cancel, clear and foreground presentation |
| `ios.Network` | Connection state and type (Wi-Fi, cellular, wired), expensive/constrained paths |
| `ios.Audio` | Audio session category, activation, other audio playing, output volume, headphones |
| `ios.Callback` | Global listener for every native event |

## Usage

```haxe
#if ios
import ios.*;

class Main
{
	static function main():Void
	{
		Audio.setCategory(AMBIENT);
		Screen.keepAwake = true;

		var info:String = Device.machine + " / iOS " + Device.systemVersion;

		Alert.show("Hello", info, ["Cancel", "Play"], function(index:Int):Void
		{
			if (index == 1)
				Haptic.impact(HEAVY);
		}, ALERT, 0);

		Alert.prompt("Name", "Type your name", function(result:PromptResult):Void
		{
			if (result.confirmed)
				Toast.show("Hi " + result.text);
		});

		Permissions.request(NOTIFICATIONS, function(granted:Bool, status:PermissionStatus):Void
		{
			if (granted)
				Notifications.schedule("daily", "Come back!", "Your songs are waiting.", 60 * 60 * 24);
		});

		Share.file(Paths.documents + "/replay.json");
	}
}
#end
```

## Events

Some features keep sending events after they start. Listen to all of them through `ios.Callback`:

```haxe
Device.startMonitoring();
Network.start();
Audio.startMonitoring();
Notifications.setForegroundPresentation(true);

Callback.addListener(function(event:String, data:Dynamic):Void
{
	switch (event)
	{
		case "network":
			Toast.show(data.connected ? "Online" : "Offline");
		case "audio_interruption":
			FlxG.sound.pause();
		default:
	}
});
```

| Event | Data |
| --- | --- |
| `battery_level` | `level` |
| `battery_state` | `state` |
| `orientation` | `orientation` |
| `thermal_state` | `state` |
| `low_power_mode` | `enabled` |
| `memory_warning` | none |
| `network` | `connected`, `type`, `expensive`, `constrained` |
| `audio_interruption` | `began`, `shouldResume` |
| `audio_route` | `reason`, `headphones` |
| `notification_scheduled` | `identifier`, `success`, `error` |
| `notification_received` | `identifier` |
| `notification_opened` | `identifier`, `action` |
| `alert`, `prompt`, `share`, `permission` | Results of the matching calls, also delivered to their own callbacks |

All events are delivered on the main thread.

## Info.plist

iOS needs a usage description before asking for some permissions, otherwise the app will crash. Add the keys you need to your Info.plist template:

| Permission | Key |
| --- | --- |
| `CAMERA` | `NSCameraUsageDescription` |
| `MICROPHONE` | `NSMicrophoneUsageDescription` |
| `PHOTOS` | `NSPhotoLibraryUsageDescription` |
| `PHOTOS_ADD_ONLY` | `NSPhotoLibraryAddUsageDescription` |

To open other apps with `App.canOpenURL`, add their schemes to `LSApplicationQueriesSchemes`.

## How it works

The native side is written in Objective-C (`.mm` files compiled with ARC) under `project/src` and exposed through a plain C API (`project/include/iostools.h`). The Haxe externs in `ios.internal.Native` call that API directly, and `project/Build.xml` is pulled into the hxcpp build automatically. Frameworks are linked through `include.xml`.

## License

MIT
