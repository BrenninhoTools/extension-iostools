#import "IOSToolsInternal.h"

static UIEdgeInsets iostools_safe_area(void)
{
	UIWindow *window = iostools_key_window();
	return window ? window.safeAreaInsets : UIEdgeInsetsZero;
}

double iostools_screen_get_brightness(void)
{
	return [UIScreen mainScreen].brightness;
}

void iostools_screen_set_brightness(double value)
{
	CGFloat brightness = (CGFloat)(value < 0.0 ? 0.0 : (value > 1.0 ? 1.0 : value));

	iostools_main(^{
		[UIScreen mainScreen].brightness = brightness;
	});
}

bool iostools_screen_get_keep_awake(void)
{
	return [UIApplication sharedApplication].idleTimerDisabled;
}

void iostools_screen_set_keep_awake(bool value)
{
	iostools_main(^{
		[UIApplication sharedApplication].idleTimerDisabled = value;
	});
}

double iostools_screen_scale(void)
{
	return [UIScreen mainScreen].scale;
}

double iostools_screen_native_scale(void)
{
	return [UIScreen mainScreen].nativeScale;
}

double iostools_screen_width(void)
{
	return [UIScreen mainScreen].bounds.size.width;
}

double iostools_screen_height(void)
{
	return [UIScreen mainScreen].bounds.size.height;
}

double iostools_screen_native_width(void)
{
	return [UIScreen mainScreen].nativeBounds.size.width;
}

double iostools_screen_native_height(void)
{
	return [UIScreen mainScreen].nativeBounds.size.height;
}

double iostools_screen_safe_area_top(void)
{
	return iostools_safe_area().top;
}

double iostools_screen_safe_area_left(void)
{
	return iostools_safe_area().left;
}

double iostools_screen_safe_area_bottom(void)
{
	return iostools_safe_area().bottom;
}

double iostools_screen_safe_area_right(void)
{
	return iostools_safe_area().right;
}

int iostools_screen_max_fps(void)
{
	return (int)[UIScreen mainScreen].maximumFramesPerSecond;
}

bool iostools_screen_is_captured(void)
{
	return [UIScreen mainScreen].isCaptured;
}
