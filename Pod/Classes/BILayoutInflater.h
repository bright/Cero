@class UIView;
@class BIInflatedViewContainer;
@class BIViewHierarchyBuilder;
@class BILayoutConfiguration;

@interface BILayoutInflater : NSObject
+ (instancetype)defaultInflater;
+ (instancetype)inflaterWithConfiguration:(BILayoutConfiguration *)configuration;

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath withContentString:(NSString *)content;
- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath;
- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath withContent:(NSData *)content;
@end