#import "IOSToolsInternal.h"

void iostools_clipboard_set_text(const char *text)
{
	[UIPasteboard generalPasteboard].string = iostools_ns(text);
}

char *iostools_clipboard_get_text(void)
{
	return iostools_copy([UIPasteboard generalPasteboard].string ?: @"");
}

bool iostools_clipboard_has_text(void)
{
	return [UIPasteboard generalPasteboard].hasStrings;
}

void iostools_clipboard_clear(void)
{
	[UIPasteboard generalPasteboard].items = @[];
}
