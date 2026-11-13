#ifndef IOSTOOLS_INTERNAL_H
#define IOSTOOLS_INTERNAL_H

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include "iostools.h"

char *iostools_copy(NSString *value);
NSString *iostools_ns(const char *value);
NSArray<NSString *> *iostools_parse_list(const char *json);
void iostools_present(UIViewController *controller);
void iostools_emit(NSString *event, NSDictionary *data);
void iostools_main(dispatch_block_t block);
UIWindow *iostools_key_window(void);
UIViewController *iostools_top_controller(void);

#endif
