typedef void (^onViewInflated)(UIView *);

@interface BILayoutInflaterWatcher : NSObject
- (id)initWithFilePath:(NSString *)fileInBundlePath;

- (void)fillView:(UIView *)superview;
- (void)fillViewOfController:(UIViewController *)controller;

+ (void)setRootProjectPath:(NSString *)path;


+ (BILayoutInflaterWatcher *)watchingInflaterFor:(NSString *)path;
+ (BILayoutInflaterWatcher *)watchingInflaterForLayout:(NSString *)name;
@end