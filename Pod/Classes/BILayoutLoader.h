@interface BILayoutLoader : NSObject
- (id)initWithFilePath:(NSString *)fileInBundlePath;

- (void)fillView:(UIView *)superview;

- (void)fillViewOfController:(UIViewController *)controller;

+ (void)setRootProjectPath:(NSString *)path;


+ (BILayoutLoader *)watchingInflaterForLayout:(NSString *)name;
@end