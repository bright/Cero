#import "BIBuildersCache.h"
#import "BIViewHierarchyBuilder.h"
#import "BIContentChanges.h"
#import "BIContentChangeObserver.h"

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
    NSData *fileContent = [self readFile:inBundlePath];
    if (inBundlePath.length == 0) {
        return builderFactory(fileContent);
    }
    BIViewHierarchyBuilder *cachedBuilder = _cache[inBundlePath];
    if (cachedBuilder == nil) {
        cachedBuilder = _cache[inBundlePath] = builderFactory(fileContent);
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

- (void)invalidateFilePath:(NSString *)inBundlePath withNewContent:(NSData *)content {
    [_cache removeObjectForKey:inBundlePath];
    _oneTimeCacheContent[inBundlePath] = content;
}
@end