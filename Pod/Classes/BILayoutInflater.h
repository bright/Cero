#import "BICallbacks.h"

@class UIView;
@class BIInflatedViewContainer;
@class BIViewHierarchyBuilder;
@class BILayoutConfiguration;
@protocol BIInflatedViewHelper;

@interface BILayoutInflater : NSObject
+ (instancetype)defaultInflater;

+ (instancetype)inflaterWithConfiguration:(BILayoutConfiguration *)configuration;

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath superview:(UIView *)superview callback:(OnViewInflated)callback;

- (BIViewHierarchyBuilder *)inflateFilePath:(NSString *)filePath superview:(UIView *)superview content:(NSData *)content;
@end