@class UIView;

@interface BILayoutInflater : NSObject
- (UIView *)inflateFilePath:(NSString *)filePath withContentString:(NSString *)content;

- (UIView *)inflateFilePath:(NSString *)filePath;
- (UIView *)inflateFilePath:(NSString *)filePath withContent:(NSData *)content;
@end