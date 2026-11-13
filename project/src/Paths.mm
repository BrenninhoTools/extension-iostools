#import "IOSToolsInternal.h"

static NSString *iostools_directory(NSSearchPathDirectory directory)
{
	NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
	return paths.firstObject ?: @"";
}

char *iostools_paths_documents(void)
{
	return iostools_copy(iostools_directory(NSDocumentDirectory));
}

char *iostools_paths_library(void)
{
	return iostools_copy(iostools_directory(NSLibraryDirectory));
}

char *iostools_paths_caches(void)
{
	return iostools_copy(iostools_directory(NSCachesDirectory));
}

char *iostools_paths_application_support(void)
{
	NSString *path = iostools_directory(NSApplicationSupportDirectory);

	if (path.length > 0)
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];

	return iostools_copy(path);
}

char *iostools_paths_temporary(void)
{
	return iostools_copy(NSTemporaryDirectory());
}

char *iostools_paths_bundle(void)
{
	return iostools_copy([NSBundle mainBundle].resourcePath ?: @"");
}

double iostools_paths_free_space(void)
{
	NSURL *home = [NSURL fileURLWithPath:NSHomeDirectory()];

	if (@available(iOS 11.0, *))
	{
		NSDictionary *values = [home resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:nil];
		NSNumber *capacity = values[NSURLVolumeAvailableCapacityForImportantUsageKey];

		if (capacity != nil && capacity.longLongValue > 0)
			return capacity.doubleValue;
	}

	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [attributes[NSFileSystemFreeSize] doubleValue];
}

double iostools_paths_total_space(void)
{
	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [attributes[NSFileSystemSize] doubleValue];
}

bool iostools_paths_exclude_from_backup(const char *path, bool exclude)
{
	NSString *target = iostools_ns(path);

	if (![[NSFileManager defaultManager] fileExistsAtPath:target])
		return false;

	NSURL *url = [NSURL fileURLWithPath:target];
	return [url setResourceValue:@(exclude) forKey:NSURLIsExcludedFromBackupKey error:nil];
}
