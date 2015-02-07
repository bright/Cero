@class UIView;
@class BIInflatedViewContainer;
@class BIViewHierarchyBuilder;
@class BILayoutConfiguration;
@protocol BIInflatedViewHelper;

@interface BILayoutInflater : NSObject
+ (instancetype)defaultInflater;

+ (instancetype)inflaterWithConfiguration:(BILayoutConfiguration *)configuration;

- (NSObject <BIInflatedViewHelper> *)inflateFilePath:(NSString *)filePath withContentString:(NSString *)content;

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath;

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath withContent:(NSData *)content;

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath withContent:(NSData *)content inSuperview:(UIView *)superview;
@end