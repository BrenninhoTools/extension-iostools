#import "IOSToolsInternal.h"

#include <sys/utsname.h>
#include <TargetConditionals.h>

@interface IOSToolsDeviceObserver : NSObject
@end

@implementation IOSToolsDeviceObserver

- (instancetype)init
{
	self = [super init];

	if (self)
	{
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserver:self selector:@selector(batteryLevelChanged:) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
		[center addObserver:self selector:@selector(batteryStateChanged:) name:UIDeviceBatteryStateDidChangeNotification object:nil];
		[center addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
		[center addObserver:self selector:@selector(thermalStateChanged:) name:NSProcessInfoThermalStateDidChangeNotification object:nil];
		[center addObserver:self selector:@selector(powerStateChanged:) name:NSProcessInfoPowerStateDidChangeNotification object:nil];
		[center addObserver:self selector:@selector(memoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	}

	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)batteryLevelChanged:(NSNotification *)notification
{
	iostools_emit(@"battery_level", @{@"level": @(iostools_device_battery_level())});
}

- (void)batteryStateChanged:(NSNotification *)notification
{
	iostools_emit(@"battery_state", @{@"state": @(iostools_device_battery_state())});
}

- (void)orientationChanged:(NSNotification *)notification
{
	iostools_emit(@"orientation", @{@"orientation": @(iostools_device_orientation())});
}

- (void)thermalStateChanged:(NSNotification *)notification
{
	iostools_emit(@"thermal_state", @{@"state": @(iostools_device_thermal_state())});
}

- (void)powerStateChanged:(NSNotification *)notification
{
	iostools_emit(@"low_power_mode", @{@"enabled": @(iostools_device_low_power_mode())});
}

- (void)memoryWarning:(NSNotification *)notification
{
	iostools_emit(@"memory_warning", @{});
}

@end

static IOSToolsDeviceObserver *iostools_device_observer = nil;

char *iostools_device_name(void)
{
	return iostools_copy([UIDevice currentDevice].name);
}

char *iostools_device_model(void)
{
	return iostools_copy([UIDevice currentDevice].model);
}

char *iostools_device_localized_model(void)
{
	return iostools_copy([UIDevice currentDevice].localizedModel);
}

char *iostools_device_machine(void)
{
#if TARGET_OS_SIMULATOR
	NSString *simulated = [NSProcessInfo processInfo].environment[@"SIMULATOR_MODEL_IDENTIFIER"];

	if (simulated != nil)
		return iostools_copy(simulated);
#endif

	struct utsname info;
	uname(&info);
	return iostools_copy([NSString stringWithUTF8String:info.machine]);
}

char *iostools_device_system_name(void)
{
	return iostools_copy([UIDevice currentDevice].systemName);
}

char *iostools_device_system_version(void)
{
	return iostools_copy([UIDevice currentDevice].systemVersion);
}

char *iostools_device_identifier_for_vendor(void)
{
	NSUUID *identifier = [UIDevice currentDevice].identifierForVendor;
	return iostools_copy(identifier ? identifier.UUIDString : @"");
}

char *iostools_device_language(void)
{
	NSString *language = [NSLocale preferredLanguages].firstObject;
	return iostools_copy(language ?: @"");
}

char *iostools_device_locale(void)
{
	return iostools_copy([NSLocale currentLocale].localeIdentifier);
}

char *iostools_device_region(void)
{
	NSString *region = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
	return iostools_copy(region ?: @"");
}

char *iostools_device_timezone(void)
{
	return iostools_copy([NSTimeZone localTimeZone].name);
}

int iostools_device_idiom(void)
{
	return (int)[UIDevice currentDevice].userInterfaceIdiom;
}

int iostools_device_orientation(void)
{
	return (int)[UIDevice currentDevice].orientation;
}

double iostools_device_battery_level(void)
{
	UIDevice *device = [UIDevice currentDevice];

	if (!device.batteryMonitoringEnabled)
		device.batteryMonitoringEnabled = YES;

	return device.batteryLevel;
}

int iostools_device_battery_state(void)
{
	UIDevice *device = [UIDevice currentDevice];

	if (!device.batteryMonitoringEnabled)
		device.batteryMonitoringEnabled = YES;

	return (int)device.batteryState;
}

bool iostools_device_low_power_mode(void)
{
	return [NSProcessInfo processInfo].lowPowerModeEnabled;
}

int iostools_device_thermal_state(void)
{
	return (int)[NSProcessInfo processInfo].thermalState;
}

double iostools_device_physical_memory(void)
{
	return (double)[NSProcessInfo processInfo].physicalMemory;
}

int iostools_device_processor_count(void)
{
	return (int)[NSProcessInfo processInfo].processorCount;
}

int iostools_device_active_processor_count(void)
{
	return (int)[NSProcessInfo processInfo].activeProcessorCount;
}

double iostools_device_system_uptime(void)
{
	return [NSProcessInfo processInfo].systemUptime;
}

bool iostools_device_is_simulator(void)
{
#if TARGET_OS_SIMULATOR
	return true;
#else
	return false;
#endif
}

bool iostools_device_is_ios_app_on_mac(void)
{
	if (@available(iOS 14.0, *))
		return [NSProcessInfo processInfo].isiOSAppOnMac;

	return false;
}

bool iostools_device_is_version_at_least(int major, int minor, int patch)
{
	NSOperatingSystemVersion version = {major, minor, patch};
	return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version];
}

void iostools_device_start_monitoring(void)
{
	iostools_main(^{
		if (iostools_device_observer != nil)
			return;

		UIDevice *device = [UIDevice currentDevice];
		device.batteryMonitoringEnabled = YES;
		[device beginGeneratingDeviceOrientationNotifications];
		iostools_device_observer = [[IOSToolsDeviceObserver alloc] init];
	});
}

void iostools_device_stop_monitoring(void)
{
	iostools_main(^{
		if (iostools_device_observer == nil)
			return;

		[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
		iostools_device_observer = nil;
	});
}
