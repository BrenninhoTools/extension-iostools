#import "IOSToolsInternal.h"
#import <AVFoundation/AVFoundation.h>

@interface IOSToolsAudioObserver : NSObject
@end

@implementation IOSToolsAudioObserver

- (instancetype)init
{
	self = [super init];

	if (self)
	{
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		AVAudioSession *session = [AVAudioSession sharedInstance];
		[center addObserver:self selector:@selector(interrupted:) name:AVAudioSessionInterruptionNotification object:session];
		[center addObserver:self selector:@selector(routeChanged:) name:AVAudioSessionRouteChangeNotification object:session];
	}

	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)interrupted:(NSNotification *)notification
{
	NSUInteger type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
	NSUInteger options = [notification.userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
	bool began = type == AVAudioSessionInterruptionTypeBegan;
	bool shouldResume = !began && (options & AVAudioSessionInterruptionOptionShouldResume) != 0;

	iostools_emit(@"audio_interruption", @{@"began": @(began), @"shouldResume": @(shouldResume)});
}

- (void)routeChanged:(NSNotification *)notification
{
	NSUInteger reason = [notification.userInfo[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
	iostools_emit(@"audio_route", @{@"reason": @(reason), @"headphones": @(iostools_audio_headphones_connected())});
}

@end

static IOSToolsAudioObserver *iostools_audio_observer = nil;

bool iostools_audio_set_category(int category, bool mixWithOthers)
{
	AVAudioSessionCategory value = AVAudioSessionCategoryAmbient;

	switch (category)
	{
		case 1:
			value = AVAudioSessionCategorySoloAmbient;
			break;
		case 2:
			value = AVAudioSessionCategoryPlayback;
			break;
		case 3:
			value = AVAudioSessionCategoryRecord;
			break;
		case 4:
			value = AVAudioSessionCategoryPlayAndRecord;
			break;
		default:
			break;
	}

	AVAudioSessionCategoryOptions options = 0;

	if (mixWithOthers && value != AVAudioSessionCategoryAmbient && value != AVAudioSessionCategorySoloAmbient)
		options |= AVAudioSessionCategoryOptionMixWithOthers;

	if (value == AVAudioSessionCategoryPlayAndRecord)
		options |= AVAudioSessionCategoryOptionDefaultToSpeaker;

	return [[AVAudioSession sharedInstance] setCategory:value withOptions:options error:nil];
}

bool iostools_audio_set_active(bool active)
{
	return [[AVAudioSession sharedInstance] setActive:active withOptions:active ? 0 : AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

bool iostools_audio_other_audio_playing(void)
{
	return [AVAudioSession sharedInstance].isOtherAudioPlaying;
}

double iostools_audio_output_volume(void)
{
	return [AVAudioSession sharedInstance].outputVolume;
}

bool iostools_audio_headphones_connected(void)
{
	for (AVAudioSessionPortDescription *output in [AVAudioSession sharedInstance].currentRoute.outputs)
	{
		NSString *port = output.portType;

		if ([port isEqualToString:AVAudioSessionPortHeadphones] || [port isEqualToString:AVAudioSessionPortBluetoothA2DP] || [port isEqualToString:AVAudioSessionPortBluetoothHFP] || [port isEqualToString:AVAudioSessionPortBluetoothLE] || [port isEqualToString:AVAudioSessionPortUSBAudio])
			return true;
	}

	return false;
}

void iostools_audio_start_monitoring(void)
{
	iostools_main(^{
		if (iostools_audio_observer == nil)
			iostools_audio_observer = [[IOSToolsAudioObserver alloc] init];
	});
}
