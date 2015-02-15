#import "BILayoutLoader.h"
#import "BIInflatedViewHelper.h"
#import "BILayoutInflater.h"
#import "BIInflatedViewContainer.h"


@implementation BILayoutLoader {
    BILayoutInflater *_layoutInflater;
    NSString *_fileInBundlePath;
}
static NSString *_rootProjectPath;

- (instancetype)init {
    self = [super init];
    if (self) {
        _layoutInflater = [BILayoutInflater defaultInflater];
    }

    return self;
}

- (instancetype)initWithFilePath:(NSString *)fileInBundlePath {
    self = [self init];
    if (self) {
        _fileInBundlePath = fileInBundlePath;
    }
    return self;
}


+ (BILayoutLoader *)watchingInflaterForLayout:(NSString *)name {
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:name ofType:@"xml"];
    return [[self alloc] initWithFilePath:fullPath];
}

- (void)fillView:(UIView *)superview {
    [self fillView:superview andNotify:nil];
}

- (void)fillViewOfController:(UIViewController *)controller {
    [self fillView:controller.view];
}


- (void)fillView:(UIView *)view andNotify:(OnViewInflated)notify {
    [self fillSuperview:view withViewInflatedFrom:_fileInBundlePath andCall:notify];
}

- (void)fillSuperview:(UIView *)view withViewInflatedFrom:(NSString *)from andCall:(OnViewInflated)notify {
    [self updateSuperView:view withInflatedViewFromPath:from andCall:notify];
}

- (BIInflatedViewContainer *)updateSuperView:(UIView *)superView withInflatedViewFromPath:(NSString *)path andCall:(OnViewInflated)notify {
    [superView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    BIInflatedViewContainer *newView = [_layoutInflater inflateFilePath:path superview:superView callback:NULL];
    return newView;
}

+ (NSString *)findDiskPath:(NSString *)inBundlePath {
    NSString *bundleRootPath = [[NSBundle mainBundle] bundlePath];
    NSString *relativeFileInBundlePath = [inBundlePath substringFromIndex:bundleRootPath.length];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:_rootProjectPath];
    for (NSString *relativeProjectPath in enumerator) {
        if ([relativeProjectPath hasSuffix:relativeFileInBundlePath]) {
            return [_rootProjectPath stringByAppendingPathComponent:relativeProjectPath];
        }
    }
    return nil;
}

+ (void)setRootProjectPath:(NSString *)path {
    _rootProjectPath = path;
}

@end