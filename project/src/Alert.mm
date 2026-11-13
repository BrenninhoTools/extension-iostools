#import "IOSToolsInternal.h"

void iostools_present(UIViewController *controller)
{
	UIViewController *top = iostools_top_controller();

	if (top == nil)
		return;

	if (controller.popoverPresentationController != nil)
	{
		UIPopoverPresentationController *popover = controller.popoverPresentationController;
		popover.sourceView = top.view;
		popover.sourceRect = CGRectMake(CGRectGetMidX(top.view.bounds), CGRectGetMidY(top.view.bounds), 0, 0);
		popover.permittedArrowDirections = 0;
	}

	[top presentViewController:controller animated:YES completion:nil];
}

void iostools_alert_show(int requestId, const char *title, const char *message, const char *buttons, int style, int cancelIndex, int destructiveIndex)
{
	NSString *alertTitle = iostools_ns(title);
	NSString *alertMessage = iostools_ns(message);
	NSArray<NSString *> *labels = iostools_parse_list(buttons);

	iostools_main(^{
		UIAlertControllerStyle controllerStyle = style == 1 ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert;
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle.length > 0 ? alertTitle : nil message:alertMessage.length > 0 ? alertMessage : nil preferredStyle:controllerStyle];
		NSArray<NSString *> *items = labels.count > 0 ? labels : @[@"OK"];

		for (NSUInteger i = 0; i < items.count; i++)
		{
			UIAlertActionStyle actionStyle = UIAlertActionStyleDefault;

			if ((int)i == cancelIndex)
				actionStyle = UIAlertActionStyleCancel;
			else if ((int)i == destructiveIndex)
				actionStyle = UIAlertActionStyleDestructive;

			NSInteger index = (NSInteger)i;

			[alert addAction:[UIAlertAction actionWithTitle:items[i] style:actionStyle handler:^(UIAlertAction *action) {
				iostools_emit(@"alert", @{@"id": @(requestId), @"index": @(index), @"label": action.title ?: @""});
			}]];
		}

		iostools_present(alert);
	});
}

void iostools_alert_prompt(int requestId, const char *title, const char *message, const char *placeholder, const char *text, const char *confirm, const char *cancel, bool secure)
{
	NSString *alertTitle = iostools_ns(title);
	NSString *alertMessage = iostools_ns(message);
	NSString *fieldPlaceholder = iostools_ns(placeholder);
	NSString *fieldText = iostools_ns(text);
	NSString *confirmLabel = iostools_ns(confirm);
	NSString *cancelLabel = iostools_ns(cancel);

	iostools_main(^{
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle.length > 0 ? alertTitle : nil message:alertMessage.length > 0 ? alertMessage : nil preferredStyle:UIAlertControllerStyleAlert];

		[alert addTextFieldWithConfigurationHandler:^(UITextField *field) {
			field.placeholder = fieldPlaceholder;
			field.text = fieldText;
			field.secureTextEntry = secure;
		}];

		__weak UIAlertController *weakAlert = alert;

		[alert addAction:[UIAlertAction actionWithTitle:cancelLabel.length > 0 ? cancelLabel : @"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
			iostools_emit(@"prompt", @{@"id": @(requestId), @"confirmed": @NO, @"text": @""});
		}]];

		[alert addAction:[UIAlertAction actionWithTitle:confirmLabel.length > 0 ? confirmLabel : @"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			NSString *value = weakAlert.textFields.firstObject.text ?: @"";
			iostools_emit(@"prompt", @{@"id": @(requestId), @"confirmed": @YES, @"text": value});
		}]];

		iostools_present(alert);
	});
}

void iostools_toast_show(const char *message, double duration)
{
	NSString *text = iostools_ns(message);
	NSTimeInterval visible = duration > 0.0 ? duration : 2.0;

	iostools_main(^{
		UIWindow *window = iostools_key_window();

		if (window == nil || text.length == 0)
			return;

		UILabel *label = [[UILabel alloc] init];
		label.text = text;
		label.textColor = [UIColor whiteColor];
		label.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
		label.textAlignment = NSTextAlignmentCenter;
		label.numberOfLines = 0;

		UIView *container = [[UIView alloc] init];
		container.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.85];
		container.layer.cornerRadius = 12.0;
		container.clipsToBounds = YES;
		container.alpha = 0.0;
		container.userInteractionEnabled = NO;
		[container addSubview:label];

		CGFloat maxWidth = window.bounds.size.width * 0.8;
		CGSize size = [label sizeThatFits:CGSizeMake(maxWidth - 32.0, CGFLOAT_MAX)];
		CGFloat width = MIN(maxWidth, size.width + 32.0);
		CGFloat height = size.height + 20.0;
		CGFloat bottom = window.safeAreaInsets.bottom + 48.0;

		container.frame = CGRectMake((window.bounds.size.width - width) / 2.0, window.bounds.size.height - bottom - height, width, height);
		label.frame = CGRectMake(16.0, 10.0, width - 32.0, size.height);

		[window addSubview:container];

		[UIView animateWithDuration:0.25 animations:^{
			container.alpha = 1.0;
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.25 delay:visible options:UIViewAnimationOptionCurveEaseIn animations:^{
				container.alpha = 0.0;
			} completion:^(BOOL done) {
				[container removeFromSuperview];
			}];
		}];
	});
}
