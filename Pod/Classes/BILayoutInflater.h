@class UIView;
@class BIInflatedViewContainer;
@class BIViewHierarchyBuilder;
@class BILayoutConfiguration;
@class BIBuildersCache;
@protocol BIInflatedViewHelper;

typedef void (^OnViewInflated)(id <BIInflatedViewHelper>);

@interface BILayoutInflater : NSObject
+ (instancetype)defaultInflater;

+ (instancetype)inflaterWithConfiguration:(BILayoutConfiguration *)configuration;

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath superview:(UIView *)superview;

- (BIViewHierarchyBuilder *)inflateFilePath:(NSString *)filePath superview:(UIView *)superview content:(NSData *)content;

- (BIBuildersCache *)buildersCache;

- (NSString *)layoutPath:(NSString *)layoutName;

- (BIInflatedViewContainer *)reloadSuperview:(UIView *)view path:(NSString *)path notify:(OnViewInflated)notify;
@end