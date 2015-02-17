#import <Foundation/Foundation.h>
#import "BILayoutLoader.h"

@class BIContentChangeObserver;
@class BIInflatedViewContainer;
@class BIBuildersCache;

@interface BILayoutLoader (BIIncludeAssistance)
- (NSString *)layoutPath:(NSString *)layoutName;

- (BIInflatedViewContainer *)reloadSuperview:(UIView *)superview path:(NSString *)path notify:(OnViewInflated)notify;
@end