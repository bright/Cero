#import "BILayoutInflaterWatcher.h"
#import "BIInflatedViewHelper.h"
#import "BILayoutInflater.h"
#import "BIFileWatcher.h"
#import "BIEXTScope.h"
#import "BIInflatedViewContainer.h"
#import "BICallbacks.h"


@implementation BILayoutInflaterWatcher {
    BILayoutInflater *_layoutInflater;
    NSString *_fileInBundlePath;
    BIFileWatcher *_changes;
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
    return [self initWithFilePath:fileInBundlePath andWatchForChangesInPath:[BILayoutInflaterWatcher findDiskPath:fileInBundlePath]];
}

- (instancetype)initWithFilePath:(NSString *)fileInBundlePath andWatchForChangesInPath:(NSString *)projectPath {
    return [self initWithFilePath:fileInBundlePath andWatchForChanges:[BIFileWatcher fileWatcher:projectPath]];
}

- (instancetype)initWithFilePath:(NSString *)fileInBundlePath andWatchForChanges:(BIFileWatcher *)changes {
    self = [self init];
    if (self) {
        _fileInBundlePath = fileInBundlePath;
        _changes = changes;
    }
    return self;
}

+ (BILayoutInflaterWatcher *)watchingInflaterFor:(NSString *)path {
    return [[self alloc] initWithFilePath:path];
}


+ (BILayoutInflaterWatcher *)watchingInflaterForLayout:(NSString *)name {
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
    @weakify(self);
    _changes.onContentChange = ^(NSString *path, NSData *content) {
        @strongify(self);
        [self fillSuperview:view
       withViewInflatedFrom:path
                 useContent:content
                  andCall:notify];
    };
}

- (void)fillSuperview:(UIView *)view withViewInflatedFrom:(NSString *)from useContent:(NSData *)content andCall:(OnViewInflated)notify {
    BIInflatedViewContainer *uiView = [self updateSuperView:view withInflatedViewFromPath:from withContent:content];
    if (notify != nil) {
        notify(uiView);
    }
}

- (void)fillSuperview:(UIView *)view withViewInflatedFrom:(NSString *)path andCall:(OnViewInflated)notify {
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self fillSuperview:view withViewInflatedFrom:path useContent:data andCall:notify];
}

- (BIInflatedViewContainer *)updateSuperView:(UIView *)superView withInflatedViewFromPath:(NSString *)path withContent:(NSData *)content {
    BIInflatedViewContainer *newView = [_layoutInflater inflateFilePath:path withContent:content];
    [superView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [superView addSubview:newView.root];
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