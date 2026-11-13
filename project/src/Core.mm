#import "IOSToolsInternal.h"

#include <stdlib.h>
#include <string.h>

static iostools_event_callback iostools_callback = NULL;

char *iostools_copy(NSString *value)
{
	if (value == nil)
		return NULL;

	const char *utf8 = [value UTF8String];
	return utf8 ? strdup(utf8) : NULL;
}

NSString *iostools_ns(const char *value)
{
	if (value == NULL)
		return @"";

	NSString *result = [NSString stringWithUTF8String:value];
	return result ? result : @"";
}

NSArray<NSString *> *iostools_parse_list(const char *json)
{
	NSData *data = [iostools_ns(json) dataUsingEncoding:NSUTF8StringEncoding];

	if (data == nil)
		return @[];

	id parsed = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

	if (![parsed isKindOfClass:[NSArray class]])
		return @[];

	NSMutableArray<NSString *> *result = [NSMutableArray array];

	for (id item in (NSArray *)parsed)
		[result addObject:[item isKindOfClass:[NSString class]] ? item : [item description]];

	return result;
}

void iostools_main(dispatch_block_t block)
{
	if ([NSThread isMainThread])
		block();
	else
		dispatch_async(dispatch_get_main_queue(), block);
}

void iostools_emit(NSString *event, NSDictionary *data)
{
	NSDictionary *payload = @{@"event": event ?: @"", @"data": data ?: @{}};
	NSData *json = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];

	if (json == nil)
		return;

	NSString *text = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];

	dispatch_async(dispatch_get_main_queue(), ^{
		if (iostools_callback != NULL)
			iostools_callback([text UTF8String]);
	});
}

UIWindow *iostools_key_window(void)
{
	UIApplication *application = [UIApplication sharedApplication];

	if (@available(iOS 13.0, *))
	{
		UIWindow *fallback = nil;

		for (UIScene *scene in application.connectedScenes)
		{
			if (![scene isKindOfClass:[UIWindowScene class]])
				continue;

			for (UIWindow *window in ((UIWindowScene *)scene).windows)
			{
				if (window.isKeyWindow)
					return window;

				if (fallback == nil)
					fallback = window;
			}
		}

		if (fallback != nil)
			return fallback;
	}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	UIWindow *window = application.keyWindow;

	if (window == nil)
		window = application.windows.firstObject;
#pragma clang diagnostic pop

	return window;
}

UIViewController *iostools_top_controller(void)
{
	UIViewController *controller = iostools_key_window().rootViewController;

	while (controller != nil)
	{
		if (controller.presentedViewController != nil && !controller.presentedViewController.isBeingDismissed)
			controller = controller.presentedViewController;
		else if ([controller isKindOfClass:[UINavigationController class]] && ((UINavigationController *)controller).visibleViewController != nil)
			controller = ((UINavigationController *)controller).visibleViewController;
		else if ([controller isKindOfClass:[UITabBarController class]] && ((UITabBarController *)controller).selectedViewController != nil)
			controller = ((UITabBarController *)controller).selectedViewController;
		else
			break;
	}

	return controller;
}

void iostools_set_event_callback(iostools_event_callback callback)
{
	iostools_callback = callback;
}

void iostools_free(char *ptr)
{
	if (ptr != NULL)
		free(ptr);
}
