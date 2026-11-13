#import "IOSToolsInternal.h"
#import <AudioToolbox/AudioToolbox.h>

bool iostools_haptic_supported(void)
{
	Class engine = NSClassFromString(@"CHHapticEngine");

	if (engine == nil || ![engine respondsToSelector:@selector(capabilitiesForHardware)])
		return false;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	id capabilities = [engine performSelector:@selector(capabilitiesForHardware)];
#pragma clang diagnostic pop

	if (capabilities == nil || ![capabilities respondsToSelector:@selector(supportsHaptics)])
		return false;

	return [[capabilities valueForKey:@"supportsHaptics"] boolValue];
}

void iostools_haptic_impact(int style, double intensity)
{
	iostools_main(^{
		UIImpactFeedbackStyle feedbackStyle = UIImpactFeedbackStyleMedium;

		switch (style)
		{
			case 0:
				feedbackStyle = UIImpactFeedbackStyleLight;
				break;
			case 2:
				feedbackStyle = UIImpactFeedbackStyleHeavy;
				break;
			case 3:
				if (@available(iOS 13.0, *))
					feedbackStyle = UIImpactFeedbackStyleSoft;
				break;
			case 4:
				if (@available(iOS 13.0, *))
					feedbackStyle = UIImpactFeedbackStyleRigid;
				break;
			default:
				break;
		}

		UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:feedbackStyle];
		[generator prepare];

		if (@available(iOS 13.0, *))
		{
			CGFloat value = (CGFloat)(intensity < 0.0 ? 0.0 : (intensity > 1.0 ? 1.0 : intensity));
			[generator impactOccurredWithIntensity:value];
		}
		else
			[generator impactOccurred];
	});
}

void iostools_haptic_notification(int type)
{
	iostools_main(^{
		UINotificationFeedbackType feedbackType = UINotificationFeedbackTypeSuccess;

		if (type == 1)
			feedbackType = UINotificationFeedbackTypeWarning;
		else if (type == 2)
			feedbackType = UINotificationFeedbackTypeError;

		UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
		[generator prepare];
		[generator notificationOccurred:feedbackType];
	});
}

void iostools_haptic_selection(void)
{
	iostools_main(^{
		UISelectionFeedbackGenerator *generator = [[UISelectionFeedbackGenerator alloc] init];
		[generator prepare];
		[generator selectionChanged];
	});
}

void iostools_haptic_vibrate(void)
{
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
