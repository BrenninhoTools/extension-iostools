#import "IOSToolsInternal.h"
#import <UserNotifications/UserNotifications.h>

@interface IOSToolsNotificationDelegate : NSObject <UNUserNotificationCenterDelegate>
@property (nonatomic, weak) id<UNUserNotificationCenterDelegate> previous;
@end

@implementation IOSToolsNotificationDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
	UNNotificationPresentationOptions options = UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge;

	if (@available(iOS 14.0, *))
		options |= UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionList;
	else
	{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		options |= UNNotificationPresentationOptionAlert;
#pragma clang diagnostic pop
	}

	iostools_emit(@"notification_received", @{@"identifier": notification.request.identifier ?: @""});
	completionHandler(options);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
	iostools_emit(@"notification_opened", @{
		@"identifier": response.notification.request.identifier ?: @"",
		@"action": response.actionIdentifier ?: @""
	});

	if (self.previous != nil && [self.previous respondsToSelector:_cmd])
		[self.previous userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
	else
		completionHandler();
}

@end

static IOSToolsNotificationDelegate *iostools_notification_delegate = nil;

void iostools_notifications_schedule(const char *identifier, const char *title, const char *body, double seconds, bool repeats, int badge, bool sound)
{
	NSString *requestIdentifier = iostools_ns(identifier);

	if (requestIdentifier.length == 0)
		requestIdentifier = [NSUUID UUID].UUIDString;

	UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
	content.title = iostools_ns(title);
	content.body = iostools_ns(body);

	if (badge >= 0)
		content.badge = @(badge);

	if (sound)
		content.sound = [UNNotificationSound defaultSound];

	NSTimeInterval interval = seconds < 1.0 ? 1.0 : seconds;

	if (repeats && interval < 60.0)
		interval = 60.0;

	UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:repeats];
	UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];

	[[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError *error) {
		iostools_emit(@"notification_scheduled", @{
			@"identifier": requestIdentifier,
			@"success": @(error == nil),
			@"error": error ? error.localizedDescription : @""
		});
	}];
}

void iostools_notifications_cancel(const char *identifier)
{
	NSString *requestIdentifier = iostools_ns(identifier);
	UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
	[center removePendingNotificationRequestsWithIdentifiers:@[requestIdentifier]];
	[center removeDeliveredNotificationsWithIdentifiers:@[requestIdentifier]];
}

void iostools_notifications_cancel_all(void)
{
	[[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
}

void iostools_notifications_clear_delivered(void)
{
	[[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
}

void iostools_notifications_set_foreground_presentation(bool enabled)
{
	iostools_main(^{
		UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

		if (enabled)
		{
			if (iostools_notification_delegate == nil)
				iostools_notification_delegate = [[IOSToolsNotificationDelegate alloc] init];

			if (center.delegate != iostools_notification_delegate)
			{
				iostools_notification_delegate.previous = center.delegate;
				center.delegate = iostools_notification_delegate;
			}
		}
		else if (iostools_notification_delegate != nil && center.delegate == iostools_notification_delegate)
			center.delegate = iostools_notification_delegate.previous;
	});
}
