@interface BILayoutLoader : NSObject
- (id)initWithFilePath:(NSString *)fileInBundlePath;

- (void)fillView:(UIView *)superview;

- (void)fillViewOfController:(UIViewController *)controller;


+ (BILayoutLoader *)watchingInflaterForLayout:(NSString *)name;
@end