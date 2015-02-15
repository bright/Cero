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
    if (inBundlePath.length == 0) {
        return builderFactory();
    }
    BIViewHierarchyBuilder *cachedBuilder = _cache[inBundlePath];
    if (cachedBuilder == nil) {
        cachedBuilder = _cache[inBundlePath] = builderFactory();
    } else {
        cachedBuilder = _cache[inBundlePath] = cachedFactory(cachedBuilder);
    }

    return cachedBuilder;

}

@end