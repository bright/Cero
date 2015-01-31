@class UIView;
@class BIInflatedViewContainer;

@interface BILayoutInflater : NSObject
- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath withContentString:(NSString *)content;

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath;
- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath withContent:(NSData *)content;
@end