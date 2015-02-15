#import <Cero/BICallbacks.h>

@interface BILayoutLoader : NSObject
- (id)initWithFilePath:(NSString *)fileInBundlePath;

- (void)fillView:(UIView *)superview;

- (void)fillViewOfController:(UIViewController *)controller;

- (void)fillViewOfController:(UIViewController *)controller andNotify:(OnViewInflated)notify;

+ (BILayoutLoader *)watchingInflaterForLayout:(NSString *)name;
@end