#import "BIBuildersCache.h"
#import "BIViewHierarchyBuilder.h"

@implementation BIBuildersCache {
    NSMutableDictionary *_cache;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary new];
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

- (NSData *)readFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

@end