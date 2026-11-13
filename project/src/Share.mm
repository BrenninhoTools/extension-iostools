#import "IOSToolsInternal.h"

void iostools_share(int requestId, const char *text, const char *url, const char *files)
{
	NSString *shareText = iostools_ns(text);
	NSString *shareURL = iostools_ns(url);
	NSArray<NSString *> *sharePaths = iostools_parse_list(files);

	iostools_main(^{
		NSMutableArray *items = [NSMutableArray array];

		if (shareText.length > 0)
			[items addObject:shareText];

		if (shareURL.length > 0)
		{
			NSURL *link = [NSURL URLWithString:shareURL];

			if (link != nil)
				[items addObject:link];
		}

		for (NSString *path in sharePaths)
		{
			if ([[NSFileManager defaultManager] fileExistsAtPath:path])
				[items addObject:[NSURL fileURLWithPath:path]];
		}

		if (items.count == 0)
		{
			iostools_emit(@"share", @{@"id": @(requestId), @"completed": @NO, @"activity": @"", @"error": @"Nothing to share"});
			return;
		}

		UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];

		controller.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *error) {
			iostools_emit(@"share", @{
				@"id": @(requestId),
				@"completed": @(completed),
				@"activity": activityType ?: @"",
				@"error": error ? error.localizedDescription : @""
			});
		};

		iostools_present(controller);
	});
}
