#import "BIBuildersCache.h"
#import "BIViewHierarchyBuilder.h"
#import "BIContentChanges.h"
#import "BIContentChangeObserver.h"
#import "BILog.h"

#undef BILogDebug
#define BILogDebug(...)

@implementation BIBuildersCache {
    NSMutableDictionary *_cache;
    BIContentChanges *_watchers;
    NSMutableDictionary *_oneTimeCacheContent;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary new];
        _oneTimeCacheContent = [NSMutableDictionary new];
        _watchers = [BIContentChanges new];
        _watchers.cache = self;
    }

    return self;
}

- (BIViewHierarchyBuilder *)cachedBuilderFor:(NSString *)inBundlePath
                                       onNew:(BuilderFactory)builderFactory
                                    onCached:(CachedBuilderFactory)cachedFactory {
    NSAssert(inBundlePath.length > 0, @"In bundle path may not be empty");
    NSData *fileContent = [self readFile:inBundlePath];

    BIViewHierarchyBuilder *cachedBuilder = _cache[inBundlePath];
    if (cachedBuilder == nil) {
        BILogDebug(@"No cached builer for path %@", inBundlePath.lastPathComponent);
        cachedBuilder = builderFactory(fileContent);
        if (cachedBuilder != nil) {
            _cache[inBundlePath] = cachedBuilder;
        }
    } else {
        cachedBuilder = _cache[inBundlePath] = cachedFactory(cachedBuilder);
    }
    return cachedBuilder;

}

- (NSData *)readFile:(NSString *)inBundlePath {
    NSData *data = _oneTimeCacheContent[inBundlePath];
    if (data == nil) {
        data = [NSData dataWithContentsOfFile:inBundlePath];
    }
    [_oneTimeCacheContent removeObjectForKey:inBundlePath];

    return data;
}

- (BIContentChangeObserver *)contentChangedObserver:(NSString *)inBundlePath {
    return [_watchers contentChangedObserver:inBundlePath rootProjectPath:_rootProjectPath];
}

- (void)setupInvalidateOnContentChange:(NSString *)inBundlePath {
    [_watchers contentChangedObserver:inBundlePath rootProjectPath:_rootProjectPath];
}

- (void)invalidateFilePath:(NSString *)inBundlePath withNewContent:(NSData *)content {
    BILogInfo(@"Invalidating builder for path %@", inBundlePath.lastPathComponent);
    BIViewHierarchyBuilder *builder = _cache[inBundlePath];
    [_cache removeObjectForKey:inBundlePath];
    [builder invalidate];
    _oneTimeCacheContent[inBundlePath] = content;
}

- (void)addReloadSource:(NSString *)inBundlePath contentChangeObserver:(NSString *)rootInBundlePath {
    [_watchers addNeedsReloadSource:inBundlePath toContentChangeObserver:rootInBundlePath rootProjectPath:_rootProjectPath];
}
@end