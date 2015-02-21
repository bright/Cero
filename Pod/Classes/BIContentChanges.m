#import "BIContentChanges.h"
#import "BIContentChangeObserver.h"
#import "BIFileWatcher.h"
#import "BIEXTScope.h"
#import "BIBuildersCache.h"

@implementation BIContentChanges {

    NSMutableDictionary *_observers;
    NSMapTable *_fileWatchers;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _observers = NSMutableDictionary.new;
        _fileWatchers = [NSMapTable strongToWeakObjectsMapTable];
    }

    return self;
}

- (BIContentChangeObserver *)contentChangedObserver:(NSString *)inBundlePath
                                    rootProjectPath:(NSString *)rootProjectPath {
    BIContentChangeObserver *resultObserver = _observers[inBundlePath];
    if (resultObserver == nil) {
        NSString *diskPath = [self findDiskPath:inBundlePath rootProjectPath:rootProjectPath];
        if (diskPath.length > 0) {
            id <BIContentChangeObservable> watcher = [self fileContentWatcher:diskPath];
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

- (void)addChangeSource:(NSString *)inBundlePath contentChangeObserver:(NSString *)rootInBundlePath rootProjectPath:(NSString *)rootProjectPath {
    BIContentChangeObserver *contentChangeObserver = [self contentChangedObserver:rootInBundlePath rootProjectPath:rootProjectPath];
    NSString *diskPath = [self findDiskPath:inBundlePath rootProjectPath:rootProjectPath];
    if (diskPath != nil) {
        [contentChangeObserver addObservable:[self fileContentWatcher:diskPath]];
    }
}

- (id <BIContentChangeObservable>)fileContentWatcher:(NSString *)diskPath {
    NSAssert(diskPath != nil, @"Disk path must not be nil");
    BIFileWatcher *watcher = [_fileWatchers objectForKey:diskPath];
    if (watcher == nil) {
        watcher = [BIFileWatcher fileWatcher:diskPath];
        [_fileWatchers setObject:watcher forKey:diskPath];
    }
    return watcher;
}

- (NSString *)findDiskPath:(NSString *)inBundlePath rootProjectPath:(NSString *)rootProjectPath {
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