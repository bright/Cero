typedef void (^onViewInflated)(UIView *);

@interface BILayoutInflaterWatcher : NSObject
- (id)initWithFilePath:(NSString *)fileInBundlePath;

- (void)fillView:(UIView *)superview;

+ (void)setRootProjectPath:(NSString *)path;


+ (BILayoutInflaterWatcher *)watcherInflaterFor:(NSString *)path;
@end