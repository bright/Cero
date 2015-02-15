#import "BIContentChanges.h"
#import "BIContentChangeObserver.h"
#import "BIFileWatcher.h"
#import "BIEXTScope.h"
#import "BIBuildersCache.h"

@implementation BIContentChanges {

    NSMutableDictionary *_observers;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _observers = NSMutableDictionary.new;
    }

    return self;
}

- (BIContentChangeObserver *)contentChangedObserver:(NSString *)inBundlePath
                                    rootProjectPath:(NSString *)rootProjectPath {
    BIContentChangeObserver *resultObserver = _observers[inBundlePath];
    if (resultObserver == nil) {
        NSString *diskPath = [self findDiskPath:inBundlePath rootProjectPath:rootProjectPath];
        if (diskPath.length > 0) {
            BIFileWatcher *watcher = [BIFileWatcher fileWatcher:diskPath];
            BIContentChangeObserver *observer = [BIContentChangeObserver observer:watcher];
            observer.inBundlePath = inBundlePath;
            @weakify(self);
            [observer addContentChangedHandler:^(NSString *path, NSData *content) {
                @strongify(self);
                [self.cache invalidateFilePath:inBundlePath withNewContent:content];
            }                          boundTo:self.cache];
            resultObserver = _observers[inBundlePath] = observer;
        } else {
            NSLog(@"WARN: Disk path not found for file %@ (root path: %@)", inBundlePath, rootProjectPath);
        }
    }
    return resultObserver;
}

- (NSString *)findDiskPath:(NSString *)inBundlePath rootProjectPath:(NSString *)rootProjectPath {
    NSString *bundleRootPath = [[NSBundle mainBundle] bundlePath];
    NSString *relativeFileInBundlePath = [inBundlePath lastPathComponent];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:rootProjectPath];
    for (NSString *relativeProjectPath in enumerator) {
        if ([relativeProjectPath hasSuffix:relativeFileInBundlePath]) {
            return [rootProjectPath stringByAppendingPathComponent:relativeProjectPath];
        }
    }
    return nil;
}
@end