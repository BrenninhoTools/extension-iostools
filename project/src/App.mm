#import "IOSToolsInternal.h"
#import <StoreKit/StoreKit.h>
#import <UserNotifications/UserNotifications.h>

static NSString *iostools_info(NSString *key)
{
	id value = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
	return [value isKindOfClass:[NSString class]] ? value : @"";
}

char *iostools_app_bundle_id(void)
{
	return iostools_copy([NSBundle mainBundle].bundleIdentifier ?: @"");
}

char *iostools_app_version(void)
{
	return iostools_copy(iostools_info(@"CFBundleShortVersionString"));
}

char *iostools_app_build(void)
{
	return iostools_copy(iostools_info(@"CFBundleVersion"));
}

char *iostools_app_display_name(void)
{
	NSString *name = iostools_info(@"CFBundleDisplayName");

	if (name.length == 0)
		name = iostools_info(@"CFBundleName");

	return iostools_copy(name);
}

int iostools_app_state(void)
{
	return (int)[UIApplication sharedApplication].applicationState;
}

bool iostools_app_open_url(const char *url)
{
	NSURL *target = [NSURL URLWithString:iostools_ns(url)];

	if (target == nil)
		return false;

	UIApplication *application = [UIApplication sharedApplication];

	if (![application canOpenURL:target])
		return false;

	[application openURL:target options:@{} completionHandler:nil];
	return true;
}

bool iostools_app_can_open_url(const char *url)
{
	NSURL *target = [NSURL URLWithString:iostools_ns(url)];
	return target != nil && [[UIApplication sharedApplication] canOpenURL:target];
}

bool iostools_app_open_settings(void)
{
	NSURL *target = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

	if (target == nil)
		return false;

	[[UIApplication sharedApplication] openURL:target options:@{} completionHandler:nil];
	return true;
}

void iostools_app_request_review(void)
{
	iostools_main(^{
		if (@available(iOS 14.0, *))
		{
			UIWindowScene *scene = iostools_key_window().windowScene;

			if (scene != nil)
			{
				[SKStoreReviewController requestReviewInScene:scene];
				return;
			}
		}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		[SKStoreReviewController requestReview];
#pragma clang diagnostic pop
	});
}

void iostools_app_set_badge(int count)
{
	NSInteger value = count < 0 ? 0 : count;

	iostools_main(^{
		if (@available(iOS 16.0, *))
		{
			[[UNUserNotificationCenter currentNotificationCenter] setBadgeCount:value withCompletionHandler:nil];
			return;
		}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		[UIApplication sharedApplication].applicationIconBadgeNumber = value;
#pragma clang diagnostic pop
	});
}

int iostools_app_get_badge(void)
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	return (int)[UIApplication sharedApplication].applicationIconBadgeNumber;
#pragma clang diagnostic pop
}
