#import "IOSToolsInternal.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <UserNotifications/UserNotifications.h>

enum
{
	IOSTOOLS_PERMISSION_CAMERA = 0,
	IOSTOOLS_PERMISSION_MICROPHONE = 1,
	IOSTOOLS_PERMISSION_PHOTOS = 2,
	IOSTOOLS_PERMISSION_PHOTOS_ADD_ONLY = 3,
	IOSTOOLS_PERMISSION_NOTIFICATIONS = 4
};

enum
{
	IOSTOOLS_STATUS_NOT_DETERMINED = 0,
	IOSTOOLS_STATUS_DENIED = 1,
	IOSTOOLS_STATUS_AUTHORIZED = 2,
	IOSTOOLS_STATUS_RESTRICTED = 3,
	IOSTOOLS_STATUS_LIMITED = 4,
	IOSTOOLS_STATUS_UNSUPPORTED = 5
};

static int iostools_av_status(AVMediaType type)
{
	switch ([AVCaptureDevice authorizationStatusForMediaType:type])
	{
		case AVAuthorizationStatusAuthorized:
			return IOSTOOLS_STATUS_AUTHORIZED;
		case AVAuthorizationStatusDenied:
			return IOSTOOLS_STATUS_DENIED;
		case AVAuthorizationStatusRestricted:
			return IOSTOOLS_STATUS_RESTRICTED;
		default:
			return IOSTOOLS_STATUS_NOT_DETERMINED;
	}
}

static int iostools_photo_status_value(PHAuthorizationStatus status)
{
	switch (status)
	{
		case PHAuthorizationStatusAuthorized:
			return IOSTOOLS_STATUS_AUTHORIZED;
		case PHAuthorizationStatusDenied:
			return IOSTOOLS_STATUS_DENIED;
		case PHAuthorizationStatusRestricted:
			return IOSTOOLS_STATUS_RESTRICTED;
		case PHAuthorizationStatusNotDetermined:
			return IOSTOOLS_STATUS_NOT_DETERMINED;
		default:
			return IOSTOOLS_STATUS_LIMITED;
	}
}

static int iostools_photo_status(bool addOnly)
{
	if (@available(iOS 14.0, *))
		return iostools_photo_status_value([PHPhotoLibrary authorizationStatusForAccessLevel:addOnly ? PHAccessLevelAddOnly : PHAccessLevelReadWrite]);

	return iostools_photo_status_value([PHPhotoLibrary authorizationStatus]);
}

static int iostools_notification_status_value(UNAuthorizationStatus status)
{
	switch (status)
	{
		case UNAuthorizationStatusAuthorized:
			return IOSTOOLS_STATUS_AUTHORIZED;
		case UNAuthorizationStatusDenied:
			return IOSTOOLS_STATUS_DENIED;
		case UNAuthorizationStatusNotDetermined:
			return IOSTOOLS_STATUS_NOT_DETERMINED;
		default:
			return IOSTOOLS_STATUS_LIMITED;
	}
}

static int iostools_notification_status(void)
{
	__block int result = IOSTOOLS_STATUS_NOT_DETERMINED;
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

	[[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
		result = iostools_notification_status_value(settings.authorizationStatus);
		dispatch_semaphore_signal(semaphore);
	}];

	dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)));
	return result;
}

static void iostools_permission_result(int requestId, int type, int status)
{
	iostools_emit(@"permission", @{
		@"id": @(requestId),
		@"type": @(type),
		@"status": @(status),
		@"granted": @(status == IOSTOOLS_STATUS_AUTHORIZED || status == IOSTOOLS_STATUS_LIMITED)
	});
}

int iostools_permission_status(int type)
{
	switch (type)
	{
		case IOSTOOLS_PERMISSION_CAMERA:
			return iostools_av_status(AVMediaTypeVideo);
		case IOSTOOLS_PERMISSION_MICROPHONE:
			return iostools_av_status(AVMediaTypeAudio);
		case IOSTOOLS_PERMISSION_PHOTOS:
			return iostools_photo_status(false);
		case IOSTOOLS_PERMISSION_PHOTOS_ADD_ONLY:
			return iostools_photo_status(true);
		case IOSTOOLS_PERMISSION_NOTIFICATIONS:
			return iostools_notification_status();
		default:
			return IOSTOOLS_STATUS_UNSUPPORTED;
	}
}

void iostools_permission_request(int requestId, int type)
{
	switch (type)
	{
		case IOSTOOLS_PERMISSION_CAMERA:
		case IOSTOOLS_PERMISSION_MICROPHONE:
		{
			AVMediaType media = type == IOSTOOLS_PERMISSION_CAMERA ? AVMediaTypeVideo : AVMediaTypeAudio;

			[AVCaptureDevice requestAccessForMediaType:media completionHandler:^(BOOL granted) {
				iostools_permission_result(requestId, type, granted ? IOSTOOLS_STATUS_AUTHORIZED : iostools_av_status(media));
			}];
			break;
		}
		case IOSTOOLS_PERMISSION_PHOTOS:
		case IOSTOOLS_PERMISSION_PHOTOS_ADD_ONLY:
		{
			if (@available(iOS 14.0, *))
			{
				PHAccessLevel level = type == IOSTOOLS_PERMISSION_PHOTOS_ADD_ONLY ? PHAccessLevelAddOnly : PHAccessLevelReadWrite;

				[PHPhotoLibrary requestAuthorizationForAccessLevel:level handler:^(PHAuthorizationStatus status) {
					iostools_permission_result(requestId, type, iostools_photo_status_value(status));
				}];
			}
			else
			{
				[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
					iostools_permission_result(requestId, type, iostools_photo_status_value(status));
				}];
			}
			break;
		}
		case IOSTOOLS_PERMISSION_NOTIFICATIONS:
		{
			UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;

			[[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError *error) {
				iostools_permission_result(requestId, type, granted ? IOSTOOLS_STATUS_AUTHORIZED : IOSTOOLS_STATUS_DENIED);
			}];
			break;
		}
		default:
			iostools_permission_result(requestId, type, IOSTOOLS_STATUS_UNSUPPORTED);
			break;
	}
}
