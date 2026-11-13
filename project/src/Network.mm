#import "IOSToolsInternal.h"
#import <Network/Network.h>

enum
{
	IOSTOOLS_NETWORK_NONE = 0,
	IOSTOOLS_NETWORK_WIFI = 1,
	IOSTOOLS_NETWORK_CELLULAR = 2,
	IOSTOOLS_NETWORK_WIRED = 3,
	IOSTOOLS_NETWORK_OTHER = 4
};

static nw_path_monitor_t iostools_monitor = nil;
static bool iostools_connected = false;
static int iostools_type = IOSTOOLS_NETWORK_NONE;
static bool iostools_expensive = false;
static bool iostools_constrained = false;

static void iostools_network_update(nw_path_t path)
{
	bool connected = nw_path_get_status(path) == nw_path_status_satisfied;
	int type = IOSTOOLS_NETWORK_NONE;

	if (connected)
	{
		if (nw_path_uses_interface_type(path, nw_interface_type_wifi))
			type = IOSTOOLS_NETWORK_WIFI;
		else if (nw_path_uses_interface_type(path, nw_interface_type_cellular))
			type = IOSTOOLS_NETWORK_CELLULAR;
		else if (nw_path_uses_interface_type(path, nw_interface_type_wired))
			type = IOSTOOLS_NETWORK_WIRED;
		else
			type = IOSTOOLS_NETWORK_OTHER;
	}

	bool expensive = nw_path_is_expensive(path);
	bool constrained = false;

	if (@available(iOS 13.0, *))
		constrained = nw_path_is_constrained(path);

	bool changed = connected != iostools_connected || type != iostools_type || expensive != iostools_expensive || constrained != iostools_constrained;

	iostools_connected = connected;
	iostools_type = type;
	iostools_expensive = expensive;
	iostools_constrained = constrained;

	if (changed)
	{
		iostools_emit(@"network", @{
			@"connected": @(connected),
			@"type": @(type),
			@"expensive": @(expensive),
			@"constrained": @(constrained)
		});
	}
}

void iostools_network_start(void)
{
	iostools_main(^{
		if (iostools_monitor != nil)
			return;

		iostools_monitor = nw_path_monitor_create();
		nw_path_monitor_set_queue(iostools_monitor, dispatch_get_main_queue());
		nw_path_monitor_set_update_handler(iostools_monitor, ^(nw_path_t path) {
			iostools_network_update(path);
		});
		nw_path_monitor_start(iostools_monitor);
	});
}

void iostools_network_stop(void)
{
	iostools_main(^{
		if (iostools_monitor == nil)
			return;

		nw_path_monitor_cancel(iostools_monitor);
		iostools_monitor = nil;
	});
}

bool iostools_network_is_connected(void)
{
	return iostools_connected;
}

int iostools_network_type(void)
{
	return iostools_type;
}

bool iostools_network_is_expensive(void)
{
	return iostools_expensive;
}

bool iostools_network_is_constrained(void)
{
	return iostools_constrained;
}
