#import "BILayoutInflaterWatcher.h"
#import "BILayoutInflater.h"
#import "BIFileWatcher.h"
#import "BIEXTScope.h"
#import "BILayoutInflaterWatcher.h"
#import "BIFileWatcher.h"


@implementation BILayoutInflaterWatcher {
    BILayoutInflater *_layoutInflater;
    NSString *_fileInBundlePath;
    BIFileWatcher *_changes;
}
static NSString *_rootProjectPath;

- (id)init {
    self = [super init];
    if (self) {
        _layoutInflater = [BILayoutInflater new];
    }

    return self;
}

- (id)initWithFilePath:(NSString *)fileInBundlePath {
    return [self initWithFilePath:fileInBundlePath andWatchForChangesInPath:[BILayoutInflaterWatcher findDiskPath:fileInBundlePath]];
}

- (id)initWithFilePath:(NSString *)fileInBundlePath andWatchForChangesInPath:(NSString *)projectPath {
    return [self initWithFilePath:fileInBundlePath andWatchForChanges:[BIFileWatcher fileWatcher:projectPath]];
}

- (id)initWithFilePath:(NSString *)fileInBundlePath andWatchForChanges:(BIFileWatcher *)changes {
    self = [self init];
    if (self) {
        _fileInBundlePath = fileInBundlePath;
        _changes = changes;
    }
    return self;
}

+ (BILayoutInflaterWatcher *)watcherInflaterFor:(NSString *)path {
    return [[self alloc] initWithFilePath:path];
}

- (void)fillView:(UIView *)superview {
    [self fillView:superview andNotify:nil];
}

- (void)fillView:(UIView *)view andNotify:(onViewInflated)notify {
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

- (void)fillSuperview:(UIView *)view withViewInflatedFrom:(NSString *)from useContent:(NSData *)content andCall:(onViewInflated)notify {
    UIView *uiView = [self updateSuperView:view withInflatedViewFromPath:from withContent:content];
    if (notify != nil) {
        notify(uiView);
    }
}

- (void)fillSuperview:(UIView *)view withViewInflatedFrom:(NSString *)path andCall:(onViewInflated)notify {
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self fillSuperview:view withViewInflatedFrom:path useContent:data andCall:notify];
}

- (UIView *)updateSuperView:(UIView *)superView withInflatedViewFromPath:(NSString *)path withContent:(NSData *)content {
    UIView *newView = [_layoutInflater inflateFilePath:path withContent:content];
    [superView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [superView addSubview:newView];
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